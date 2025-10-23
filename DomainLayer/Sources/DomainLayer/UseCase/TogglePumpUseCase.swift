//
//  TogglePumpUseCase.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import Foundation

/// Domain : UseCase : toggles the circulation pump on/off
public struct TogglePumpUseCase: TogglePumpUseCaseProtocol {
    private let systemStateRepository: SystemStateRepositoryProtocol

    public init(systemStateRepository: SystemStateRepositoryProtocol) {
        self.systemStateRepository = systemStateRepository
    }

    public func execute() async throws {
        // Get current pump state
        let currentPump = try await systemStateRepository.pump

        // Toggle the running state while preserving other properties
        let toggledPump = Pump(
            isRunning: !currentPump.isRunning,
            flowRate: currentPump.flowRate
        )

        // Update repository with new state
        try await systemStateRepository.updatePump(toggledPump)
    }
}
