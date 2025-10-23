//
//  SolarPanelViewModel.swift
//  PresentationLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import DomainLayer
import Foundation

/// Presentation : ViewModel : formats solar panel data for SolarPanelView
public struct SolarPanelViewModel {
    public let temperature: Double
    public let heatAbsorptionRate: Double
    public let surfaceArea: Double
    public let absorptivity: Double

    public init(
        temperature: Double,
        heatAbsorptionRate: Double,
        surfaceArea: Double,
        absorptivity: Double
    ) {
        self.temperature = temperature
        self.heatAbsorptionRate = heatAbsorptionRate
        self.surfaceArea = surfaceArea
        self.absorptivity = absorptivity
    }

    // MARK: - Formatted Display

    public var temperatureText: String {
        String(format: "%.1f°C (collector fluid temperature)", temperature)
    }

    public var heatAbsorptionText: String {
        String(format: "%.0f W (solar heat gain: Q = I × A × α)", heatAbsorptionRate)
    }

    public var efficiencyText: String {
        String(format: "%.0f%% (solar absorptivity)", absorptivity * 100)
    }
}
