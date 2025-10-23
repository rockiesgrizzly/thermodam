//
//  TogglePumpUseCaseTests.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/23/25.
//

import Testing
@testable import DomainLayer

struct TogglePumpUseCaseTests {

    @Test func togglePumpFromOffToOn() async throws {
        // Given: pump is off
        let initialPump = Pump(isRunning: false, flowRate: 1.0)
        let mockRepo = MockSystemStateRepository(pump: initialPump)
        let useCase = TogglePumpUseCase(systemStateRepository: mockRepo)

        // When: execute toggle
        try await useCase.execute()

        // Then: pump should be on
        let updatedPump = try await mockRepo.pump
        #expect(updatedPump.isRunning == true)
    }

    @Test func togglePumpFromOnToOff() async throws {
        // Given: pump is on
        let initialPump = Pump(isRunning: true, flowRate: 1.0)
        let mockRepo = MockSystemStateRepository(pump: initialPump)
        let useCase = TogglePumpUseCase(systemStateRepository: mockRepo)

        // When: execute toggle
        try await useCase.execute()

        // Then: pump should be off
        let updatedPump = try await mockRepo.pump
        #expect(updatedPump.isRunning == false)
    }

    @Test func updateRepositoryIsCalledWithToggledState() async throws {
        // Given: pump with specific state
        let initialPump = Pump(isRunning: false, flowRate: 1.0)
        let mockRepo = MockSystemStateRepository(pump: initialPump)
        let useCase = TogglePumpUseCase(systemStateRepository: mockRepo)

        // When: execute toggle
        try await useCase.execute()

        // Then: repository was updated
        #expect(mockRepo.updatePumpCallCount == 1)
        #expect(mockRepo.lastUpdatedPump?.isRunning == true)
    }

    @Test func flowRateIsPreservedWhenToggling() async throws {
        // Given: pump with custom flow rate
        let customFlowRate = 1.5
        let initialPump = Pump(isRunning: false, flowRate: customFlowRate)
        let mockRepo = MockSystemStateRepository(pump: initialPump)
        let useCase = TogglePumpUseCase(systemStateRepository: mockRepo)

        // When: execute toggle
        try await useCase.execute()

        // Then: flow rate is preserved
        let updatedPump = try await mockRepo.pump
        #expect(updatedPump.flowRate == customFlowRate)
    }

    @Test func errorPropagationFromRepository() async throws {
        // Given: repository that throws error
        let mockRepo = MockSystemStateRepository(shouldThrowError: true)
        let useCase = TogglePumpUseCase(systemStateRepository: mockRepo)

        // When/Then: execute toggle throws error
        await #expect(throws: MockError.self) {
            try await useCase.execute()
        }
    }
}

// MARK: - Mock Repository

final class MockSystemStateRepository: SystemStateRepositoryProtocol, @unchecked Sendable {
    private var _pump: Pump
    private let shouldThrowError: Bool

    var updatePumpCallCount = 0
    var lastUpdatedPump: Pump?

    init(
        pump: Pump = Pump(),
        solarPanel: SolarPanel = SolarPanel(),
        storageTank: StorageTank = StorageTank(),
        shouldThrowError: Bool = false
    ) {
        self._pump = pump
        self.shouldThrowError = shouldThrowError
    }

    var pump: Pump {
        get async throws {
            if shouldThrowError { throw MockError.repositoryError }
            return _pump
        }
    }

    var solarPanel: SolarPanel {
        get async throws { SolarPanel() }
    }

    var storageTank: StorageTank {
        get async throws { StorageTank() }
    }

    func updatePump(_ pump: Pump) async throws {
        if shouldThrowError { throw MockError.repositoryError }
        updatePumpCallCount += 1
        lastUpdatedPump = pump
        _pump = pump
    }

    func updateSolarPanel(_ solarPanel: SolarPanel) async throws {}

    func updateStorageTank(_ storageTank: StorageTank) async throws {}
}

enum MockError: Error {
    case repositoryError
}
