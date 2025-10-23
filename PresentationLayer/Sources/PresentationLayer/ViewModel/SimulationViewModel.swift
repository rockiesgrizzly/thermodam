//
//  SimulationViewModel.swift
//  PresentationLayer
//
//  Created by Josh MacDonald on 10/21/25.
//

import DomainLayer
import Foundation
import Observation

/// Presentation : ViewModel : coordinates the solar thermal simulation
@Observable
@MainActor
public final class SimulationViewModel {
    private let updateEnvironmentUseCase: UpdateEnvironmentUseCaseProtocol
    private let togglePumpUseCase: TogglePumpUseCaseProtocol
    private let calculateHeatTransferUseCase: CalculateHeatTransferUseCaseProtocol

    // State
    public var environment: Environment
    public var solarPanel: SolarPanel
    public var pump: Pump
    public var storageTank: StorageTank
    public var isSimulationRunning: Bool = false

    private var simulationTask: Task<Void, Never>?
    private let timeStep: Double = 1.0
    private let updateInterval: Double = 0.1

    public init(
        updateEnvironmentUseCase: UpdateEnvironmentUseCaseProtocol,
        togglePumpUseCase: TogglePumpUseCaseProtocol,
        calculateHeatTransferUseCase: CalculateHeatTransferUseCaseProtocol
    ) {
        self.updateEnvironmentUseCase = updateEnvironmentUseCase
        self.togglePumpUseCase = togglePumpUseCase
        self.calculateHeatTransferUseCase = calculateHeatTransferUseCase

        self.environment = Environment()
        self.solarPanel = SolarPanel()
        self.pump = Pump()
        self.storageTank = StorageTank()
    }

    // MARK: - UI Interactions

    /// Responds to sun being dragged in the environment view
    public func respondToSunViewDrag(position: CGPoint, solarIntensity: Double) async {
        let newEnvironment = Environment(
            solarIntensity: solarIntensity,
            ambientTemperature: environment.ambientTemperature,
            sunPosition: position
        )
        await updateEnvironment(newEnvironment)
    }

    /// Responds to ambient temperature slider change
    public func respondToAmbientTemperatureChange(_ temperature: Double) async {
        let newEnvironment = Environment(
            solarIntensity: environment.solarIntensity,
            ambientTemperature: temperature,
            sunPosition: environment.sunPosition
        )
        await updateEnvironment(newEnvironment)
    }

    /// Responds to pump toggle button tap
    public func respondToPumpToggle() async {
        do {
            try await togglePumpUseCase.execute()
            pump = Pump(isRunning: !pump.isRunning, flowRate: pump.flowRate)
        } catch {
            print("Error toggling pump: \(error)")
        }
    }

    /// Responds to play/pause simulation button
    public func respondToSimulationToggle() {
        if isSimulationRunning {
            stopSimulation()
        } else {
            startSimulation()
        }
    }

    // MARK: - Formatted Display Properties

    /// Formatted statistics text for display
    public var statisticsText: String {
        """
        Solar Panel: \(String(format: "%.1f", solarPanel.temperature))°C
        Storage Tank: \(String(format: "%.1f", storageTank.temperature))°C
        Heat Absorbed: \(String(format: "%.0f", solarPanel.heatAbsorptionRate)) W
        Energy Stored: \(String(format: "%.0f", storageTank.energyStored / 1000)) kJ
        Pump: \(pump.isRunning ? "ON" : "OFF")
        """
    }

    /// Formatted panel temperature text
    public var panelTemperatureText: String {
        String(format: "%.1f°C", solarPanel.temperature)
    }

    /// Formatted tank temperature text
    public var tankTemperatureText: String {
        String(format: "%.1f°C", storageTank.temperature)
    }

    /// Formatted solar intensity text
    public var solarIntensityText: String {
        String(format: "%.0f W/m²", environment.solarIntensity)
    }

    /// Formatted pump status text
    public var pumpStatusText: String {
        pump.isRunning ? "ON (\(String(format: "%.1f", pump.flowRate)) L/s)" : "OFF"
    }

    // MARK: - Private Methods

    private func updateEnvironment(_ environment: Environment) async {
        do {
            try await updateEnvironmentUseCase.execute(environment: environment)
            self.environment = environment
        } catch {
            print("Error updating environment: \(error)")
        }
    }

    private func startSimulation() {
        guard !isSimulationRunning else { return }
        isSimulationRunning = true

        simulationTask = Task { [weak self] in
            while let self = self, !Task.isCancelled, self.isSimulationRunning {
                await self.runSimulationStep()
                try? await Task.sleep(for: .seconds(self.updateInterval))
            }
        }
    }

    private func stopSimulation() {
        isSimulationRunning = false
        simulationTask?.cancel()
        simulationTask = nil
    }

    private func runSimulationStep() async {
        do {
            try await calculateHeatTransferUseCase.execute(timeStep: timeStep)
            // TODO: Poll repositories for updated state
        } catch {
            print("Error in simulation step: \(error)")
        }
    }
}
