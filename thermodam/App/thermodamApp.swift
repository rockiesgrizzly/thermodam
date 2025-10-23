//
//  thermodamApp.swift
//  thermodam
//
//  Created by Josh MacDonald on 10/21/25.
//

import DataLayer
import DomainLayer
import PresentationLayer
import SwiftUI

@main
struct thermodamApp: App {
    var body: some Scene {
        WindowGroup {
            AppDependencies.contentView
        }
    }
}
