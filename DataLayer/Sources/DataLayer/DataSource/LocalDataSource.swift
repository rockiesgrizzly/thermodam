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
    }

    // MARK: - Environment

    public var environment: Environment {
        currentEnvironment
    }

    public func updateEnvironment(_ environment: Environment) {
        currentEnvironment = environment
    }

    // MARK: - Solar Panel

    public var solarPanel: SolarPanel {
        currentSolarPanel
    }

    public func updateSolarPanel(_ solarPanel: SolarPanel) {
        currentSolarPanel = solarPanel
    }

    // MARK: - Pump

    public var pump: Pump {
        currentPump
    }

    public func updatePump(_ pump: Pump) {
        currentPump = pump
    }

    // MARK: - Storage Tank

    public var storageTank: StorageTank {
        currentStorageTank
    }

    public func updateStorageTank(_ storageTank: StorageTank) {
        currentStorageTank = storageTank
    }

    // MARK: - Configuration

    public var configuration: SystemConfiguration {
        systemConfiguration
    }
}
