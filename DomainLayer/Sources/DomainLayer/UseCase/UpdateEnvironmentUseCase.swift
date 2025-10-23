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

    public init(environmentRepository: EnvironmentRepositoryProtocol) {
        self.environmentRepository = environmentRepository
    }

    public func execute(environment: Environment) async throws {
        // Update repository with new environment state
        try await environmentRepository.updateEnvironment(environment)
    }
}
