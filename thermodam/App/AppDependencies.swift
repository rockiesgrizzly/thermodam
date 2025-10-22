//
//  AppDependencies.swift
//  thermodam
//
//  Created by Josh MacDonald on 10/21/25.
//

import DataLayer
import DomainLayer
import PresentationLayer
import Foundation
import SwiftUI

/// `AppDependencies` provides dependency injection for the app in Clean architecture.
/// Serves as the composition root that wires up all dependencies across layers.
/// Dependency flow: App -> Presentation -> Domain -> Data (outer to inner).
@MainActor
@Observable
final class AppDependencies {
    
    // MARK: Public: Interface
    
    /// Clean architecture presentation layer: feeding Views & ViewModels
    var presentation: PresentationFactory {
        presentationFactory
    }
    
    /// Clean architecture domain layer: feeding UseCases and business models
    var domain: PresentationFactory {
        presentationFactory
    }
    
    /// Clean architecture domain layer: feeding Repositories and external models
    var data: PresentationFactory {
        presentationFactory
    }
    
    // MARK: Private: Layer Factories
    
    private let dataFactory: DataFactory = DataFactory()
    private let domainFactory: DomainFactory = DomainFactory()
    private let presentationFactory: PresentationFactory = PresentationFactory()
    

}
