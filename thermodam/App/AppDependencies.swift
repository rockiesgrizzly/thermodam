//
//  AppDependencies.swift
//  thermodam
//
//  Created by Josh MacDonald on 10/21/25.
//

import DataLayer
import DomainLayer
import PresentationLayer
import Foundation
import SwiftUI

/// `AppDependencies` provides dependency injection for the app in Clean architecture.
/// Serves as the composition root that wires up all dependencies across layers.
/// Dependency flow: App -> Presentation -> Domain -> Data (outer to inner).
struct AppDependencies {
    // MARK: - Public Interface
    @ViewBuilder
    static var contentView: some View {
        SimulationView(viewModel: presentation.simulationViewModel)
    }
}

// MARK: - Factory Adapters

extension AppDependencies {
    /// Being the outermost layer, data does not consume any layers. It's consumed by the domain layer above.
    /// Singleton instance to maintain state across app lifecycle.
    private static let data = DataFactory()

    /// Domain layer consumes the data layer. It's consumed by the presentation layer above.
    /// Singleton instance that uses the shared data factory.
    private static let domain = DomainFactory(
        environmentRepository: data.environmentRepository,
        systemStateRepository: data.systemStateRepository,
        configurationRepository: data.configurationRepository,
        thermodynamicsRepository: data.thermodynamicsRepository
    )

    /// Presentation is the only layer exposed to the app file. It consumes the domain layer.
    /// Singleton instance that uses the shared domain factory.
    static let presentation = PresentationFactory(
        updateEnvironmentUseCase: domain.updateEnvironmentUseCase,
        togglePumpUseCase: domain.togglePumpUseCase,
        calculateHeatTransferUseCase: domain.calculateHeatTransferUseCase,
        getSystemStateUseCase: domain.getSystemStateUseCase
    )
}
