//
//  StatisticsView.swift
//  thermodam
//
//  Created by Josh MacDonald on 10/22/25.
//

import SwiftUI

/// Presentation : View : displays system statistics and metrics
public struct StatisticsView: View {
    let viewModel: StatisticsViewModel

    public init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("System Statistics")
                .font(.headline)
                .foregroundStyle(Color.label)

            VStack(alignment: .leading, spacing: 12) {
                temperatureMetrics

                Divider()

                energyMetrics

                Divider()

                systemStatus
            }
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(12)
    }

    // MARK: - View Builders

    @ViewBuilder
    private var temperatureMetrics: some View {
        metricRow(
            label: "Solar Panel",
            value: String(format: "%.1f°C", viewModel.panelTemperature),
            caption: "collector temp"
        )

        metricRow(
            label: "Storage Tank",
            value: String(format: "%.1f°C", viewModel.tankTemperature),
            caption: "storage temp"
        )
    }

    @ViewBuilder
    private var energyMetrics: some View {
        metricRow(
            label: "Heat Absorbed",
            value: String(format: "%.0f W", viewModel.heatAbsorbed),
            caption: "Q = I × A × α"
        )

        metricRow(
            label: "Energy Stored",
            value: String(format: "%.1f kJ", viewModel.energyStored / 1000),
            caption: "E = m × c × T"
        )
    }

    @ViewBuilder
    private var systemStatus: some View {
        metricRow(
            label: "Solar Intensity",
            value: String(format: "%.0f W/m²", viewModel.solarIntensity),
            caption: "irradiance"
        )

        metricRow(
            label: "Pump Status",
            value: viewModel.pumpRunning ? "ON" : "OFF",
            caption: viewModel.pumpRunning ? String(format: "%.1f L/s", viewModel.flowRate) : "no flow"
        )

        metricRow(
            label: "Temperature Δ",
            value: String(format: "%.1f°C", viewModel.panelTemperature - viewModel.tankTemperature),
            caption: "heat transfer driving force"
        )
    }

    @ViewBuilder
    private func metricRow(label: String, value: String, caption: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(Color.label)

                Spacer()

                Text(value)
                    .font(.subheadline.monospacedDigit())
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.label)
            }

            Text(caption)
                .font(.caption2)
                .foregroundStyle(Color.tertiaryLabel)
        }
    }
}

#Preview {
    StatisticsView(
        viewModel: StatisticsViewModel(
            panelTemperature: 45.5,
            tankTemperature: 32.1,
            heatAbsorbed: 2500,
            energyStored: 25600000,
            pumpRunning: true,
            flowRate: 2.5,
            solarIntensity: 850
        )
    )
    .padding()
}
