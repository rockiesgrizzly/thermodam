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
    private let thermodynamicsRepository: ThermodynamicsRepositoryProtocol

    public init(
        environmentRepository: EnvironmentRepositoryProtocol,
        systemStateRepository: SystemStateRepositoryProtocol,
        configurationRepository: ConfigurationRepositoryProtocol,
        thermodynamicsRepository: ThermodynamicsRepositoryProtocol
    ) {
        self.environmentRepository = environmentRepository
        self.systemStateRepository = systemStateRepository
        self.configurationRepository = configurationRepository
        self.thermodynamicsRepository = thermodynamicsRepository
    }

    // MARK: - Use Cases

    public lazy var updateEnvironmentUseCase: UpdateEnvironmentUseCaseProtocol = {
        UpdateEnvironmentUseCase(environmentRepository: environmentRepository)
    }()

    public lazy var togglePumpUseCase: TogglePumpUseCaseProtocol = {
        TogglePumpUseCase(systemStateRepository: systemStateRepository)
    }()

    public lazy var calculateHeatTransferUseCase: CalculateHeatTransferUseCaseProtocol = {
        CalculateHeatTransferUseCase(
            environmentRepository: environmentRepository,
            systemStateRepository: systemStateRepository,
            configurationRepository: configurationRepository,
            thermodynamicsRepository: thermodynamicsRepository
        )
    }()

    public lazy var getSystemStateUseCase: GetSystemStateUseCaseProtocol = {
        GetSystemStateUseCase(
            environmentRepository: environmentRepository,
            systemStateRepository: systemStateRepository
        )
    }()
}
