//
//  ThermodynamicsRepository.swift
//  DataLayer
//
//  Created by Josh MacDonald on 10/23/25.
//

import DomainLayer
import Foundation

/// Data : Repository : provides access to thermodynamic calculation engine
public struct ThermodynamicsRepository: ThermodynamicsRepositoryProtocol {
    private let engine: ThermodynamicsEngineProtocol

    public init(engine: ThermodynamicsEngineProtocol) {
        self.engine = engine
    }

    public func calculateSolarHeatGain(
        solarIntensity: Double,
        surfaceArea: Double,
        absorptivity: Double
    ) -> Double {
        engine.calculateSolarHeatGain(
            solarIntensity: solarIntensity,
            surfaceArea: surfaceArea,
            absorptivity: absorptivity
        )
    }

    public func calculateHeatLoss(
        heatLossCoefficient: Double,
        surfaceArea: Double,
        temperatureDifference: Double
    ) -> Double {
        engine.calculateHeatLoss(
            heatLossCoefficient: heatLossCoefficient,
            surfaceArea: surfaceArea,
            temperatureDifference: temperatureDifference
        )
    }

    public func calculateFluidHeatTransfer(
        massFlowRate: Double,
        specificHeat: Double,
        temperatureDifference: Double
    ) -> Double {
        engine.calculateFluidHeatTransfer(
            massFlowRate: massFlowRate,
            specificHeat: specificHeat,
            temperatureDifference: temperatureDifference
        )
    }

    public func calculateTemperatureChange(
        heatPower: Double,
        timeStep: Double,
        mass: Double,
        specificHeat: Double
    ) -> Double {
        engine.calculateTemperatureChange(
            heatPower: heatPower,
            timeStep: timeStep,
            mass: mass,
            specificHeat: specificHeat
        )
    }

    public func calculateThermalEnergy(
        mass: Double,
        specificHeat: Double,
        temperature: Double
    ) -> Double {
        engine.calculateThermalEnergy(
            mass: mass,
            specificHeat: specificHeat,
            temperature: temperature
        )
    }

    public func calculateMassFlowRate(
        volumetricFlowRate: Double,
        density: Double
    ) -> Double {
        engine.calculateMassFlowRate(
            volumetricFlowRate: volumetricFlowRate,
            density: density
        )
    }
}
