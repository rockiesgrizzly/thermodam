//
//  EnvironmentView.swift
//  thermodam
//
//  Created by Josh MacDonald on 10/22/25.
//

import SwiftUI

/// Presentation : View : displays environment controls with draggable sun
public struct EnvironmentView: View {
    let viewModel: EnvironmentViewModel
    @State private var sunPosition: CGPoint = .zero

    public init(viewModel: EnvironmentViewModel) {
        self.viewModel = viewModel
        _sunPosition = State(initialValue: viewModel.sunPosition)
    }

    public var body: some View {
        HStack(spacing: 16) {
            sunArea
            controls
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.6),
                    Color.blue.opacity(0.4),
                    Color.blue.opacity(0.2),
                    Color.primary.opacity(0.1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(12)
    }

    // MARK: - View Builders

    @ViewBuilder
    private var sunArea: some View {
        GeometryReader { geometry in
            ZStack {
                // Vertical slider track
                Rectangle()
                    .fill(Color.primary.opacity(0.15))
                    .frame(width: 2)
                    .cornerRadius(1)

                // Draggable sun
                Image(systemName: "sun.max.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(.yellow)
                    .shadow(color: .yellow.opacity(0.5), radius: 10)
                    .position(
                        x: geometry.size.width / 2,
                        y: sunPosition.y == 0 ? geometry.size.height / 2 : sunPosition.y
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // Keep X centered, only allow vertical movement
                                let centerX = geometry.size.width / 2
                                let newY = min(max(value.location.y, 15), geometry.size.height - 15)
                                sunPosition = CGPoint(x: centerX, y: newY)
                            }
                            .onEnded { _ in
                                // Calculate solar intensity based on vertical position
                                // Higher position = more intensity (0-1000 W/m²)
                                let normalizedY = 1.0 - (sunPosition.y / geometry.size.height)
                                let solarIntensity = max(0, min(1000, normalizedY * 1000))

                                Task {
                                    await viewModel.onSunDrag(sunPosition, solarIntensity)
                                }
                            }
                    )

                // Sun rays (optional visual)
                ForEach(0..<8) { index in
                    Rectangle()
                        .fill(Color.yellow.opacity(0.3))
                        .frame(width: 2, height: 2)
                        .offset(y: -10)
                        .rotationEffect(.degrees(Double(index) * 45))
                        .position(
                            x: geometry.size.width / 2,
                            y: sunPosition.y == 0 ? geometry.size.height / 2 : sunPosition.y
                        )
                }
            }
        }
        .frame(width: 30, height: 150)
    }

    @ViewBuilder
    private var controls: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Solar intensity display
            HStack {
                Image(systemName: "sun.max")
                    .foregroundStyle(.orange)
                Text(viewModel.solarIntensityText)
                    .font(.caption)
                    .foregroundStyle(Color.secondaryLabel)
            }

            Divider()

            // Ambient temperature slider
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "thermometer.medium")
                        .foregroundStyle(.blue)
                    Text(viewModel.ambientTemperatureText)
                        .font(.caption)
                        .foregroundStyle(Color.secondaryLabel)
                }

                HStack {
                    Text("5°C")
                        .font(.caption2)
                        .foregroundStyle(Color.tertiaryLabel)

                    Slider(
                        value: Binding(
                            get: { viewModel.ambientTemperature },
                            set: { newValue in
                                Task {
                                    await viewModel.onAmbientTemperatureChange(newValue)
                                }
                            }
                        ),
                        in: 5...35,
                        step: 0.5
                    )

                    Text("35°C")
                        .font(.caption2)
                        .foregroundStyle(Color.tertiaryLabel)
                }
            }
        }.frame(maxWidth: .infinity)
    }
}

#Preview {
    EnvironmentView(
        viewModel: EnvironmentViewModel(
            solarIntensity: 850,
            ambientTemperature: 22,
            sunPosition: CGPoint(x: 100, y: 50),
            onSunDrag: { _, _ in },
            onAmbientTemperatureChange: { _ in }
        )
    )
    .frame(width: 300, height: 300)
}
