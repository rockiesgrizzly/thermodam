//
//  IntegrationTests.swift
//  PresentationLayerTests
//
//  Created by Josh MacDonald on 10/23/25.
//
//  End-to-end integration tests: Presentation → Domain → Data → Domain → Presentation

import Foundation
import Testing
@testable import PresentationLayer
@testable import DomainLayer
@testable import DataLayer

@Suite("Integration Tests : system end to end")
@MainActor
struct IntegrationTests {

    // MARK: - Test 1: Sun Drag Updates Environment Through All Layers

    @Test("Dragging sun updates environment and propagates through entire stack")
    func sunDragUpdatesEnvironment() async throws {
        // Given: Real ViewModel with full dependency chain
        let viewModel = createRealSimulationViewModel()

        // When: User drags sun to new position (simulating UI gesture)
        let newPosition = CGPoint(x: 150, y: 30) // Higher = more intensity
        let newIntensity = 950.0
        await viewModel.respondToSunViewDrag(position: newPosition, solarIntensity: newIntensity)

        // Then: ViewModel state should reflect the change
        #expect(viewModel.environment.solarIntensity == 950.0)
        #expect(viewModel.environment.sunPosition.x == 150)
        #expect(viewModel.environment.sunPosition.y == 30)

        // And: Child ViewModel should reflect updated data
        let envViewModel = viewModel.environmentViewModel
        #expect(envViewModel.solarIntensity == 950.0)
    }

    // MARK: - Test 2: Ambient Temperature Change Flows Through Stack

    @Test("Changing ambient temperature updates through all layers")
    func ambientTemperatureChangeWorks() async throws {
        // Given: Real ViewModel
        let viewModel = createRealSimulationViewModel()

        // When: User adjusts temperature slider
        await viewModel.respondToAmbientTemperatureChange(28.5)

        // Then: State updated correctly
        #expect(viewModel.environment.ambientTemperature == 28.5)

        // And: Available in child ViewModels
        let envViewModel = viewModel.environmentViewModel
        #expect(envViewModel.ambientTemperature == 28.5)
    }

    // MARK: - Test 3: Pump Toggle Affects System State

    @Test("Toggling pump updates state through repositories and back")
    func pumpToggleWorks() async throws {
        // Given: Real ViewModel
        let viewModel = createRealSimulationViewModel()

        // Initial pump state (should be OFF by default)
        #expect(viewModel.pump.isRunning == false)

        // When: User taps pump toggle button
        await viewModel.respondToPumpToggle()

        // Then: Pump state should toggle
        #expect(viewModel.pump.isRunning == true)

        // When: Toggle again
        await viewModel.respondToPumpToggle()

        // Then: Should toggle back
        #expect(viewModel.pump.isRunning == false)
    }

    // MARK: - Test 4: Complete Simulation Loop Updates All State

    @Test("Running simulation updates heat absorption and temperatures")
    func simulationLoopUpdatesState() async throws {
        // Given: ViewModel with high solar intensity and pump ON
        let viewModel = createRealSimulationViewModel()

        // Setup favorable conditions for heat transfer
        await viewModel.respondToSunViewDrag(
            position: CGPoint(x: 100, y: 30),
            solarIntensity: 1000.0
        )
        await viewModel.respondToPumpToggle() // Turn pump ON

        // When: Start simulation
        viewModel.respondToSimulationToggle() // Start
        #expect(viewModel.isSimulationRunning == true)

        // Let it run for a bit
        try await Task.sleep(for: .milliseconds(500))

        // Then: Stop simulation to check state
        viewModel.respondToSimulationToggle() // Stop
        #expect(viewModel.isSimulationRunning == false)

        // State should have updated
        #expect(viewModel.solarPanel.heatAbsorptionRate > 0,
                "Panel should absorb heat with 1000 W/m² solar input")

        // Statistics ViewModel should reflect changes
        let statsVM = viewModel.statisticsViewModel
        #expect(statsVM.heatAbsorbed > 0, "Statistics should show heat absorption")
        #expect(statsVM.pumpRunning == true, "Statistics should show pump is ON")
    }

    // MARK: - Test 5: Child ViewModels Reflect Parent State Changes

    @Test("Child ViewModels always reflect current parent state")
    func childViewModelsReflectParentState() async throws {
        // Given: Real ViewModel
        let viewModel = createRealSimulationViewModel()

        // When: Make multiple state changes
        await viewModel.respondToSunViewDrag(position: CGPoint(x: 100, y: 40), solarIntensity: 850.0)
        await viewModel.respondToAmbientTemperatureChange(25.0)
        await viewModel.respondToPumpToggle()

        // Then: All child ViewModels should reflect current state
        let envVM = viewModel.environmentViewModel
        #expect(envVM.solarIntensity == 850.0)
        #expect(envVM.ambientTemperature == 25.0)

        let statsVM = viewModel.statisticsViewModel
        #expect(statsVM.solarIntensity == 850.0)
        #expect(statsVM.pumpRunning == true)

        let panelVM = viewModel.solarPanelViewModel
        #expect(panelVM.temperature >= 0) // Should have valid temperature

        let tankVM = viewModel.storageTankViewModel
        #expect(tankVM.volume > 0) // Should have valid volume
    }

    // MARK: - Test 6: Simulation Preserves State Between Runs

    @Test("State persists correctly between simulation start/stop cycles")
    func statePersistsBetweenSimulationCycles() async throws {
        // Given: ViewModel with specific state
        let viewModel = createRealSimulationViewModel()

        await viewModel.respondToSunViewDrag(position: CGPoint(x: 100, y: 50), solarIntensity: 900.0)
        await viewModel.respondToPumpToggle() // ON

        // When: Run simulation cycle 1
        viewModel.respondToSimulationToggle() // Start
        try await Task.sleep(for: .milliseconds(300))
        viewModel.respondToSimulationToggle() // Stop

        let tempAfterCycle1 = viewModel.solarPanel.temperature

        // When: Run simulation cycle 2
        viewModel.respondToSimulationToggle() // Start
        try await Task.sleep(for: .milliseconds(300))
        viewModel.respondToSimulationToggle() // Stop

        let tempAfterCycle2 = viewModel.solarPanel.temperature

        // Then: State should have continued from previous cycle
        #expect(viewModel.environment.solarIntensity == 900.0, "Environment preserved")
        #expect(viewModel.pump.isRunning == true, "Pump state preserved")

        // Temperature should be valid and potentially increased
        #expect(tempAfterCycle2 >= tempAfterCycle1, "Temperature continues from previous state")
    }

    // MARK: - Test 7: Multiple Rapid UI Interactions

    @Test("Handles rapid user interactions without data corruption")
    func handlesRapidInteractions() async throws {
        // Given: Real ViewModel
        let viewModel = createRealSimulationViewModel()

        // When: Rapid successive interactions (simulating fast user taps)
        for i in 0..<10 {
            await viewModel.respondToSunViewDrag(
                position: CGPoint(x: 100, y: Double(30 + i * 5)),
                solarIntensity: Double(800 + i * 10)
            )
            await viewModel.respondToAmbientTemperatureChange(Double(20 + i))
        }

        // Toggle pump rapidly
        for _ in 0..<5 {
            await viewModel.respondToPumpToggle()
        }

        // Then: Final state should be valid and consistent
        #expect(viewModel.environment.solarIntensity >= 0)
        #expect(viewModel.environment.ambientTemperature >= 0)
        #expect(viewModel.solarPanel.temperature >= 0)
        #expect(viewModel.storageTank.temperature >= 0)

        // Pump should have toggled odd number of times (started OFF, so now ON)
        #expect(viewModel.pump.isRunning == true)
    }

    // MARK: - Helper Factory

    private func createRealSimulationViewModel() -> SimulationViewModel {
        // Create real dependency chain (not mocks)
        let dataFactory = DataFactory()
        let domainFactory = DomainFactory(
            environmentRepository: dataFactory.environmentRepository,
            systemStateRepository: dataFactory.systemStateRepository,
            configurationRepository: dataFactory.configurationRepository,
            thermodynamicsRepository: dataFactory.thermodynamicsRepository
        )

        return SimulationViewModel(
            updateEnvironmentUseCase: domainFactory.updateEnvironmentUseCase,
            togglePumpUseCase: domainFactory.togglePumpUseCase,
            calculateHeatTransferUseCase: domainFactory.calculateHeatTransferUseCase,
            getSystemStateUseCase: domainFactory.getSystemStateUseCase
        )
    }
}
