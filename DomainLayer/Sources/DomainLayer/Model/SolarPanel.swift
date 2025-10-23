//
//  SolarPanel.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import Foundation

/// Domain : Object : represents the solar thermal collector panel
public struct SolarPanel: Sendable {
    /// Current temperature of the fluid in the panel (°C)
    public let temperature: Double

    /// Surface area of the solar collector (m²)
    public let surfaceArea: Double

    /// Solar absorptivity coefficient (0.0-1.0)
    /// Typical flat-plate collectors: 0.9-0.95
    public let absorptivity: Double

    /// Current heat absorption rate (W)
    /// This is the instantaneous power being absorbed from solar radiation
    public let heatAbsorptionRate: Double

    public init(
        temperature: Double = 20.0,           // °C - starting at ambient
        surfaceArea: Double = 2.0,            // m² - typical residential panel
        absorptivity: Double = 0.92,          // ~92% absorption efficiency
        heatAbsorptionRate: Double = 0.0      // W - no heat yet
    ) {
        self.temperature = temperature
        self.surfaceArea = surfaceArea
        self.absorptivity = absorptivity
        self.heatAbsorptionRate = heatAbsorptionRate
    }
}

extension SolarPanel: Equatable {
    public static func == (lhs: SolarPanel, rhs: SolarPanel) -> Bool {
        lhs.temperature == rhs.temperature &&
        lhs.surfaceArea == rhs.surfaceArea &&
        lhs.absorptivity == rhs.absorptivity &&
        lhs.heatAbsorptionRate == rhs.heatAbsorptionRate
    }
}
