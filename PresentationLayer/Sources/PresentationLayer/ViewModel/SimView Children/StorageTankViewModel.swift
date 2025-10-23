//
//  StorageTankViewModel.swift
//  PresentationLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import DomainLayer
import Foundation

/// Presentation : ViewModel : formats storage tank data for StorageTankView
@Observable
@MainActor
public final class StorageTankViewModel {
    public let temperature: Double
    public let volume: Double
    public let energyStored: Double

    public init(
        temperature: Double,
        volume: Double,
        energyStored: Double
    ) {
        self.temperature = temperature
        self.volume = volume
        self.energyStored = energyStored
    }

    // MARK: - Formatted Display

    public var temperatureText: String {
        String(format: "%.1f°C (storage fluid temperature)", temperature)
    }

    public var volumeText: String {
        String(format: "%.0f L (tank capacity)", volume)
    }

    public var energyStoredText: String {
        String(format: "%.1f kJ (thermal energy: E = m × c × T)", energyStored / 1000)
    }

    public var energyStoredMJText: String {
        String(format: "%.2f MJ (thermal energy)", energyStored / 1_000_000)
    }
}
