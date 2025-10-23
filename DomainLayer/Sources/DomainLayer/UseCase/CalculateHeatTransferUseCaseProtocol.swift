//
//  CalculateHeatTransferUseCaseProtocol.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/23/25.
//

import Foundation

/// Domain : Protocol : defines the contract for calculating heat transfer in the system
public protocol CalculateHeatTransferUseCaseProtocol: Sendable {
    /// Calculates and applies heat transfer for the given time step
    /// - Parameter timeStep: Duration in seconds for this calculation step
    func execute(timeStep: Double) async throws
}
