//
//  ConfigurationRepository.swift
//  DataLayer
//
//  Created by Josh MacDonald on 10/23/25.
//

import DomainLayer
import Foundation

/// Data : Repository : provides access to system configuration constants
public struct ConfigurationRepository: ConfigurationRepositoryProtocol {
    private let localDataSource: LocalDataSource

    public init(localDataSource: LocalDataSource) {
        self.localDataSource = localDataSource
    }

    public var configuration: SystemConfiguration {
        get async throws {
            await localDataSource.configuration
        }
    }
}
