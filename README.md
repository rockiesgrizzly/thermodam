# ThermoDam App

An example app showing a simple software simulation of the heat transfer from a solar panel to a storage tank with attention to thermodynamics. There's a bit of intentional over-engineering here to demonstrate a system that could be extended to production quality quickly.

## App in Action
https://github.com/user-attachments/assets/49b05796-8822-4b43-8ace-27c026ad4a95

https://github.com/user-attachments/assets/c903caa0-3454-4667-a0c5-a5ba591e80d0

## Architecture
_The app uses Clean Swift architecture which provides clear separation of concerns between Presentation, App, Domain, and Data layers._
<img width="1403" height="298" alt="Thermodam Architecture : Clean Swift approach" src="https://github.com/user-attachments/assets/f9978631-d512-4bc0-ace8-a1716a751f64" />

### Presentation Layer (Swift Package)
- **SimulationViewModel**: Main coordinator using `@Observable`, holds system state, handles UI interactions
- **Child ViewModels**: EnvironmentViewModel, SolarPanelViewModel, StorageTankViewModel, StatisticsViewModel (computed properties for fresh data)
- **Views**: SimulationView, EnvironmentView, SolarPanelView, StorageTankView, StatisticsView
- **PresentationFactory**: Creates ViewModels from use cases (lazy singleton)
- **Color+Semantic**: Cross-platform semantic colors for light/dark mode support

### App Layer
- **thermodamApp**: Main app entry point
- **AppDependencies**: Composition root with singleton factory instances (prevents duplicate LocalDataSource)

### Domain Layer (Swift Package)
- **Models**: Environment, SolarPanel, Pump, StorageTank, SystemConfiguration
- **Use Cases**: UpdateEnvironmentUseCase, TogglePumpUseCase, CalculateHeatTransferUseCase, GetSystemStateUseCase
- **Repository Protocols**: Define contracts for data access
- **DomainFactory**: Creates use cases from repository protocols (lazy singletons)
- **Tests**: comprehensive unit tests for all use cases

### Data Layer (Swift Package)
- **Repository Implementations**: EnvironmentRepository, SystemStateRepository, ConfigurationRepository
- **LocalDataSource**: Thread-safe Actor for in-memory state management
- **ThermodynamicsEngine**: Pure physics calculations implementing ThermodynamicsEngineProtocol
- **DataFactory**: Creates repositories and data sources (lazy singletons sharing same LocalDataSource)
- **Tests**: unit tests for ThermodynamicsEngine formulas

### Architecture Principles
- **Package isolation**: Each layer is a separate Swift Package with explicit dependencies
- **Dependency rule**: Dependencies point inward (Domain has no dependencies, Data depends on Domain, Presentation depends on Domain)
- **Protocol-based**: All cross-layer communication through protocols
- **Testability**: Mock implementations for all protocols, 45 tests total (20 Domain + 18 Data + 7 Presentation integration tests)
- **Separation of concerns**: Business logic (Domain), data access (Data), UI (Presentation) clearly separated
- **Modern Swift**: Uses `@Observable` macro, Actor isolation, async/await, lazy properties

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
- **ThermodynamicsRepository**: Provides access to the ThermodynamicEngine

**Data Sources**:
- **LocalDataSource**: Thread-safe Actor for in-memory state management
- **ThermodynamicsEngine**: Stateless physics calculation engine. Simulates an endpoint that might provide more complex calculations.

### Thermodynamics Engine (simulates an endpoint that might provide more complex calculations)
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

## How to Run

### Requirements
- macOS 14.0+
- Xcode 16.0+
- Swift 6.0+

### Running the App
1. Open `thermodam.xcodeproj` in Xcode
2. Select the thermodam scheme
3. Run (⌘R)

### Running Tests
Run all layer tests from the command line:
```bash
# Domain Layer tests (20 tests)
swift test --package-path DomainLayer

# Data Layer tests (18 tests)
swift test --package-path DataLayer

# Presentation Layer integration tests (7 tests)
swift test --package-path PresentationLayer
```

### Using the App
1. **Drag the sun** vertically to adjust solar intensity (0-1000 W/m²)
2. **Adjust ambient temperature** slider (5-35°C)
3. **Toggle pump** on/off to control fluid circulation
4. **Start simulation** to see real-time heat transfer
5. Watch temperatures, heat absorption, and energy storage update dynamically

### Key Metrics Displayed
- **Solar Intensity**: Current irradiance from sun position
- **Heat Absorbed**: Instantaneous power absorption (W) - not cumulative
- **Energy Stored**: Cumulative thermal energy in tank (kJ)
- **Panel/Tank Temperatures**: Real-time thermodynamic calculations
- **Pump Flow Rate**: Fluid circulation rate when pump is on


