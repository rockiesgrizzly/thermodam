---
config:
  theme: neo-dark
  layout: elk
---
flowchart TB
 subgraph PresentationLayer["Presentation Layer"]
        SimVM["SimulationViewModel"]
        subgraph SimView["SimulationView"]
        EnvView["EnvironmentView"]
        PanelView["SolarPanelView"]
        PumpView["PumpView"]
        TankView["StorageTankView"]
        StatsView["StatisticsView"]
        end
  end
 subgraph AppLayer["App Layer"]
        Depend["Dependencies"]
        App["App"]
  end
 subgraph DomainLayer["Domain Layer"]
        EnvUC["UpdateEnvironmentUseCase"]
        HeatTransferUC["CalculateHeatTransferUseCase"]
        PumpUC["TogglePumpUseCase"]
  end
 subgraph Repositories["Repositories"]
        EnvRepo["EnvironmentRepository"]
        StateRepo["SystemStateRepository"]
        ConfigRepo["ConfigurationRepository"]
  end
 subgraph DataSources["Data Sources"]
        LocalDS["LocalDataSource"]
        ThermoEngine["ThermodynamicsEngine"]
  end
 subgraph DataLayer["Data Layer"]
        Repositories
        DataSources
  end
    User(("👤 User")) --> SimView
    SimVM <--> SimView
    EnvView <--> SimView
    PanelView <--> SimView
    PumpView <--> SimView
    TankView <--> SimView
    StatsView <--> SimView
    App <--> SimVM & Depend
    Depend <--> EnvUC & PumpUC & HeatTransferUC
    EnvUC <--> EnvRepo
    PumpUC <--> StateRepo
    HeatTransferUC <--> EnvRepo & StateRepo & ConfigRepo
    EnvRepo <--> LocalDS
    StateRepo <--> LocalDS & ThermoEngine
    ConfigRepo <--> LocalDS
    style EnvView fill:#121212
    style PanelView fill:#121212
    style PumpView fill:#121212
    style TankView fill:#121212
    style StatsView fill:#121212
    style SimView fill:#121212
    style SimVM fill:#121212
    style Depend fill:#121212
    style App fill:#121212
    style EnvUC fill:#121212
    style HeatTransferUC fill:#121212
    style PumpUC fill:#121212
    style EnvRepo fill:#121212
    style StateRepo fill:#121212
    style ConfigRepo fill:#121212
    style LocalDS fill:#121212
    style ThermoEngine fill:#121212
    style Repositories fill:#454545
    style DataSources fill:#454545
    style User fill:#2e2e2e,stroke:#888,stroke-width:2px
    style AppLayer fill:#654321
    style PresentationLayer fill:#06402B
    style DomainLayer fill:#00008b
    style DataLayer fill:#8b0000
