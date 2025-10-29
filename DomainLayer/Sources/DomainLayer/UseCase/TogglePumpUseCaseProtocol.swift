//
//  TogglePumpUseCaseProtocol.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/23/25.
//

import Foundation

/// Domain : Protocol : defines the contract for toggling the pump on/off
public protocol TogglePumpUseCaseProtocol: Sendable {
    /// Toggles the pump state between on and off
    /// - Returns: The updated system state after toggling the pump
    func execute() async throws -> SystemState
}
