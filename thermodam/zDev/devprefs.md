# Development Preferences

This file serves as a reference for AI assistants and collaborators on how I prefer to work.

Please speak to me like a friendly colleague. I'm a senior iOS engineer and an engineeering manager with over 12 years of coding experience. Let's code together.

I prefer Swift Clean architecture.
- Check out the following for examples:
    https://github.com/rockiesgrizzly/alarms
https://medium.com/@dyaremyshyn/clean-architecture-in-ios-development-a-comprehensive-guide-7e3d5f851e79

Clean Swift Architectural Structure:
- App layer: main app file, dependency container(s), shared resources
- Presentation Layer: Views & ViewModels
- Domain Layer: UseCases & Business Models (business logic)
- Data Layer: Repositories and External Models
                                        
Dependency injection and testability are key.

## Code Style Preferences

### Method vs Property Naming
- **Default to computed properties (vars) when there are no parameters**
- **When returning a value, name the var or function or property to match the return type and any pertinent context. Default to vars if no parameters are needed.**
- Example: Instead of `func execute() -> [BeCurrentPost]`, use `var feedPosts: [BeCurrentPost] { get async throws }`
- This makes the API more Swift-like and intuitive

## Current Project
Physics Simulator Coding Exercise
- Write a simple software simulation of the following system.

Minimum Requirements
1. The system should simulate the heat transfer from a solar panel to a storage tank
2. We will evaluate thermodynamic correctness, code approach, and results.

  ✅ Layer separation - Clear boundaries between Presentation → App → Domain → Data
  ✅ Dependency rule - Dependencies point inward (outer layers depend on inner, not vice versa)
  ✅ Nested SimView - Great visual showing component views contained within SimulationView
  ✅ Use case focus - Three focused use cases handling specific operations
  ✅ Repository pattern - Proper abstraction between domain and data layers
  ✅ ThermoEngine placement - Correctly isolated as a data source, only accessed via StateRepo
  ✅ User interaction - Clear entry point

### Components
Environment > Pump > Solar Panel > Storage Tank

  - Environment provides solar energy (sunlight)
  - Solar Panel absorbs heat from sunlight
  - Pump circulates fluid between panel and tank
  - Storage Tank stores the heated fluid

  The system forms a closed loop: fluid gets heated in the solar panel, pump circulates it to the storage tank, then back to the panel.

  Key evaluation criteria:
  1. Thermodynamic correctness (proper heat transfer physics)
  2. Code approach (Clean Architecture ✓)
  3. Results (accurate simulation output)
