//
//  Pump.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import Foundation

/// Domain : Object : represents the circulation pump that moves fluid between panel and tank
public struct Pump: Sendable {
    /// Whether the pump is currently running
    public let isRunning: Bool

    /// Volumetric flow rate of fluid (L/s - liters per second)
    /// Typical residential systems: 0.5-2.0 L/s
    public let flowRate: Double

    public init(
        isRunning: Bool = false,
        flowRate: Double = 1.0  // L/s - typical residential flow rate
    ) {
        self.isRunning = isRunning
        self.flowRate = flowRate
    }
}

extension Pump: Equatable {
    public static func == (lhs: Pump, rhs: Pump) -> Bool {
        lhs.isRunning == rhs.isRunning &&
        lhs.flowRate == rhs.flowRate
    }
}
