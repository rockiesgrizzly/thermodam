//
//  SystemStateRepositoryProtocol.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import Foundation

/// Domain : Protocol : defines the contract for managing system component states
public protocol SystemStateRepositoryProtocol: Sendable {
    /// Current solar panel state
    var solarPanel: SolarPanel { get async throws }

    /// Current pump state
    var pump: Pump { get async throws }

    /// Current storage tank state
    var storageTank: StorageTank { get async throws }

    /// Updates the solar panel state
    func updateSolarPanel(_ solarPanel: SolarPanel) async throws

    /// Updates the pump state
    func updatePump(_ pump: Pump) async throws

    /// Updates the storage tank state
    func updateStorageTank(_ storageTank: StorageTank) async throws
}
