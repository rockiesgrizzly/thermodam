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
    func execute() async throws
}
