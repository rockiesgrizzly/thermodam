//
//  EnvironmentViewModel.swift
//  PresentationLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import DomainLayer
import Foundation

/// Presentation : ViewModel : formats environment data for EnvironmentView
@Observable
@MainActor
public final class EnvironmentViewModel {
    public let solarIntensity: Double
    public let ambientTemperature: Double
    public let sunPosition: CGPoint

    public let onSunDrag: (CGPoint, Double) async -> Void
    public let onAmbientTemperatureChange: (Double) async -> Void

    public init(
        solarIntensity: Double,
        ambientTemperature: Double,
        sunPosition: CGPoint,
        onSunDrag: @escaping (CGPoint, Double) async -> Void,
        onAmbientTemperatureChange: @escaping (Double) async -> Void
    ) {
        self.solarIntensity = solarIntensity
        self.ambientTemperature = ambientTemperature
        self.sunPosition = sunPosition
        self.onSunDrag = onSunDrag
        self.onAmbientTemperatureChange = onAmbientTemperatureChange
    }

    // MARK: - Formatted Display

    public var solarIntensityText: String {
        String(format: "%.0f W/m² (solar irradiance)", solarIntensity)
    }

    public var ambientTemperatureText: String {
        String(format: "%.1f°C (ambient air temperature)", ambientTemperature)
    }
}
