//
//  Environment.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import Foundation

/// Domain : Object : represents the environmental conditions affecting the solar thermal system
public struct Environment: Sendable {
    /// Solar irradiance hitting the panel (W/m²)
    /// Typical values: 0-1000 W/m² (0 at night, ~1000 on clear sunny day)
    public let solarIntensity: Double

    /// Ambient air temperature (°C)
    public let ambientTemperature: Double

    /// Sun position in 2D space (for UI visualization)
    public let sunPosition: CGPoint

    public init(
        solarIntensity: Double = 400.0,      // W/m² - sun at mid-lower position
        ambientTemperature: Double = 20.0,   // °C - comfortable room temp
        sunPosition: CGPoint = CGPoint(x: 100, y: 100)
    ) {
        self.solarIntensity = solarIntensity
        self.ambientTemperature = ambientTemperature
        self.sunPosition = sunPosition
    }
}

extension Environment: Equatable {
    public static func == (lhs: Environment, rhs: Environment) -> Bool {
        lhs.solarIntensity == rhs.solarIntensity &&
        lhs.ambientTemperature == rhs.ambientTemperature &&
        lhs.sunPosition.x == rhs.sunPosition.x &&
        lhs.sunPosition.y == rhs.sunPosition.y
    }
}
