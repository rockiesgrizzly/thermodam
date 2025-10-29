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
        let mockEnvRepo = MockEnvironmentRepository()
        let mockStateRepo = MockSystemStateRepository()
        let useCase = UpdateEnvironmentUseCase(
            environmentRepository: mockEnvRepo,
            systemStateRepository: mockStateRepo
        )

        // When: execute with environment
        let systemState = try await useCase.execute(environment: newEnvironment)

        // Then: repository is updated and state returned
        #expect(systemState.environment == newEnvironment)
        let updatedEnvironment = try await mockEnvRepo.environment
        #expect(updatedEnvironment == newEnvironment)
    }

    @Test func repositoryUpdateIsCalledOnce() async throws {
        // Given: new environment
        let newEnvironment = Environment(solarIntensity: 750.0)
        let mockEnvRepo = MockEnvironmentRepository()
        let mockStateRepo = MockSystemStateRepository()
        let useCase = UpdateEnvironmentUseCase(
            environmentRepository: mockEnvRepo,
            systemStateRepository: mockStateRepo
        )

        // When: execute
        let systemState = try await useCase.execute(environment: newEnvironment)

        // Then: updateEnvironment() called exactly once and state returned
        #expect(mockEnvRepo.updateEnvironmentCallCount == 1)
        #expect(systemState.environment == newEnvironment)
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
        let mockEnvRepo = MockEnvironmentRepository()
        let mockStateRepo = MockSystemStateRepository()
        let useCase = UpdateEnvironmentUseCase(
            environmentRepository: mockEnvRepo,
            systemStateRepository: mockStateRepo
        )

        // When: execute
        let systemState = try await useCase.execute(environment: environment)

        // Then: all properties match in returned state and repository
        #expect(systemState.environment.solarIntensity == solarIntensity)
        #expect(systemState.environment.ambientTemperature == ambientTemp)
        #expect(systemState.environment.sunPosition.x == sunPosition.x)
        #expect(systemState.environment.sunPosition.y == sunPosition.y)

        let updated = try await mockEnvRepo.environment
        #expect(updated.solarIntensity == solarIntensity)
        #expect(updated.ambientTemperature == ambientTemp)
        #expect(updated.sunPosition.x == sunPosition.x)
        #expect(updated.sunPosition.y == sunPosition.y)
    }

    @Test func errorPropagationFromRepository() async throws {
        // Given: repository that throws error
        let mockEnvRepo = MockEnvironmentRepository(shouldThrowError: true)
        let mockStateRepo = MockSystemStateRepository()
        let useCase = UpdateEnvironmentUseCase(
            environmentRepository: mockEnvRepo,
            systemStateRepository: mockStateRepo
        )
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
        let mockEnvRepo = MockEnvironmentRepository()
        let mockStateRepo = MockSystemStateRepository()
        let useCase = UpdateEnvironmentUseCase(
            environmentRepository: mockEnvRepo,
            systemStateRepository: mockStateRepo
        )

        // When: execute multiple times
        let state1 = try await useCase.execute(environment: environment1)
        let state2 = try await useCase.execute(environment: environment2)
        let state3 = try await useCase.execute(environment: environment3)

        // Then: each returned state matches its input
        #expect(state1.environment == environment1)
        #expect(state2.environment == environment2)
        #expect(state3.environment == environment3)

        // And repository reflects latest update
        let finalEnvironment = try await mockEnvRepo.environment
        #expect(finalEnvironment == environment3)
        #expect(mockEnvRepo.updateEnvironmentCallCount == 3)
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

final class MockSystemStateRepository: SystemStateRepositoryProtocol, @unchecked Sendable {
    private var _pump: Pump
    private var _solarPanel: SolarPanel
    private var _storageTank: StorageTank

    init(
        pump: Pump = Pump(),
        solarPanel: SolarPanel = SolarPanel(),
        storageTank: StorageTank = StorageTank()
    ) {
        self._pump = pump
        self._solarPanel = solarPanel
        self._storageTank = storageTank
    }

    var pump: Pump {
        get async throws { _pump }
    }

    var solarPanel: SolarPanel {
        get async throws { _solarPanel }
    }

    var storageTank: StorageTank {
        get async throws { _storageTank }
    }

    func updatePump(_ pump: Pump) async throws {
        _pump = pump
    }

    func updateSolarPanel(_ solarPanel: SolarPanel) async throws {
        _solarPanel = solarPanel
    }

    func updateStorageTank(_ storageTank: StorageTank) async throws {
        _storageTank = storageTank
    }
}

enum MockEnvironmentError: Error {
    case repositoryError
}
