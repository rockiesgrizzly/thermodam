//
//  ConfigurationRepositoryProtocol.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import Foundation

/// Domain : Protocol : defines the contract for accessing system configuration constants
public protocol ConfigurationRepositoryProtocol: Sendable {
    /// System configuration constants (specific heat, density, heat loss coefficients, etc.)
    var configuration: SystemConfiguration { get async throws }
}
