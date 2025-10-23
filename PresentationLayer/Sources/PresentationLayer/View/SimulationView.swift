//
//  SimulationView.swift
//  thermodam
//
//  Created by Josh MacDonald on 10/21/25.
//

import SwiftUI

public struct SimulationView: View {
    @State var viewModel: SimulationViewModel

    public init(viewModel: SimulationViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top 2/3: Control bar + Graphics
                VStack(spacing: 12) {
                    controlBar
                        .padding(.horizontal)
                        .padding(.top)

                    graphicsArea
                }
                .frame(height: geometry.size.height * 0.67)

                Divider()

                // Bottom 1/3: Statistics in ScrollView
                ScrollView {
                    StatisticsView(viewModel: viewModel.statisticsViewModel)
                        .padding()
                }
                .frame(height: geometry.size.height * 0.33)
                .background(Color(.secondarySystemBackground))
            }
        }
        .background(Color(.systemBackground))
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - View Builders

    @ViewBuilder
    private var controlBar: some View {
        HStack {
            Text("Solar Thermal Simulation")
                .font(.title2)
                .fontWeight(.semibold)

            Spacer()

            playPauseButton
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    @ViewBuilder
    private var playPauseButton: some View {
        Button {
            viewModel.respondToSimulationToggle()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: viewModel.isSimulationRunning ? "pause.fill" : "play.fill")
                Text(viewModel.isSimulationRunning ? "Pause" : "Play")
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(viewModel.isSimulationRunning ? Color.orange : Color.green)
            .foregroundStyle(.white)
            .cornerRadius(8)
        }
    }

    @ViewBuilder
    private var graphicsArea: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Environment with draggable sun
                EnvironmentView(viewModel: viewModel.environmentViewModel)
                
                HStack {
                    SolarPanelView(viewModel: viewModel.solarPanelViewModel)
                    
                    // Pump control (centered, compact)
                    compactPumpControl
                }
                
                StorageTankView(viewModel: viewModel.storageTankViewModel)
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private var compactPumpControl: some View {
        HStack(spacing: 16) {
            // Pump visual
            ZStack {
                Circle()
                    .fill(viewModel.pump.isRunning ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: 60, height: 60)

                Circle()
                    .stroke(viewModel.pump.isRunning ? Color.green : Color.gray, lineWidth: 2)
                    .frame(width: 60, height: 60)

                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 24))
                    .foregroundStyle(viewModel.pump.isRunning ? .green : .gray)
                    .rotationEffect(.degrees(viewModel.pump.isRunning ? 360 : 0))
                    .animation(
                        viewModel.pump.isRunning ? .linear(duration: 2).repeatForever(autoreverses: false) : .default,
                        value: viewModel.pump.isRunning
                    )
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Pump")
                    .font(.headline)

                Text(viewModel.pumpStatusText)
                    .font(.caption)
                    .foregroundStyle(viewModel.pump.isRunning ? .green : .secondary)

                // Pump toggle button
                Button {
                    Task {
                        await viewModel.respondToPumpToggle()
                    }
                } label: {
                    Text(viewModel.pump.isRunning ? "Turn OFF" : "Turn ON")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(viewModel.pump.isRunning ? Color.red : Color.green)
                        .foregroundStyle(.white)
                        .cornerRadius(6)
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

}

import DomainLayer // only used for preview setup purposes

#Preview {
    SimulationView(
        viewModel: SimulationViewModel(
            updateEnvironmentUseCase: PreviewMocks.updateEnvironmentUseCase,
            togglePumpUseCase: PreviewMocks.togglePumpUseCase,
            calculateHeatTransferUseCase: PreviewMocks.calculateHeatTransferUseCase
        )
    )
}

// MARK: - Preview Mocks

private enum PreviewMocks {
    static let updateEnvironmentUseCase = MockUpdateEnvironmentUseCase()
    static let togglePumpUseCase = MockTogglePumpUseCase()
    static let calculateHeatTransferUseCase = MockCalculateHeatTransferUseCase()
}

private final class MockUpdateEnvironmentUseCase: UpdateEnvironmentUseCaseProtocol {
    func execute(environment: DomainLayer.Environment) async throws {}
}

private final class MockTogglePumpUseCase: TogglePumpUseCaseProtocol {
    func execute() async throws {}
}

private final class MockCalculateHeatTransferUseCase: CalculateHeatTransferUseCaseProtocol {
    func execute(timeStep: Double) async throws {}
}
