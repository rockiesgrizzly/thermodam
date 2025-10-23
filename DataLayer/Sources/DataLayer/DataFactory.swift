//
//  DataFactory.swift
//  DataLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import Foundation
import DomainLayer

/// Factory for creating Data layer dependencies (Repositories, Data Sources)
public final class DataFactory {
    private let localDataSource: LocalDataSource

    public init(
        environment: Environment = Environment(),
        solarPanel: SolarPanel = SolarPanel(),
        pump: Pump = Pump(),
        storageTank: StorageTank = StorageTank(),
        configuration: SystemConfiguration = SystemConfiguration()
    ) {
        self.localDataSource = LocalDataSource(
            environment: environment,
            solarPanel: solarPanel,
            pump: pump,
            storageTank: storageTank,
            configuration: configuration
        )
    }

    // MARK: - Repositories

    public var environmentRepository: EnvironmentRepositoryProtocol {
        EnvironmentRepository(localDataSource: localDataSource)
    }

    public var systemStateRepository: SystemStateRepositoryProtocol {
        SystemStateRepository(localDataSource: localDataSource)
    }

    public var configurationRepository: ConfigurationRepositoryProtocol {
        ConfigurationRepository(localDataSource: localDataSource)
    }

    // MARK: - Data Sources

    public var thermodynamicsEngine: ThermodynamicsEngineProtocol {
        ThermodynamicsEngine()
    }
}
