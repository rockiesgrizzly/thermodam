//
//  DomainFactory.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import Foundation

/// Factory for creating Domain layer dependencies (Use Cases)
public final class DomainFactory {
    private let environmentRepository: EnvironmentRepositoryProtocol
    private let systemStateRepository: SystemStateRepositoryProtocol
    private let configurationRepository: ConfigurationRepositoryProtocol
    private let thermodynamicsEngine: ThermodynamicsEngineProtocol

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

    // MARK: - Use Cases

    public var updateEnvironmentUseCase: UpdateEnvironmentUseCaseProtocol {
        UpdateEnvironmentUseCase(environmentRepository: environmentRepository)
    }

    public var togglePumpUseCase: TogglePumpUseCaseProtocol {
        TogglePumpUseCase(systemStateRepository: systemStateRepository)
    }

    public var calculateHeatTransferUseCase: CalculateHeatTransferUseCaseProtocol {
        CalculateHeatTransferUseCase(
            environmentRepository: environmentRepository,
            systemStateRepository: systemStateRepository,
            configurationRepository: configurationRepository,
            thermodynamicsEngine: thermodynamicsEngine
        )
    }

    public var getSystemStateUseCase: GetSystemStateUseCaseProtocol {
        GetSystemStateUseCase(
            environmentRepository: environmentRepository,
            systemStateRepository: systemStateRepository
        )
    }
}
