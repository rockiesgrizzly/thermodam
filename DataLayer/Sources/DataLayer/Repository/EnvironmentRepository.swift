//
//  EnvironmentRepository.swift
//  DataLayer
//
//  Created by Josh MacDonald on 10/23/25.
//

import DomainLayer
import Foundation

/// Data : Repository : manages environmental conditions state
public struct EnvironmentRepository: EnvironmentRepositoryProtocol {
    private let localDataSource: LocalDataSource

    public init(localDataSource: LocalDataSource) {
        self.localDataSource = localDataSource
    }

    public var environment: Environment {
        get async throws {
            await localDataSource.environment
        }
    }

    public func updateEnvironment(_ environment: Environment) async throws {
        await localDataSource.updateEnvironment(environment)
    }
}
