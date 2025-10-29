//
//  UpdateEnvironmentUseCase.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import Foundation

/// Domain : UseCase : updates the environmental conditions (solar intensity, ambient temp, sun position)
public struct UpdateEnvironmentUseCase: UpdateEnvironmentUseCaseProtocol {
    private let environmentRepository: EnvironmentRepositoryProtocol
    private let systemStateRepository: SystemStateRepositoryProtocol

    public init(
        environmentRepository: EnvironmentRepositoryProtocol,
        systemStateRepository: SystemStateRepositoryProtocol
    ) {
        self.environmentRepository = environmentRepository
        self.systemStateRepository = systemStateRepository
    }

    public func execute(environment: Environment) async throws -> SystemState {
        // Update repository with new environment state
        try await environmentRepository.updateEnvironment(environment)

        // Fetch and return complete system state
        async let solarPanel = systemStateRepository.solarPanel
        async let pump = systemStateRepository.pump
        async let storageTank = systemStateRepository.storageTank

        return try await SystemState(
            environment: environment,
            solarPanel: solarPanel,
            pump: pump,
            storageTank: storageTank
        )
    }
}
