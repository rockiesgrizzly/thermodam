//
//  SimulationView.swift
//  thermodam
//
//  Created by Josh MacDonald on 10/21/25.
//

import SwiftUI

@available(iOS 13.0, *)
public struct SimulationView: View {
    public init() {}
    public var body: some View {
        VStack {
        }
    }
}

// Provide a dummy placeholder for platforms/versions where SwiftUI.View isn't available
#if !canImport(SwiftUI)
public struct SimulationView {}
#endif

@available(iOS 13.0, *)
#Preview {
    SimulationView()
}
