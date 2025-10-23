# ThermoDam App

An example app showing a simple software simulation of the heat transfer from a solar panel to a storage tank with attention to thermodynamics

## Architecture
_The app uses Clean Swift architecture which provides clear separation of concerns between Presentation, App, Domain, and Data layers._
<img width="1866" src="https://github.com/user-attachments/assets/33c3b834-9482-4db7-8a79-3bbdd205a1a6" />

### Presentation Layer (Swift Package)
- **SimulationViewModel**: Main coordinator, holds system state, handles UI interactions
- **Child ViewModels**: EnvironmentViewModel, SolarPanelViewModel, StorageTankViewModel, StatisticsViewModel
- **Views**: SimulationView, EnvironmentView, SolarPanelView, StorageTankView, StatisticsView
- **PresentationFactory**: Creates ViewModels from use cases

### App Layer
- **thermodamApp**: Main app entry point
- **AppDependencies**: Composition root that wires all layer factories
- Dependency flow: Data → Domain → Presentation

### Domain Layer (Swift Package)
- **Models**: Environment, SolarPanel, Pump, StorageTank, SystemConfiguration
- **Use Cases**: UpdateEnvironmentUseCase, TogglePumpUseCase, CalculateHeatTransferUseCase
- **Repository Protocols**: Define contracts for data access
- **DomainFactory**: Creates use cases from repository protocols
- **Tests**: Comprehensive unit tests for all use cases

### Data Layer (Swift Package)
- **Repository Implementations**: EnvironmentRepository, SystemStateRepository, ConfigurationRepository
- **LocalDataSource**: Thread-safe Actor for in-memory state management
- **ThermodynamicsEngine**: Pure physics calculations implementing ThermodynamicsEngineProtocol
- **DataFactory**: Creates repositories and data sources
- **Tests**: Unit tests for ThermodynamicsEngine formulas

### Architecture Principles
- **Package isolation**: Each layer is a separate Swift Package with explicit dependencies
- **Dependency rule**: Dependencies point inward (Domain has no dependencies, Data depends on Domain, Presentation depends on Domain)
- **Protocol-based**: All cross-layer communication through protocols
- **Testability**: Mock implementations for all protocols, comprehensive test coverage
- **Separation of concerns**: Business logic (Domain), data access (Data), UI (Presentation) clearly separated

## General Approach

### Visual Objects
- Environment/Sun: draggable, shows solar intensity
- SolarPanel: shows temperature, heat absorbed
- Pump: shows on/off state, flow rate
- StorageTank: shows temperature, volume, energy stored

### Views
- **SimulationView**: main container that orchestrates everything
- **EnvironmentView**: draggable sun, solar intensity display
- **SolarPanelView**: panel temperature, heat absorption
- **PumpView**: pump controls, flow rate display
- **StorageTankView**: tank temperature, volume, energy stored
- **StatisticsView**: overall metrics and graphs

### Use Cases
**UpdateEnvironmentUseCase**:
- Writes: sun position, solar intensity, ambient temperature
- Reads: nothing (just updates from user input)

**CalculateHeatTransferUseCase**:
- Reads: environment state, component states (panel temp, tank temp, pump status)
- Writes: updated temperatures, energy values
- Uses: ThermodynamicsEngine for calculations

**TogglePumpUseCase**:
- Writes: pump on/off, flow rate
- Reads: current pump state

### Data Handling
**Repositories**:
- **EnvironmentRepository**: Manages environment state (sun position, solar intensity, ambient temp)
- **SystemStateRepository**: Manages component states (panel/tank temperatures, pump status, flow rates, energy)
- **ConfigurationRepository**: Provides system constants (specific heat, fluid density, heat loss coefficients, surface areas)

**Data Sources**:
- **LocalDataSource**: Thread-safe Actor for in-memory state management
- **ThermodynamicsEngine**: Stateless physics calculation engine

### Thermodynamics Engine
Pure calculation functions implementing correct physics formulas:
- **Solar Heat Gain**: Q = I × A × α (irradiance × area × absorptivity)
- **Heat Loss**: Q_loss = U × A × ΔT (heat transfer coefficient × area × temp difference)
- **Fluid Heat Transfer**: Q = ṁ × c × ΔT (mass flow × specific heat × temp difference)
- **Temperature Change**: ΔT = Q × Δt / (m × c) (heat energy over time divided by thermal mass)
- **Thermal Energy**: E = m × c × T (mass × specific heat × temperature)
- **Mass Flow Rate**: ṁ = V̇ × ρ (volumetric flow × density)

All formulas tested with real-world values for thermodynamic correctness.

#### References
Formulas based on standard heat transfer and thermodynamics principles:

1. **Solar Heat Gain & Heat Loss**: Duffie, J.A., & Beckman, W.A. (2013). *Solar Engineering of Thermal Processes* (4th ed.). Wiley. Chapter 6: Flat-Plate Collectors.

2. **Fluid Heat Transfer & Sensible Heat**: Incropera, F.P., Dewitt, D.P., Bergman, T.L., & Lavine, A.S. (2007). *Fundamentals of Heat and Mass Transfer* (6th ed.). Wiley. Chapter 8: Internal Flow.

3. **First Law of Thermodynamics (Temperature Change & Thermal Energy)**: Çengel, Y.A., & Boles, M.A. (2015). *Thermodynamics: An Engineering Approach* (8th ed.). McGraw-Hill. Chapter 4: Energy Analysis of Closed Systems.

4. **Mass Flow Rate**: White, F.M. (2011). *Fluid Mechanics* (7th ed.). McGraw-Hill. Chapter 4: Fluid Kinematics.

### Design Goals
- Environment, solar, pump, and tank updates occur independently
- Heat transfer calculations orchestrated by use case, physics delegated to ThermodynamicsEngine
- Each repository backed by shared Actor for thread-safety
- Dependency inversion: Domain defines protocols, Data implements them


