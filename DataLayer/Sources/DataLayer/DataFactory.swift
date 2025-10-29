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
    private let thermodynamicsEngine: ThermodynamicsEngineProtocol

    public init(
        environment: Environment = Environment(),
        solarPanel: SolarPanel = SolarPanel(),
        pump: Pump = Pump(),
        storageTank: StorageTank = StorageTank(),
        configuration: SystemConfiguration = SystemConfiguration(),
        thermodynamicsEngine: ThermodynamicsEngine = ThermodynamicsEngine()
    ) {
        self.localDataSource = LocalDataSource(
            environment: environment,
            solarPanel: solarPanel,
            pump: pump,
            storageTank: storageTank,
            configuration: configuration
        )

        self.thermodynamicsEngine = thermodynamicsEngine
    }

    // MARK: - Repositories

    public lazy var environmentRepository: EnvironmentRepositoryProtocol = {
        EnvironmentRepository(localDataSource: localDataSource)
    }()

    public lazy var systemStateRepository: SystemStateRepositoryProtocol = {
        SystemStateRepository(localDataSource: localDataSource)
    }()

    public lazy var configurationRepository: ConfigurationRepositoryProtocol = {
        ConfigurationRepository(localDataSource: localDataSource)
    }()

    // MARK: - Data Sources

    public lazy var thermodynamicsRepository: ThermodynamicsRepositoryProtocol = {
        ThermodynamicsRepository(engine: thermodynamicsEngine)
    }()
}
