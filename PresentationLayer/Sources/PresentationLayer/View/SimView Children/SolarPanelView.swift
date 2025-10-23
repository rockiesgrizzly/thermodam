//
//  SolarPanelView.swift
//  thermodam
//
//  Created by Josh MacDonald on 10/22/25.
//

import SwiftUI

/// Presentation : View : displays solar panel with tubes and heat absorption
public struct SolarPanelView: View {
    let viewModel: SolarPanelViewModel

    public init(viewModel: SolarPanelViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 12) {
            panelVisualization
            panelInfo
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    // MARK: - View Builders

    @ViewBuilder
    private var panelVisualization: some View {
        ZStack {
            // Panel frame
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.primary.opacity(0.3), lineWidth: 2)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(temperatureGradient)
                )

            // Horizontal tubes
            VStack(spacing: 8) {
                ForEach(0..<6) { _ in
                    tubeShape
                }
            }
            .padding(8)
        }
        .frame(width: 100, height: 150)
    }

    @ViewBuilder
    private var tubeShape: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(
                LinearGradient(
                    colors: [
                        temperatureColor.opacity(0.7),
                        temperatureColor.opacity(0.9)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 6)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.primary.opacity(0.2), lineWidth: 0.5)
            )
    }

    @ViewBuilder
    private var panelInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "thermometer.medium")
                    .foregroundStyle(temperatureColor)
                Text(viewModel.temperatureText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Image(systemName: "sun.max")
                    .foregroundStyle(.orange)
                Text(viewModel.heatAbsorptionText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Image(systemName: "gauge.medium")
                    .foregroundStyle(.green)
                Text(viewModel.efficiencyText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Helpers

    private var temperatureColor: Color {
        switch viewModel.temperature {
        case ..<20:
            return .blue
        case 20..<30:
            return .cyan
        case 30..<40:
            return .green
        case 40..<50:
            return .orange
        default:
            return .red
        }
    }

    private var temperatureGradient: LinearGradient {
        LinearGradient(
            colors: [
                temperatureColor.opacity(0.3),
                temperatureColor.opacity(0.1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

#Preview {
    SolarPanelView(
        viewModel: SolarPanelViewModel(
            temperature: 45.5,
            heatAbsorptionRate: 2500,
            surfaceArea: 2.0,
            absorptivity: 0.95
        )
    )
}
