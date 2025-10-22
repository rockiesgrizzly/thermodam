# ThermoDam App

An example app showing a simple software simulation of the heat transfer from a solar panel to a storage tank with attention to thermodynamics

## Architecture
The app uses Clean Swift architecture which provides clear separation of concerns between Presentation, App, Domain, and Data layers.
<img width="1735" height="895" alt="Screenshot 2025-10-22 at 1 57 41 PM" src="https://github.com/user-attachments/assets/db50a6ba-a3ab-496d-bb9d-4ccfa5d033bb" />

### Presentation Layer
- views
- view models
- user interaction

### App Layer
- main app file
- dependencies container
- shared resources (asset files, etc)

### Domain Layer
- use cases: business logic and models

### Data Layer
- repositories: data storage/traffic handler
- data sources: external API interactions

### Architecture Goals
  - **Layer separation**: Boundaries between Presentation → App → Domain → Data
  - **Dependency rule**: Dependencies point inward (outer layers depend on inner, not vice versa)
  - **Use case focus**: Three focused use cases handling specific operations
  - **Repository pattern**: Abstraction between domain and data layers
  - **User interaction**: Clear entry point

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
- **EnvironmentRepository**: sun position, solar intensity, ambient temp
- **SystemStateRepository**: component temps, flow rates, energy stored
- **ConfigurationRepository**: constants: specific heat, surface areas, etc.

**Data Sources**:
- **LocalDataSource**: in-memory state management
- **ThermodynamicsEngine**: pure calculation functions - stateless

### Design Goals
- Environment updates don't block pump changes
- Heat transfer calculations read from both repos but only write to SystemState
- Each repository can be backed by independent state (actors, combine subjects, etc.)


