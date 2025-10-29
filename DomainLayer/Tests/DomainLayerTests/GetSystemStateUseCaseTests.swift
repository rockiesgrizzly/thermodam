//
//  GetSystemStateUseCaseTests.swift
//  DomainLayerTests
//
//  Created by Josh MacDonald on 10/23/25.
//

import Foundation
import Testing
@testable import DomainLayer

@Suite("GetSystemStateUseCase Tests")
struct GetSystemStateUseCaseTests {

    @Test("should retrieve complete system state from repositories")
    func retrievesCompleteSystemState() async throws {
        // Given
        let testEnvironment = Environment(
            solarIntensity: 850.0,
            ambientTemperature: 22.0,
            sunPosition: CGPoint(x: 100, y: 50)
        )
        let testPanel = SolarPanel(temperature: 45.0, heatAbsorptionRate: 2500.0)
        let testPump = Pump(isRunning: true, flowRate: 2.5)
        let testTank = StorageTank(temperature: 32.0, volume: 200.0, energyStored: 26_800_000.0)

        let mockEnvironmentRepo = MockEnvironmentRepository(environment: testEnvironment)
        let mockSystemStateRepo = MockSystemStateRepository(
            pump: testPump,
            solarPanel: testPanel,
            storageTank: testTank
        )
        let useCase = GetSystemStateUseCase(
            environmentRepository: mockEnvironmentRepo,
            systemStateRepository: mockSystemStateRepo
        )

        // When
        let systemState = try await useCase.systemState

        // Then
        #expect(systemState.environment.solarIntensity == 850.0)
        #expect(systemState.environment.ambientTemperature == 22.0)
        #expect(systemState.solarPanel.temperature == 45.0)
        #expect(systemState.pump.isRunning == true)
        #expect(systemState.storageTank.temperature == 32.0)
    }

    @Test("should combine data from both repositories into SystemState")
    func combinesDataCorrectly() async throws {
        // Given
        let mockEnvironmentRepo = MockEnvironmentRepository()
        let mockSystemStateRepo = MockSystemStateRepository()
        let useCase = GetSystemStateUseCase(
            environmentRepository: mockEnvironmentRepo,
            systemStateRepository: mockSystemStateRepo
        )

        // When
        let systemState = try await useCase.systemState

        // Then - verify all components are present
        #expect(systemState.environment.solarIntensity > 0)
        #expect(systemState.solarPanel.heatAbsorptionRate >= 0)
        #expect(systemState.pump.flowRate >= 0)
        #expect(systemState.storageTank.volume > 0)
    }

    @Test("should handle repository errors gracefully")
    func handlesRepositoryErrors() async throws {
        // Given
        let mockEnvironmentRepo = MockEnvironmentRepository(shouldThrowError: true)
        let mockSystemStateRepo = MockSystemStateRepository()
        let useCase = GetSystemStateUseCase(
            environmentRepository: mockEnvironmentRepo,
            systemStateRepository: mockSystemStateRepo
        )

        // When/Then - should propagate the error
        do {
            _ = try await useCase.systemState
            Issue.record("Expected error to be thrown")
        } catch {
            // Expected to throw - test passes if we reach here
        }
    }
}

// MARK: - Mock Repositories

final class MockEnvironmentRepository: EnvironmentRepositoryProtocol, @unchecked Sendable {
    private var _environment: Environment
    private let shouldThrowError: Bool

    init(environment: Environment = Environment(), shouldThrowError: Bool = false) {
        self._environment = environment
        self.shouldThrowError = shouldThrowError
    }

    var environment: Environment {
        get async throws {
            if shouldThrowError { throw MockError.repositoryError }
            return _environment
        }
    }

    func updateEnvironment(_ environment: Environment) async throws {
        if shouldThrowError { throw MockError.repositoryError }
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

enum MockError: Error {
    case repositoryError
}
