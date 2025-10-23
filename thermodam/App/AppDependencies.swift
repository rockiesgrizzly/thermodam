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
@MainActor
@Observable
final class AppDependencies {

    init() {}

    // MARK: - Public Interface

    static var contentView: some View {
        SimulationView(viewModel: presentation.simulationViewModel)
    }
}

// MARK: - Factory Adapters

extension AppDependencies {
    /// Presentation is the only layer exposed to the app file. It consumes the domain layer.
    static var presentation: PresentationFactory {
        PresentationFactory(
            updateEnvironmentUseCase: domain.updateEnvironmentUseCase,
            togglePumpUseCase: domain.togglePumpUseCase,
            calculateHeatTransferUseCase: domain.calculateHeatTransferUseCase
        )
    }
    
    /// Domain layer consumes the data layer. It's consumed by the presentation layer above.
    private static var domain: DomainFactory {
        DomainFactory(
            environmentRepository: data.environmentRepository,
            systemStateRepository: data.systemStateRepository,
            configurationRepository: data.configurationRepository,
            thermodynamicsEngine: data.thermodynamicsEngine
        )
    }
    
    /// Being the outermost layer, data does not consume any layers. It's consumed by the domain layer above.
    private static var data: DataFactory {
        DataFactory()
    }
}
