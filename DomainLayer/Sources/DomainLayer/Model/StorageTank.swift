//
//  StorageTank.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import Foundation

/// Domain : Object : represents the thermal storage tank that holds heated fluid
public struct StorageTank: Sendable {
    /// Current temperature of the fluid in the tank (°C)
    public let temperature: Double

    /// Total volume of fluid in the tank (L - liters)
    public let volume: Double

    /// Total thermal energy stored in the tank (J - joules)
    /// Calculated as: E = m × c × ΔT
    /// where m = mass, c = specific heat, ΔT = temp difference from reference
    public let energyStored: Double

    public init(
        temperature: Double = 20.0,      // °C - starting at ambient
        volume: Double = 200.0,          // L - typical residential tank (200L)
        energyStored: Double = 0.0       // J - no excess energy initially
    ) {
        self.temperature = temperature
        self.volume = volume
        self.energyStored = energyStored
    }
}

extension StorageTank: Equatable {
    public static func == (lhs: StorageTank, rhs: StorageTank) -> Bool {
        lhs.temperature == rhs.temperature &&
        lhs.volume == rhs.volume &&
        lhs.energyStored == rhs.energyStored
    }
}
