//
//  UpdateEnvironmentUseCaseTests.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/23/25.
//

@testable import DomainLayer
import Foundation
import Testing

struct UpdateEnvironmentUseCaseTests {

    @Test func environmentIsUpdatedWithProvidedValues() async throws {
        // Given: new environment data
        let newEnvironment = Environment(
            solarIntensity: 900.0,
            ambientTemperature: 25.0,
            sunPosition: CGPoint(x: 150, y: 200)
        )
        let mockRepo = MockEnvironmentRepository()
        let useCase = UpdateEnvironmentUseCase(environmentRepository: mockRepo)

        // When: execute with environment
        try await useCase.execute(environment: newEnvironment)

        // Then: repository is updated with exact values
        let updatedEnvironment = try await mockRepo.environment
        #expect(updatedEnvironment == newEnvironment)
    }

    @Test func repositoryUpdateIsCalledOnce() async throws {
        // Given: new environment
        let newEnvironment = Environment(solarIntensity: 750.0)
        let mockRepo = MockEnvironmentRepository()
        let useCase = UpdateEnvironmentUseCase(environmentRepository: mockRepo)

        // When: execute
        try await useCase.execute(environment: newEnvironment)

        // Then: updateEnvironment() called exactly once
        #expect(mockRepo.updateEnvironmentCallCount == 1)
    }

    @Test func allEnvironmentPropertiesArePreserved() async throws {
        // Given: environment with specific values
        let solarIntensity = 950.0
        let ambientTemp = 30.5
        let sunPosition = CGPoint(x: 250, y: 350)
        let environment = Environment(
            solarIntensity: solarIntensity,
            ambientTemperature: ambientTemp,
            sunPosition: sunPosition
        )
        let mockRepo = MockEnvironmentRepository()
        let useCase = UpdateEnvironmentUseCase(environmentRepository: mockRepo)

        // When: execute
        try await useCase.execute(environment: environment)

        // Then: all properties match in repository
        let updated = try await mockRepo.environment
        #expect(updated.solarIntensity == solarIntensity)
        #expect(updated.ambientTemperature == ambientTemp)
        #expect(updated.sunPosition.x == sunPosition.x)
        #expect(updated.sunPosition.y == sunPosition.y)
    }

    @Test func errorPropagationFromRepository() async throws {
        // Given: repository that throws error
        let mockRepo = MockEnvironmentRepository(shouldThrowError: true)
        let useCase = UpdateEnvironmentUseCase(environmentRepository: mockRepo)
        let environment = Environment()

        // When/Then: execute throws error
        await #expect(throws: MockEnvironmentError.self) {
            try await useCase.execute(environment: environment)
        }
    }

    @Test func multipleSequentialUpdates() async throws {
        // Given: multiple environment updates
        let environment1 = Environment(solarIntensity: 500.0, ambientTemperature: 15.0)
        let environment2 = Environment(solarIntensity: 800.0, ambientTemperature: 22.0)
        let environment3 = Environment(solarIntensity: 1000.0, ambientTemperature: 28.0)
        let mockRepo = MockEnvironmentRepository()
        let useCase = UpdateEnvironmentUseCase(environmentRepository: mockRepo)

        // When: execute multiple times
        try await useCase.execute(environment: environment1)
        try await useCase.execute(environment: environment2)
        try await useCase.execute(environment: environment3)

        // Then: repository reflects latest update
        let finalEnvironment = try await mockRepo.environment
        #expect(finalEnvironment == environment3)
        #expect(mockRepo.updateEnvironmentCallCount == 3)
    }
}

// MARK: - Mock Repository

final class MockEnvironmentRepository: EnvironmentRepositoryProtocol, @unchecked Sendable {
    private var _environment: Environment
    private let shouldThrowError: Bool

    var updateEnvironmentCallCount = 0

    init(
        environment: Environment = Environment(),
        shouldThrowError: Bool = false
    ) {
        self._environment = environment
        self.shouldThrowError = shouldThrowError
    }

    var environment: Environment {
        get async throws {
            if shouldThrowError { throw MockEnvironmentError.repositoryError }
            return _environment
        }
    }

    func updateEnvironment(_ environment: Environment) async throws {
        if shouldThrowError { throw MockEnvironmentError.repositoryError }
        updateEnvironmentCallCount += 1
        _environment = environment
    }
}

enum MockEnvironmentError: Error {
    case repositoryError
}
