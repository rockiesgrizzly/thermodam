//
//  PresentationFactory.swift
//  PresentationLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import DomainLayer
import Foundation

/// Factory for creating Presentation layer dependencies (ViewModels)
public final class PresentationFactory {
    private let updateEnvironmentUseCase: UpdateEnvironmentUseCaseProtocol
    private let togglePumpUseCase: TogglePumpUseCaseProtocol
    private let calculateHeatTransferUseCase: CalculateHeatTransferUseCaseProtocol

    public init(
        updateEnvironmentUseCase: UpdateEnvironmentUseCaseProtocol,
        togglePumpUseCase: TogglePumpUseCaseProtocol,
        calculateHeatTransferUseCase: CalculateHeatTransferUseCaseProtocol
    ) {
        self.updateEnvironmentUseCase = updateEnvironmentUseCase
        self.togglePumpUseCase = togglePumpUseCase
        self.calculateHeatTransferUseCase = calculateHeatTransferUseCase
    }

    // MARK: - ViewModels

    @MainActor
    public var simulationViewModel: SimulationViewModel {
        SimulationViewModel(
            updateEnvironmentUseCase: updateEnvironmentUseCase,
            togglePumpUseCase: togglePumpUseCase,
            calculateHeatTransferUseCase: calculateHeatTransferUseCase
        )
    }
}

// MARK: - Simulation Child ViewModels

extension SimulationViewModel {
    public var environmentViewModel: EnvironmentViewModel {
        EnvironmentViewModel(
            solarIntensity: environment.solarIntensity,
            ambientTemperature: environment.ambientTemperature,
            sunPosition: environment.sunPosition,
            onSunDrag: respondToSunViewDrag,
            onAmbientTemperatureChange: respondToAmbientTemperatureChange
        )
    }

    public var solarPanelViewModel: SolarPanelViewModel {
        SolarPanelViewModel(
            temperature: solarPanel.temperature,
            heatAbsorptionRate: solarPanel.heatAbsorptionRate,
            surfaceArea: solarPanel.surfaceArea,
            absorptivity: solarPanel.absorptivity
        )
    }

    public var storageTankViewModel: StorageTankViewModel {
        StorageTankViewModel(
            temperature: storageTank.temperature,
            volume: storageTank.volume,
            energyStored: storageTank.energyStored
        )
    }

    public var statisticsViewModel: StatisticsViewModel {
        StatisticsViewModel(
            panelTemperature: solarPanel.temperature,
            tankTemperature: storageTank.temperature,
            heatAbsorbed: solarPanel.heatAbsorptionRate,
            energyStored: storageTank.energyStored,
            pumpRunning: pump.isRunning,
            flowRate: pump.flowRate,
            solarIntensity: environment.solarIntensity
        )
    }
}

