//
//  CalculateHeatTransferUseCase.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import Foundation

/// Domain : UseCase : calculates heat transfer throughout the solar thermal system
public struct CalculateHeatTransferUseCase: CalculateHeatTransferUseCaseProtocol {
    private let environmentRepository: EnvironmentRepositoryProtocol
    private let systemStateRepository: SystemStateRepositoryProtocol
    private let configurationRepository: ConfigurationRepositoryProtocol
    private let thermodynamicsEngine: ThermodynamicsEngineProtocol

    // Assumed fluid volume in the solar panel (liters)
    private let panelFluidVolume: Double = 10.0

    public init(
        environmentRepository: EnvironmentRepositoryProtocol,
        systemStateRepository: SystemStateRepositoryProtocol,
        configurationRepository: ConfigurationRepositoryProtocol,
        thermodynamicsEngine: ThermodynamicsEngineProtocol
    ) {
        self.environmentRepository = environmentRepository
        self.systemStateRepository = systemStateRepository
        self.configurationRepository = configurationRepository
        self.thermodynamicsEngine = thermodynamicsEngine
    }

    public func execute(timeStep: Double) async throws {
        // Read current states
        let environment = try await environmentRepository.environment
        let panel = try await systemStateRepository.solarPanel
        let pump = try await systemStateRepository.pump
        let tank = try await systemStateRepository.storageTank
        let config = try await configurationRepository.configuration

        // Calculate masses
        let panelMass = panelFluidVolume * config.fluidDensity
        let tankMass = tank.volume * config.fluidDensity

        // 1. Solar heat gain in panel (W)
        let solarHeatGain = thermodynamicsEngine.calculateSolarHeatGain(
            solarIntensity: environment.solarIntensity,
            surfaceArea: panel.surfaceArea,
            absorptivity: panel.absorptivity
        )

        // 2. Heat loss from panel to ambient (W)
        let panelHeatLoss = thermodynamicsEngine.calculateHeatLoss(
            heatLossCoefficient: config.panelHeatLossCoefficient,
            surfaceArea: panel.surfaceArea,
            temperatureDifference: panel.temperature - environment.ambientTemperature
        )

        // 3. Heat transfer via fluid circulation (W) - only if pump is running
        let massFlowRate = pump.isRunning ?
            thermodynamicsEngine.calculateMassFlowRate(
                volumetricFlowRate: pump.flowRate,
                density: config.fluidDensity
            ) : 0.0

        let fluidHeatTransfer = thermodynamicsEngine.calculateFluidHeatTransfer(
            massFlowRate: massFlowRate,
            specificHeat: config.specificHeat,
            temperatureDifference: panel.temperature - tank.temperature
        )

        // 4. Heat loss from tank to ambient (W)
        let tankHeatLoss = thermodynamicsEngine.calculateHeatLoss(
            heatLossCoefficient: config.tankHeatLossCoefficient,
            surfaceArea: config.tankSurfaceArea,
            temperatureDifference: tank.temperature - environment.ambientTemperature
        )

        // 5. Net heat changes (W)
        let panelNetHeat = solarHeatGain - panelHeatLoss - fluidHeatTransfer
        let tankNetHeat = fluidHeatTransfer - tankHeatLoss

        // 6. Temperature changes (°C or K - same for delta)
        let panelTempChange = thermodynamicsEngine.calculateTemperatureChange(
            heatPower: panelNetHeat,
            timeStep: timeStep,
            mass: panelMass,
            specificHeat: config.specificHeat
        )

        let tankTempChange = thermodynamicsEngine.calculateTemperatureChange(
            heatPower: tankNetHeat,
            timeStep: timeStep,
            mass: tankMass,
            specificHeat: config.specificHeat
        )

        // 7. New temperatures
        let newPanelTemp = panel.temperature + panelTempChange
        let newTankTemp = tank.temperature + tankTempChange

        // 8. Calculate total energy stored in tank (relative to reference temp of 0°C)
        let tankEnergy = thermodynamicsEngine.calculateThermalEnergy(
            mass: tankMass,
            specificHeat: config.specificHeat,
            temperature: newTankTemp
        )

        // 9. Update states
        let updatedPanel = SolarPanel(
            temperature: newPanelTemp,
            surfaceArea: panel.surfaceArea,
            absorptivity: panel.absorptivity,
            heatAbsorptionRate: solarHeatGain
        )

        let updatedTank = StorageTank(
            temperature: newTankTemp,
            volume: tank.volume,
            energyStored: tankEnergy
        )

        try await systemStateRepository.updateSolarPanel(updatedPanel)
        try await systemStateRepository.updateStorageTank(updatedTank)
    }
}
