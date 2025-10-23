//
//  SystemStateRepository.swift
//  DataLayer
//
//  Created by Josh MacDonald on 10/23/25.
//

import DomainLayer
import Foundation

/// Data : Repository : manages system component states (panel, pump, tank)
public struct SystemStateRepository: SystemStateRepositoryProtocol {
    private let localDataSource: LocalDataSource

    public init(localDataSource: LocalDataSource) {
        self.localDataSource = localDataSource
    }

    // MARK: - Solar Panel

    public var solarPanel: SolarPanel {
        get async throws {
            await localDataSource.solarPanel
        }
    }

    public func updateSolarPanel(_ solarPanel: SolarPanel) async throws {
        await localDataSource.updateSolarPanel(solarPanel)
    }

    // MARK: - Pump

    public var pump: Pump {
        get async throws {
            await localDataSource.pump
        }
    }

    public func updatePump(_ pump: Pump) async throws {
        await localDataSource.updatePump(pump)
    }

    // MARK: - Storage Tank

    public var storageTank: StorageTank {
        get async throws {
            await localDataSource.storageTank
        }
    }

    public func updateStorageTank(_ storageTank: StorageTank) async throws {
        await localDataSource.updateStorageTank(storageTank)
    }
}
