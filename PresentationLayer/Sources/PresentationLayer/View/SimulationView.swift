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
        VStack(spacing: 20) {
            controlBar
            systemVisualization
            StatisticsView(viewModel: viewModel.statisticsViewModel)
        }
        .padding()
        .background(Color(.systemBackground))
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
    private var systemVisualization: some View {
        GeometryReader { geometry in
            ZStack {
                // Background pipes (closed loop)
                pipeConnection

                // System components in horizontal layout
                HStack(spacing: 40) {
                    // Left side: Environment and Solar Panel
                    VStack(spacing: 20) {
                        EnvironmentView(viewModel: viewModel.environmentViewModel)
                            .frame(width: 250, height: 300)

                        SolarPanelView(viewModel: viewModel.solarPanelViewModel)
                            .frame(width: 250)
                    }

                    Spacer()

                    // Center: Pump control
                    pumpControl

                    Spacer()

                    // Right side: Storage Tank
                    StorageTankView(viewModel: viewModel.storageTankViewModel)
                        .frame(width: 200)
                }
                .padding(.horizontal, 20)
            }
        }
        .frame(height: 400)
    }

    @ViewBuilder
    private var pumpControl: some View {
        VStack(spacing: 12) {
            // Pump visual
            ZStack {
                Circle()
                    .fill(viewModel.pump.isRunning ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: 80, height: 80)

                Circle()
                    .stroke(viewModel.pump.isRunning ? Color.green : Color.gray, lineWidth: 3)
                    .frame(width: 80, height: 80)

                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 30))
                    .foregroundStyle(viewModel.pump.isRunning ? .green : .gray)
                    .rotationEffect(.degrees(viewModel.pump.isRunning ? 360 : 0))
                    .animation(
                        viewModel.pump.isRunning ? .linear(duration: 2).repeatForever(autoreverses: false) : .default,
                        value: viewModel.pump.isRunning
                    )
            }

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

            // Pump status
            VStack(spacing: 4) {
                Text("Pump")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                Text(viewModel.pumpStatusText)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(viewModel.pump.isRunning ? .green : .gray)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    @ViewBuilder
    private var pipeConnection: some View {
        GeometryReader { geometry in
            Path { path in
                let leftX = geometry.size.width * 0.2
                let rightX = geometry.size.width * 0.8
                let topY = geometry.size.height * 0.3
                let bottomY = geometry.size.height * 0.7

                // Top pipe: Panel to Pump to Tank
                path.move(to: CGPoint(x: leftX, y: topY))
                path.addLine(to: CGPoint(x: rightX, y: topY))

                // Bottom pipe: Tank back to Panel (return)
                path.move(to: CGPoint(x: rightX, y: bottomY))
                path.addLine(to: CGPoint(x: leftX, y: bottomY))

                // Vertical connectors
                path.move(to: CGPoint(x: leftX, y: topY))
                path.addLine(to: CGPoint(x: leftX, y: bottomY))

                path.move(to: CGPoint(x: rightX, y: topY))
                path.addLine(to: CGPoint(x: rightX, y: bottomY))
            }
            .stroke(
                Color.orange.opacity(0.4),
                style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
            )

            // Animated flow particles when pump is running
            if viewModel.pump.isRunning {
                flowParticles
            }
        }
    }

    @ViewBuilder
    private var flowParticles: some View {
        // Simple animated circles moving through pipes
        ForEach(0..<3) { index in
            Circle()
                .fill(Color.orange)
                .frame(width: 8, height: 8)
                .offset(x: animatedOffset(for: index))
                .animation(
                    .linear(duration: 3)
                        .repeatForever(autoreverses: false)
                        .delay(Double(index) * 0.3),
                    value: viewModel.pump.isRunning
                )
        }
    }

    // MARK: - Helpers

    private func animatedOffset(for index: Int) -> CGFloat {
        return viewModel.pump.isRunning ? 300 : 0
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
