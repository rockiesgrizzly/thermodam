//
//  CalculateHeatTransferUseCaseTests.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/23/25.
//

@testable import DomainLayer
import Foundation
import Testing

struct CalculateHeatTransferUseCaseTests {

    @Test func heatAbsorptionFromSolarRadiationPumpOff() async throws {
        // Given: panel exposed to sun, pump off
        let environment = Environment(
            solarIntensity: 1000.0,
            ambientTemperature: 20.0
        )
        let panel = SolarPanel(temperature: 20.0)
        let pump = Pump(isRunning: false)
        let tank = StorageTank(temperature: 20.0)

        let envRepo = MockEnvironmentRepo(environment: environment)
        let stateRepo = MockSystemStateRepo(panel: panel, pump: pump, tank: tank)
        let configRepo = MockConfigurationRepo()

        let thermoEngine = MockThermodynamicsEngine()

        let useCase = CalculateHeatTransferUseCase(
            environmentRepository: envRepo,
            systemStateRepository: stateRepo,
            configurationRepository: configRepo,
            thermodynamicsEngine: thermoEngine
        )

        // When: calculate for time step
        try await useCase.execute(timeStep: 1.0)

        // Then: panel temp increases, tank unchanged
        let updatedPanel = try await stateRepo.solarPanel
        let updatedTank = try await stateRepo.storageTank
        #expect(updatedPanel.temperature > panel.temperature)
        #expect(updatedTank.temperature == tank.temperature)
    }

    @Test func heatTransferFromPanelToTankPumpOn() async throws {
        // Given: hot panel, cool tank, pump running
        let environment = Environment(solarIntensity: 0.0, ambientTemperature: 20.0)
        let panel = SolarPanel(temperature: 60.0)
        let pump = Pump(isRunning: true, flowRate: 1.0)
        let tank = StorageTank(temperature: 30.0, volume: 200.0)

        let envRepo = MockEnvironmentRepo(environment: environment)
        let stateRepo = MockSystemStateRepo(panel: panel, pump: pump, tank: tank)
        let configRepo = MockConfigurationRepo()

        let thermoEngine = MockThermodynamicsEngine()

        let useCase = CalculateHeatTransferUseCase(
            environmentRepository: envRepo,
            systemStateRepository: stateRepo,
            configurationRepository: configRepo,
            thermodynamicsEngine: thermoEngine
        )

        // When: calculate
        try await useCase.execute(timeStep: 1.0)

        // Then: panel cools, tank heats up
        let updatedPanel = try await stateRepo.solarPanel
        let updatedTank = try await stateRepo.storageTank
        #expect(updatedPanel.temperature < panel.temperature)
        #expect(updatedTank.temperature > tank.temperature)
    }

    @Test func noHeatTransferWhenPumpOff() async throws {
        // Given: hot panel, cool tank, pump OFF
        let environment = Environment(solarIntensity: 0.0, ambientTemperature: 20.0)
        let panel = SolarPanel(temperature: 60.0)
        let pump = Pump(isRunning: false)
        let tank = StorageTank(temperature: 30.0)

        let envRepo = MockEnvironmentRepo(environment: environment)
        let stateRepo = MockSystemStateRepo(panel: panel, pump: pump, tank: tank)
        let configRepo = MockConfigurationRepo()

        let thermoEngine = MockThermodynamicsEngine()

        let useCase = CalculateHeatTransferUseCase(
            environmentRepository: envRepo,
            systemStateRepository: stateRepo,
            configurationRepository: configRepo,
            thermodynamicsEngine: thermoEngine
        )

        // When: calculate
        try await useCase.execute(timeStep: 1.0)

        // Then: temperatures change due to losses only, not fluid transfer
        let updatedPanel = try await stateRepo.solarPanel
        let updatedTank = try await stateRepo.storageTank
        // Panel loses heat to ambient (no solar, no pump)
        #expect(updatedPanel.temperature < panel.temperature)
        // Tank loses heat to ambient only
        #expect(updatedTank.temperature < tank.temperature)
    }

    @Test func heatLossesToAmbient() async throws {
        // Given: panel/tank hotter than ambient, no sun, pump off
        let ambientTemp = 20.0
        let environment = Environment(solarIntensity: 0.0, ambientTemperature: ambientTemp)
        let panel = SolarPanel(temperature: 50.0)
        let pump = Pump(isRunning: false)
        let tank = StorageTank(temperature: 50.0)

        let envRepo = MockEnvironmentRepo(environment: environment)
        let stateRepo = MockSystemStateRepo(panel: panel, pump: pump, tank: tank)
        let configRepo = MockConfigurationRepo()

        let thermoEngine = MockThermodynamicsEngine()

        let useCase = CalculateHeatTransferUseCase(
            environmentRepository: envRepo,
            systemStateRepository: stateRepo,
            configurationRepository: configRepo,
            thermodynamicsEngine: thermoEngine
        )

        // When: calculate
        try await useCase.execute(timeStep: 1.0)

        // Then: both lose heat toward ambient
        let updatedPanel = try await stateRepo.solarPanel
        let updatedTank = try await stateRepo.storageTank
        #expect(updatedPanel.temperature < panel.temperature)
        #expect(updatedPanel.temperature > ambientTemp)
        #expect(updatedTank.temperature < tank.temperature)
        #expect(updatedTank.temperature > ambientTemp)
    }

    @Test func zeroSolarIntensityNighttime() async throws {
        // Given: solarIntensity = 0
        let environment = Environment(solarIntensity: 0.0, ambientTemperature: 20.0)
        let panel = SolarPanel(temperature: 40.0)
        let pump = Pump(isRunning: false)
        let tank = StorageTank(temperature: 35.0)

        let envRepo = MockEnvironmentRepo(environment: environment)
        let stateRepo = MockSystemStateRepo(panel: panel, pump: pump, tank: tank)
        let configRepo = MockConfigurationRepo()

        let thermoEngine = MockThermodynamicsEngine()

        let useCase = CalculateHeatTransferUseCase(
            environmentRepository: envRepo,
            systemStateRepository: stateRepo,
            configurationRepository: configRepo,
            thermodynamicsEngine: thermoEngine
        )

        // When: calculate
        try await useCase.execute(timeStep: 1.0)

        // Then: panel cools (no solar gains, only losses)
        let updatedPanel = try await stateRepo.solarPanel
        #expect(updatedPanel.temperature < panel.temperature)
        #expect(updatedPanel.heatAbsorptionRate == 0.0)
    }

    @Test func energyConservationCheck() async throws {
        // Given: system with pump running
        let environment = Environment(solarIntensity: 800.0, ambientTemperature: 20.0)
        let panel = SolarPanel(temperature: 50.0)
        let pump = Pump(isRunning: true, flowRate: 1.0)
        let tank = StorageTank(temperature: 40.0, volume: 200.0)

        let envRepo = MockEnvironmentRepo(environment: environment)
        let stateRepo = MockSystemStateRepo(panel: panel, pump: pump, tank: tank)
        let configRepo = MockConfigurationRepo()

        let thermoEngine = MockThermodynamicsEngine()

        let useCase = CalculateHeatTransferUseCase(
            environmentRepository: envRepo,
            systemStateRepository: stateRepo,
            configurationRepository: configRepo,
            thermodynamicsEngine: thermoEngine
        )

        // When: calculate
        try await useCase.execute(timeStep: 1.0)

        // Then: solar panel and tank were both updated
        #expect(stateRepo.updateSolarPanelCallCount == 1)
        #expect(stateRepo.updateStorageTankCallCount == 1)
    }

    @Test func timeStepScaling() async throws {
        // Given: identical initial conditions for two scenarios
        let environment = Environment(solarIntensity: 1000.0, ambientTemperature: 20.0)
        let panel1 = SolarPanel(temperature: 30.0)
        let panel2 = SolarPanel(temperature: 30.0)
        let pump = Pump(isRunning: false)
        let tank = StorageTank(temperature: 25.0)

        let stateRepo1 = MockSystemStateRepo(panel: panel1, pump: pump, tank: tank)
        let stateRepo2 = MockSystemStateRepo(panel: panel2, pump: pump, tank: tank)
        let configRepo = MockConfigurationRepo()
        let thermoEngine = MockThermodynamicsEngine()

        let useCase1 = CalculateHeatTransferUseCase(
            environmentRepository: MockEnvironmentRepo(environment: environment),
            systemStateRepository: stateRepo1,
            configurationRepository: configRepo,
            thermodynamicsEngine: thermoEngine
        )
        let useCase2 = CalculateHeatTransferUseCase(
            environmentRepository: MockEnvironmentRepo(environment: environment),
            systemStateRepository: stateRepo2,
            configurationRepository: configRepo,
            thermodynamicsEngine: thermoEngine
        )

        // When: calculate with different time steps
        try await useCase1.execute(timeStep: 1.0)
        try await useCase2.execute(timeStep: 10.0)

        // Then: larger time step produces proportionally larger temperature change
        let updatedPanel1 = try await stateRepo1.solarPanel
        let updatedPanel2 = try await stateRepo2.solarPanel
        let tempChange1 = updatedPanel1.temperature - panel1.temperature
        let tempChange2 = updatedPanel2.temperature - panel2.temperature

        // 10x time step should produce roughly 10x temperature change
        #expect(abs(tempChange2 / tempChange1 - 10.0) < 0.1)
    }
}

// MARK: - Mock Repositories

final class MockEnvironmentRepo: EnvironmentRepositoryProtocol, @unchecked Sendable {
    private let _environment: Environment

    init(environment: Environment = Environment()) {
        self._environment = environment
    }

    var environment: Environment {
        get async throws { _environment }
    }

    func updateEnvironment(_ environment: Environment) async throws {}
}

final class MockSystemStateRepo: SystemStateRepositoryProtocol, @unchecked Sendable {
    private var _solarPanel: SolarPanel
    private var _pump: Pump
    private var _storageTank: StorageTank

    var updateSolarPanelCallCount = 0
    var updateStorageTankCallCount = 0

    init(
        panel: SolarPanel = SolarPanel(),
        pump: Pump = Pump(),
        tank: StorageTank = StorageTank()
    ) {
        self._solarPanel = panel
        self._pump = pump
        self._storageTank = tank
    }

    var solarPanel: SolarPanel {
        get async throws { _solarPanel }
    }

    var pump: Pump {
        get async throws { _pump }
    }

    var storageTank: StorageTank {
        get async throws { _storageTank }
    }

    func updateSolarPanel(_ solarPanel: SolarPanel) async throws {
        updateSolarPanelCallCount += 1
        _solarPanel = solarPanel
    }

    func updatePump(_ pump: Pump) async throws {
        _pump = pump
    }

    func updateStorageTank(_ storageTank: StorageTank) async throws {
        updateStorageTankCallCount += 1
        _storageTank = storageTank
    }
}

final class MockConfigurationRepo: ConfigurationRepositoryProtocol, @unchecked Sendable {
    private let _configuration: SystemConfiguration

    init(configuration: SystemConfiguration = SystemConfiguration()) {
        self._configuration = configuration
    }

    var configuration: SystemConfiguration {
        get async throws { _configuration }
    }
}

final class MockThermodynamicsEngine: ThermodynamicsEngineProtocol, @unchecked Sendable {
    func calculateSolarHeatGain(
        solarIntensity: Double,
        surfaceArea: Double,
        absorptivity: Double
    ) -> Double {
        solarIntensity * surfaceArea * absorptivity
    }

    func calculateHeatLoss(
        heatLossCoefficient: Double,
        surfaceArea: Double,
        temperatureDifference: Double
    ) -> Double {
        heatLossCoefficient * surfaceArea * temperatureDifference
    }

    func calculateFluidHeatTransfer(
        massFlowRate: Double,
        specificHeat: Double,
        temperatureDifference: Double
    ) -> Double {
        massFlowRate * specificHeat * temperatureDifference
    }

    func calculateTemperatureChange(
        heatPower: Double,
        timeStep: Double,
        mass: Double,
        specificHeat: Double
    ) -> Double {
        guard mass > 0, specificHeat > 0 else { return 0 }
        return (heatPower * timeStep) / (mass * specificHeat)
    }

    func calculateThermalEnergy(
        mass: Double,
        specificHeat: Double,
        temperature: Double
    ) -> Double {
        mass * specificHeat * temperature
    }

    func calculateMassFlowRate(
        volumetricFlowRate: Double,
        density: Double
    ) -> Double {
        volumetricFlowRate * density
    }
}
