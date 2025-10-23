//
//  EnvironmentRepositoryProtocol.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import Foundation

/// Domain : Protocol : defines the contract for managing environmental conditions
public protocol EnvironmentRepositoryProtocol: Sendable {
    /// Current environment state (solar intensity, ambient temperature, sun position)
    var environment: Environment { get async throws }

    /// Updates the environment state
    func updateEnvironment(_ environment: Environment) async throws
}
