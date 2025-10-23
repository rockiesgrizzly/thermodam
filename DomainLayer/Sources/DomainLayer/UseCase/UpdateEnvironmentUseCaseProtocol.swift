//
//  UpdateEnvironmentUseCaseProtocol.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/23/25.
//

import Foundation

/// Domain : Protocol : defines the contract for updating environmental conditions
public protocol UpdateEnvironmentUseCaseProtocol: Sendable {
    /// Updates the environment state with new values
    func execute(environment: Environment) async throws
}
