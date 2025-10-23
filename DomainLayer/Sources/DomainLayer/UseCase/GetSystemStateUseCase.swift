//
//  GetSystemStateUseCase.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/23/25.
//

import Foundation

/// Domain : UseCase : retrieves current system state from repositories
public protocol GetSystemStateUseCaseProtocol: Sendable {
    var systemState: SystemState { get async throws }
}

/// Encapsulates the complete system state
public struct SystemState: Sendable {
    public let environment: Environment
    public let solarPanel: SolarPanel
    public let pump: Pump
    public let storageTank: StorageTank

    public init(
        environment: Environment,
        solarPanel: SolarPanel,
        pump: Pump,
        storageTank: StorageTank
    ) {
        self.environment = environment
        self.solarPanel = solarPanel
        self.pump = pump
        self.storageTank = storageTank
    }
}

public final class GetSystemStateUseCase: GetSystemStateUseCaseProtocol {
    private let environmentRepository: EnvironmentRepositoryProtocol
    private let systemStateRepository: SystemStateRepositoryProtocol

    public init(
        environmentRepository: EnvironmentRepositoryProtocol,
        systemStateRepository: SystemStateRepositoryProtocol
    ) {
        self.environmentRepository = environmentRepository
        self.systemStateRepository = systemStateRepository
    }

    public var systemState: SystemState {
        get async throws {
            async let environment = environmentRepository.environment
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
}
