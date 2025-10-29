//
//  ThermodynamicsEngine.swift
//  DataLayer
//
//  Created by Josh MacDonald on 10/22/25.
//

import DomainLayer
import Foundation

/// Data : DataSource : provides pure, stateless thermodynamic calculation functions
public struct ThermodynamicsEngine: ThermodynamicsEngineProtocol {

    public init() {}

    // MARK: - Solar Heat Gain

    /// Calculates solar heat gain by a solar collector
    /// Q = I × A × α
    public func calculateSolarHeatGain(
        solarIntensity: Double,
        surfaceArea: Double,
        absorptivity: Double
    ) -> Double {
        solarIntensity * surfaceArea * absorptivity
    }

    // MARK: - Heat Loss

    /// Calculates heat loss through convection and radiation
    /// Q_loss = U × A × ΔT
    public func calculateHeatLoss(
        heatLossCoefficient: Double,
        surfaceArea: Double,
        temperatureDifference: Double
    ) -> Double {
        heatLossCoefficient * surfaceArea * temperatureDifference
    }

    // MARK: - Fluid Heat Transfer

    /// Calculates heat transfer via flowing fluid
    /// Q = ṁ × c × ΔT
    public func calculateFluidHeatTransfer(
        massFlowRate: Double,
        specificHeat: Double,
        temperatureDifference: Double
    ) -> Double {
        massFlowRate * specificHeat * temperatureDifference
    }

    // MARK: - Temperature Change

    /// Calculates temperature change from heat energy
    /// ΔT = Q × Δt / (m × c)
    public func calculateTemperatureChange(
        heatPower: Double,
        timeStep: Double,
        mass: Double,
        specificHeat: Double
    ) -> Double {
        guard mass > 0, specificHeat > 0 else { return 0 }
        return (heatPower * timeStep) / (mass * specificHeat)
    }

    // MARK: - Thermal Energy

    /// Calculates total thermal energy stored in a mass
    /// E = m × c × T
    public func calculateThermalEnergy(
        mass: Double,
        specificHeat: Double,
        temperature: Double
    ) -> Double {
        mass * specificHeat * temperature
    }

    // MARK: - Mass Flow Rate

    /// Calculates mass flow rate from volumetric flow rate
    /// ṁ = V̇ × ρ
    public func calculateMassFlowRate(
        volumetricFlowRate: Double,
        density: Double
    ) -> Double {
        volumetricFlowRate * density
    }
}
