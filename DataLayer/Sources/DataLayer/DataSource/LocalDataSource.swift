//
//  LocalDataSource.swift
//  DataLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import DomainLayer
import Foundation

/// Data : DataSource : manages in-memory state for all system components
public actor LocalDataSource {
    private var currentEnvironment: Environment
    private var currentSolarPanel: SolarPanel
    private var currentPump: Pump
    private var currentStorageTank: StorageTank
    private let systemConfiguration: SystemConfiguration

    // AsyncStream for reactive state updates
    private var stateContinuation: AsyncStream<SystemState>.Continuation?
    public let stateStream: AsyncStream<SystemState>

    public init(
        environment: Environment = Environment(),
        solarPanel: SolarPanel = SolarPanel(),
        pump: Pump = Pump(),
        storageTank: StorageTank = StorageTank(),
        configuration: SystemConfiguration = SystemConfiguration()
    ) {
        self.currentEnvironment = environment
        self.currentSolarPanel = solarPanel
        self.currentPump = pump
        self.currentStorageTank = storageTank
        self.systemConfiguration = configuration

        // Setup AsyncStream for state broadcasting
        let initialState = SystemState(
            environment: environment,
            solarPanel: solarPanel,
            pump: pump,
            storageTank: storageTank
        )

        var continuation: AsyncStream<SystemState>.Continuation?
        self.stateStream = AsyncStream { cont in
            continuation = cont
            // Emit initial state synchronously during init
            cont.yield(initialState)
        }
        self.stateContinuation = continuation
    }

    // MARK: - Environment

    public var environment: Environment {
        currentEnvironment
    }

    public func updateEnvironment(_ environment: Environment) {
        currentEnvironment = environment
        emitState()
    }

    // MARK: - Solar Panel

    public var solarPanel: SolarPanel {
        currentSolarPanel
    }

    public func updateSolarPanel(_ solarPanel: SolarPanel) {
        currentSolarPanel = solarPanel
        emitState()
    }

    // MARK: - Pump

    public var pump: Pump {
        currentPump
    }

    public func updatePump(_ pump: Pump) {
        currentPump = pump
        emitState()
    }

    // MARK: - Storage Tank

    public var storageTank: StorageTank {
        currentStorageTank
    }

    public func updateStorageTank(_ storageTank: StorageTank) {
        currentStorageTank = storageTank
        emitState()
    }

    // MARK: - Configuration

    public var configuration: SystemConfiguration {
        systemConfiguration
    }

    // MARK: - State Broadcasting

    private func emitState() {
        let state = SystemState(
            environment: currentEnvironment,
            solarPanel: currentSolarPanel,
            pump: currentPump,
            storageTank: currentStorageTank
        )
        stateContinuation?.yield(state)
    }
}
