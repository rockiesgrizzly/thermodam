//
//  StatisticsViewModel.swift
//  PresentationLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import DomainLayer
import Foundation

/// Presentation : ViewModel : formats statistics data for StatisticsView
@Observable
@MainActor
public final class StatisticsViewModel {
    public let panelTemperature: Double
    public let tankTemperature: Double
    public let heatAbsorbed: Double
    public let energyStored: Double
    public let pumpRunning: Bool
    public let flowRate: Double
    public let solarIntensity: Double

    public init(
        panelTemperature: Double,
        tankTemperature: Double,
        heatAbsorbed: Double,
        energyStored: Double,
        pumpRunning: Bool,
        flowRate: Double,
        solarIntensity: Double
    ) {
        self.panelTemperature = panelTemperature
        self.tankTemperature = tankTemperature
        self.heatAbsorbed = heatAbsorbed
        self.energyStored = energyStored
        self.pumpRunning = pumpRunning
        self.flowRate = flowRate
        self.solarIntensity = solarIntensity
    }

    // MARK: - Formatted Display

    public var summaryText: String {
        """
        Solar Panel: \(String(format: "%.1f", panelTemperature))°C (collector temp)
        Storage Tank: \(String(format: "%.1f", tankTemperature))°C (storage temp)
        Heat Absorbed: \(String(format: "%.0f", heatAbsorbed)) W (Q = I × A × α)
        Energy Stored: \(String(format: "%.1f", energyStored / 1000)) kJ (E = m × c × T)
        Pump: \(pumpRunning ? "ON" : "OFF") (fluid circulation)
        """
    }

    public var pumpStatusText: String {
        pumpRunning ? "ON (\(String(format: "%.1f", flowRate)) L/s - volumetric flow)" : "OFF"
    }

    public var solarIntensityText: String {
        String(format: "%.0f W/m² (solar irradiance)", solarIntensity)
    }

    public var temperatureDifferenceText: String {
        let diff = panelTemperature - tankTemperature
        return String(format: "ΔT: %.1f°C (driving force for heat transfer)", diff)
    }
}
