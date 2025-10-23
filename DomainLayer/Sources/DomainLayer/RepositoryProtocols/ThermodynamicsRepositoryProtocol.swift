//
//  ThermodynamicsRepositoryProtocol.swift
//  DomainLayer
//
//  Created by Josh MacDonald on 10/23/25.
//

import Foundation

/// Domain : Protocol : defines the contract for accessing thermodynamic calculations
public protocol ThermodynamicsRepositoryProtocol: Sendable {
    /// Calculates solar heat gain by a solar collector
    /// Q = I × A × α
    func calculateSolarHeatGain(
        solarIntensity: Double,
        surfaceArea: Double,
        absorptivity: Double
    ) -> Double

    /// Calculates heat loss through convection and radiation
    /// Q_loss = U × A × ΔT
    func calculateHeatLoss(
        heatLossCoefficient: Double,
        surfaceArea: Double,
        temperatureDifference: Double
    ) -> Double

    /// Calculates heat transfer via flowing fluid
    /// Q = ṁ × c × ΔT
    func calculateFluidHeatTransfer(
        massFlowRate: Double,
        specificHeat: Double,
        temperatureDifference: Double
    ) -> Double

    /// Calculates temperature change from heat energy
    /// ΔT = Q × Δt / (m × c)
    func calculateTemperatureChange(
        heatPower: Double,
        timeStep: Double,
        mass: Double,
        specificHeat: Double
    ) -> Double

    /// Calculates total thermal energy stored in a mass
    /// E = m × c × T
    func calculateThermalEnergy(
        mass: Double,
        specificHeat: Double,
        temperature: Double
    ) -> Double

    /// Calculates mass flow rate from volumetric flow rate
    /// ṁ = V̇ × ρ
    func calculateMassFlowRate(
        volumetricFlowRate: Double,
        density: Double
    ) -> Double
}
