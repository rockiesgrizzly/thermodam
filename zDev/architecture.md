---
config:
  theme: neo-dark
  layout: elk
---
flowchart LR
 subgraph SimView["SimulationView"]
        EnvView["EnvironmentView"]
        PanelView["SolarPanelView"]
        TankView["StorageTankView"]
        StatsView["StatisticsView"]
  end
 subgraph PresentationLayer["Presentation Layer"]
        SimVM["SimulationViewModel"]
        EnvVM["EnvironmentViewModel"]
        PanelVM["SolarPanelViewModel"]
        TankVM["StorageTankViewModel"]
        StatsVM["StatisticsViewModel"]
        SimView
  end
 subgraph AppLayer["App Layer"]
        Depend["AppDependencies"]
        App["thermodamApp"]
  end
 subgraph UseCases["Use Cases"]
        EnvUC["UpdateEnvironmentUseCase"]
        HeatTransferUC["CalculateHeatTransferUseCase"]
        PumpUC["TogglePumpUseCase"]
        GetStateUC["GetSystemStateUseCase"]
  end
 subgraph RepoProtocols["Repository Protocols"]
        EnvRepoProto["EnvironmentRepositoryProtocol"]
        StateRepoProto["SystemStateRepositoryProtocol"]
        ConfigRepoProto["ConfigurationRepositoryProtocol"]
        ThermoProto["ThermodynamicsEngineProtocol"]
  end
 subgraph DomainLayer["Domain Layer"]
        UseCases
        RepoProtocols
  end
 subgraph Repositories["Repository Implementations"]
        EnvRepo["EnvironmentRepository"]
        StateRepo["SystemStateRepository"]
        ConfigRepo["ConfigurationRepository"]
  end
 subgraph DataSources["Data Sources"]
        LocalDS["LocalDataSource (Actor)"]
        ThermoEngine["ThermodynamicsEngine"]
  end
 subgraph DataLayer["Data Layer"]
        Repositories
        DataSources
  end
    User(("👤 User")) --> SimView
    SimVM --> EnvVM & PanelVM & TankVM & StatsVM & EnvUC & PumpUC & HeatTransferUC & GetStateUC
    EnvView --> EnvVM
    PanelView --> PanelVM
    TankView --> TankVM
    StatsView --> StatsVM
    App --> Depend
    Depend --> SimVM
    EnvUC --> EnvRepoProto
    PumpUC --> StateRepoProto
    HeatTransferUC --> EnvRepoProto & StateRepoProto & ConfigRepoProto & ThermoProto
    GetStateUC --> EnvRepoProto & StateRepoProto
    EnvRepo --> EnvRepoProto
    StateRepo --> StateRepoProto
    ConfigRepo --> ConfigRepoProto
    ThermoEngine --> ThermoProto
    EnvRepo --> LocalDS
    StateRepo --> LocalDS
    ConfigRepo --> LocalDS
    style EnvView fill:#121212
    style PanelView fill:#121212
    style TankView fill:#121212
    style StatsView fill:#121212
    style SimVM fill:#121212
    style EnvVM fill:#121212
    style PanelVM fill:#121212
    style TankVM fill:#121212
    style StatsVM fill:#121212
    style SimView fill:#121212
    style Depend fill:#121212
    style App fill:#121212
    style EnvUC fill:#121212
    style HeatTransferUC fill:#121212
    style PumpUC fill:#121212
    style GetStateUC fill:#121212
    style EnvRepoProto fill:#121212
    style StateRepoProto fill:#121212
    style ConfigRepoProto fill:#121212
    style ThermoProto fill:#121212
    style UseCases fill:#454545
    style RepoProtocols fill:#454545
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
