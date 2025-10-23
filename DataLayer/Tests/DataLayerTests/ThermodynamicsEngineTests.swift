//
//  ThermodynamicsEngineTests.swift
//  DataLayer
//
//  Created by Josh MacDonald on 10/23/25.
//

@testable import DataLayer
import DomainLayer
import Foundation
import Testing

struct ThermodynamicsEngineTests {
    let engine = ThermodynamicsEngine()

    // MARK: - Solar Heat Gain Tests

    @Test func solarHeatGainWithTypicalValues() {
        // Given: typical solar panel conditions
        let solarIntensity = 1000.0  // W/m² - bright sunny day
        let surfaceArea = 2.0         // m² - typical panel
        let absorptivity = 0.92       // 92% absorption

        // When: calculate solar heat gain
        let heatGain = engine.calculateSolarHeatGain(
            solarIntensity: solarIntensity,
            surfaceArea: surfaceArea,
            absorptivity: absorptivity
        )

        // Then: Q = I × A × α = 1000 × 2.0 × 0.92 = 1840 W
        #expect(heatGain == 1840.0)
    }

    @Test func solarHeatGainAtNight() {
        // Given: nighttime conditions
        let solarIntensity = 0.0
        let surfaceArea = 2.0
        let absorptivity = 0.92

        // When: calculate solar heat gain
        let heatGain = engine.calculateSolarHeatGain(
            solarIntensity: solarIntensity,
            surfaceArea: surfaceArea,
            absorptivity: absorptivity
        )

        // Then: no solar gain at night
        #expect(heatGain == 0.0)
    }

    @Test func solarHeatGainWithPoorAbsorber() {
        // Given: low absorptivity (poor collector)
        let solarIntensity = 800.0
        let surfaceArea = 1.5
        let absorptivity = 0.5  // only 50% absorption

        // When: calculate solar heat gain
        let heatGain = engine.calculateSolarHeatGain(
            solarIntensity: solarIntensity,
            surfaceArea: surfaceArea,
            absorptivity: absorptivity
        )

        // Then: Q = 800 × 1.5 × 0.5 = 600 W
        #expect(heatGain == 600.0)
    }

    // MARK: - Heat Loss Tests

    @Test func heatLossWithTypicalPanelConditions() {
        // Given: panel hotter than ambient
        let heatLossCoefficient = 8.0  // W/m²·K - moderate
        let surfaceArea = 2.0           // m²
        let temperatureDifference = 30.0 // K (panel at 50°C, ambient at 20°C)

        // When: calculate heat loss
        let heatLoss = engine.calculateHeatLoss(
            heatLossCoefficient: heatLossCoefficient,
            surfaceArea: surfaceArea,
            temperatureDifference: temperatureDifference
        )

        // Then: Q_loss = U × A × ΔT = 8 × 2 × 30 = 480 W
        #expect(heatLoss == 480.0)
    }

    @Test func heatLossAtAmbientTemperature() {
        // Given: no temperature difference
        let heatLossCoefficient = 8.0
        let surfaceArea = 2.0
        let temperatureDifference = 0.0

        // When: calculate heat loss
        let heatLoss = engine.calculateHeatLoss(
            heatLossCoefficient: heatLossCoefficient,
            surfaceArea: surfaceArea,
            temperatureDifference: temperatureDifference
        )

        // Then: no heat loss when at same temperature
        #expect(heatLoss == 0.0)
    }

    @Test func heatLossFromWellInsulatedTank() {
        // Given: well-insulated tank
        let heatLossCoefficient = 1.5  // W/m²·K - good insulation
        let surfaceArea = 2.5           // m²
        let temperatureDifference = 20.0 // K

        // When: calculate heat loss
        let heatLoss = engine.calculateHeatLoss(
            heatLossCoefficient: heatLossCoefficient,
            surfaceArea: surfaceArea,
            temperatureDifference: temperatureDifference
        )

        // Then: Q_loss = 1.5 × 2.5 × 20 = 75 W
        #expect(heatLoss == 75.0)
    }

    // MARK: - Fluid Heat Transfer Tests

    @Test func fluidHeatTransferWithTypicalFlowRate() {
        // Given: water flowing between hot panel and cool tank
        let massFlowRate = 1.0      // kg/s (1 L/s of water)
        let specificHeat = 4186.0    // J/kg·K - water
        let temperatureDifference = 30.0  // K (panel 60°C, tank 30°C)

        // When: calculate fluid heat transfer
        let heatTransfer = engine.calculateFluidHeatTransfer(
            massFlowRate: massFlowRate,
            specificHeat: specificHeat,
            temperatureDifference: temperatureDifference
        )

        // Then: Q = ṁ × c × ΔT = 1 × 4186 × 30 = 125,580 W
        #expect(heatTransfer == 125580.0)
    }

    @Test func fluidHeatTransferWithPumpOff() {
        // Given: pump is off, no flow
        let massFlowRate = 0.0
        let specificHeat = 4186.0
        let temperatureDifference = 30.0

        // When: calculate fluid heat transfer
        let heatTransfer = engine.calculateFluidHeatTransfer(
            massFlowRate: massFlowRate,
            specificHeat: specificHeat,
            temperatureDifference: temperatureDifference
        )

        // Then: no heat transfer when pump is off
        #expect(heatTransfer == 0.0)
    }

    @Test func fluidHeatTransferAtEqualTemperatures() {
        // Given: panel and tank at same temperature
        let massFlowRate = 1.0
        let specificHeat = 4186.0
        let temperatureDifference = 0.0

        // When: calculate fluid heat transfer
        let heatTransfer = engine.calculateFluidHeatTransfer(
            massFlowRate: massFlowRate,
            specificHeat: specificHeat,
            temperatureDifference: temperatureDifference
        )

        // Then: no heat transfer at equal temps
        #expect(heatTransfer == 0.0)
    }

    // MARK: - Temperature Change Tests

    @Test func temperatureChangeWithPositiveHeat() {
        // Given: heat being added to water
        let heatPower = 2000.0       // W
        let timeStep = 10.0          // s
        let mass = 10.0              // kg (10L of water)
        let specificHeat = 4186.0    // J/kg·K

        // When: calculate temperature change
        let tempChange = engine.calculateTemperatureChange(
            heatPower: heatPower,
            timeStep: timeStep,
            mass: mass,
            specificHeat: specificHeat
        )

        // Then: ΔT = Q × Δt / (m × c) = 2000 × 10 / (10 × 4186) ≈ 0.478 K
        #expect(abs(tempChange - 0.478) < 0.001)
    }

    @Test func temperatureChangeWithNegativeHeat() {
        // Given: heat being removed (cooling)
        let heatPower = -1000.0      // W (negative = cooling)
        let timeStep = 5.0           // s
        let mass = 20.0              // kg
        let specificHeat = 4186.0    // J/kg·K

        // When: calculate temperature change
        let tempChange = engine.calculateTemperatureChange(
            heatPower: heatPower,
            timeStep: timeStep,
            mass: mass,
            specificHeat: specificHeat
        )

        // Then: ΔT = -1000 × 5 / (20 × 4186) ≈ -0.0597 K (cooling)
        #expect(tempChange < 0)
        #expect(abs(tempChange - (-0.0597)) < 0.001)
    }

    @Test func temperatureChangeWithZeroMass() {
        // Given: zero mass (edge case)
        let heatPower = 1000.0
        let timeStep = 1.0
        let mass = 0.0
        let specificHeat = 4186.0

        // When: calculate temperature change
        let tempChange = engine.calculateTemperatureChange(
            heatPower: heatPower,
            timeStep: timeStep,
            mass: mass,
            specificHeat: specificHeat
        )

        // Then: should return 0 to avoid division by zero
        #expect(tempChange == 0.0)
    }

    @Test func temperatureChangeScalesWithTimeStep() {
        // Given: same conditions, different time steps
        let heatPower = 1500.0
        let mass = 15.0
        let specificHeat = 4186.0

        // When: calculate with different time steps
        let tempChange1s = engine.calculateTemperatureChange(
            heatPower: heatPower,
            timeStep: 1.0,
            mass: mass,
            specificHeat: specificHeat
        )
        let tempChange10s = engine.calculateTemperatureChange(
            heatPower: heatPower,
            timeStep: 10.0,
            mass: mass,
            specificHeat: specificHeat
        )

        // Then: 10x time step should give 10x temperature change
        #expect(abs(tempChange10s / tempChange1s - 10.0) < 0.001)
    }

    // MARK: - Thermal Energy Tests

    @Test func thermalEnergyOfWater() {
        // Given: water at 50°C (relative to 0°C reference)
        let mass = 200.0              // kg (200L tank)
        let specificHeat = 4186.0     // J/kg·K
        let temperature = 50.0        // °C

        // When: calculate thermal energy
        let energy = engine.calculateThermalEnergy(
            mass: mass,
            specificHeat: specificHeat,
            temperature: temperature
        )

        // Then: E = m × c × T = 200 × 4186 × 50 = 41,860,000 J
        #expect(energy == 41860000.0)
    }

    @Test func thermalEnergyAtReferenceTemperature() {
        // Given: at reference temperature (0°C)
        let mass = 100.0
        let specificHeat = 4186.0
        let temperature = 0.0

        // When: calculate thermal energy
        let energy = engine.calculateThermalEnergy(
            mass: mass,
            specificHeat: specificHeat,
            temperature: temperature
        )

        // Then: zero energy at reference
        #expect(energy == 0.0)
    }

    // MARK: - Mass Flow Rate Tests

    @Test func massFlowRateForWater() {
        // Given: typical water flow
        let volumetricFlowRate = 1.0  // L/s
        let density = 1.0              // kg/L (water)

        // When: calculate mass flow rate
        let massFlowRate = engine.calculateMassFlowRate(
            volumetricFlowRate: volumetricFlowRate,
            density: density
        )

        // Then: ṁ = V̇ × ρ = 1 × 1 = 1 kg/s
        #expect(massFlowRate == 1.0)
    }

    @Test func massFlowRateWithHigherFlowRate() {
        // Given: higher flow rate
        let volumetricFlowRate = 2.5  // L/s
        let density = 1.0              // kg/L

        // When: calculate mass flow rate
        let massFlowRate = engine.calculateMassFlowRate(
            volumetricFlowRate: volumetricFlowRate,
            density: density
        )

        // Then: ṁ = 2.5 × 1 = 2.5 kg/s
        #expect(massFlowRate == 2.5)
    }

    @Test func massFlowRateWhenPumpOff() {
        // Given: pump off, no flow
        let volumetricFlowRate = 0.0
        let density = 1.0

        // When: calculate mass flow rate
        let massFlowRate = engine.calculateMassFlowRate(
            volumetricFlowRate: volumetricFlowRate,
            density: density
        )

        // Then: no mass flow
        #expect(massFlowRate == 0.0)
    }
}
