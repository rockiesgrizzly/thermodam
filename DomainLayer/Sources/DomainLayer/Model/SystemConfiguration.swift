//
//  SystemConfiguration.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import Foundation

/// Domain : Object : represents physical constants and system configuration parameters
public struct SystemConfiguration: Sendable {
    /// Specific heat capacity of the working fluid (J/kg·K)
    /// Water at 20°C: 4186 J/kg·K
    public let specificHeat: Double

    /// Density of the working fluid (kg/L)
    /// Water at 20°C: 1.0 kg/L
    public let fluidDensity: Double

    /// Heat loss coefficient for the solar panel (W/m²·K)
    /// Represents heat lost to ambient through convection/radiation
    /// Typical values: 5-10 W/m²·K
    public let panelHeatLossCoefficient: Double

    /// Heat loss coefficient for the storage tank (W/m²·K)
    /// Well-insulated tanks: 0.5-2.0 W/m²·K
    public let tankHeatLossCoefficient: Double

    /// Surface area of the storage tank for heat loss calculations (m²)
    /// Typical 200L tank: ~2.5 m² surface area
    public let tankSurfaceArea: Double

    public init(
        specificHeat: Double = 4186.0,               // J/kg·K - water
        fluidDensity: Double = 1.0,                  // kg/L - water
        panelHeatLossCoefficient: Double = 8.0,      // W/m²·K - moderate losses
        tankHeatLossCoefficient: Double = 1.5,       // W/m²·K - well-insulated
        tankSurfaceArea: Double = 2.5                // m² - typical 200L tank
    ) {
        self.specificHeat = specificHeat
        self.fluidDensity = fluidDensity
        self.panelHeatLossCoefficient = panelHeatLossCoefficient
        self.tankHeatLossCoefficient = tankHeatLossCoefficient
        self.tankSurfaceArea = tankSurfaceArea
    }
}

extension SystemConfiguration: Equatable {
    public static func == (lhs: SystemConfiguration, rhs: SystemConfiguration) -> Bool {
        lhs.specificHeat == rhs.specificHeat &&
        lhs.fluidDensity == rhs.fluidDensity &&
        lhs.panelHeatLossCoefficient == rhs.panelHeatLossCoefficient &&
        lhs.tankHeatLossCoefficient == rhs.tankHeatLossCoefficient &&
        lhs.tankSurfaceArea == rhs.tankSurfaceArea
    }
}
