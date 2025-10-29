//
//  TogglePumpUseCase.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import Foundation

/// Domain : UseCase : toggles the circulation pump on/off
public struct TogglePumpUseCase: TogglePumpUseCaseProtocol {
    private let environmentRepository: EnvironmentRepositoryProtocol
    private let systemStateRepository: SystemStateRepositoryProtocol

    public init(
        environmentRepository: EnvironmentRepositoryProtocol,
        systemStateRepository: SystemStateRepositoryProtocol
    ) {
        self.environmentRepository = environmentRepository
        self.systemStateRepository = systemStateRepository
    }

    public func execute() async throws -> SystemState {
        // Get current pump state
        let currentPump = try await systemStateRepository.pump

        // Toggle the running state while preserving other properties
        let toggledPump = Pump(
            isRunning: !currentPump.isRunning,
            flowRate: currentPump.flowRate
        )

        // Update repository with new state
        try await systemStateRepository.updatePump(toggledPump)

        // Fetch and return complete system state
        async let environment = environmentRepository.environment
        async let solarPanel = systemStateRepository.solarPanel
        async let storageTank = systemStateRepository.storageTank

        return try await SystemState(
            environment: environment,
            solarPanel: solarPanel,
            pump: toggledPump,
            storageTank: storageTank
        )
    }
}
