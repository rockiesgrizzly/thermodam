//
//  StorageTankView.swift
//  thermodam
//
//  Created by Josh MacDonald on 10/22/25.
//

import SwiftUI

/// Presentation : View : displays storage tank with fluid level and temperature gradient
public struct StorageTankView: View {
    let viewModel: StorageTankViewModel

    public init(viewModel: StorageTankViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 12) {
            tankVisualization
            tankInfo
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(12)
    }

    // MARK: - View Builders

    @ViewBuilder
    private var tankVisualization: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Tank outline
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primary.opacity(0.3), lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.primary.opacity(0.05))
                    )

                // Fluid fill (from bottom)
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [
                                temperatureColor,
                                temperatureColor.opacity(0.7)
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(height: geometry.size.height * fillPercentage)
                    .padding(4)

                // Water level indicator
                Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
                    .offset(y: -(geometry.size.height * fillPercentage - 4))

                // Drop icon
                Image(systemName: "drop.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(temperatureColor.opacity(0.8))
            }
        }
        .frame(width: 80, height: 180)
    }

    @ViewBuilder
    private var tankInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "thermometer.medium")
                    .foregroundStyle(temperatureColor)
                Text(viewModel.temperatureText)
                    .font(.caption)
                    .foregroundStyle(Color.secondaryLabel)
            }

            HStack {
                Image(systemName: "cylinder.fill")
                    .foregroundStyle(.blue)
                Text(viewModel.volumeText)
                    .font(.caption)
                    .foregroundStyle(Color.secondaryLabel)
            }

            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(.yellow)
                Text(viewModel.energyStoredText)
                    .font(.caption)
                    .foregroundStyle(Color.secondaryLabel)
            }
        }
    }

    // MARK: - Helpers

    private var fillPercentage: CGFloat {
        // Assume tank is always filled (could be dynamic based on volume/capacity)
        return 0.75
    }

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
}

#Preview {
    StorageTankView(
        viewModel: StorageTankViewModel(
            temperature: 32.1,
            volume: 200,
            energyStored: 25600000
        )
    )
}
