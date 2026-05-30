infra/
│
├── main.bicep                  ← ORCHESTRATOR (decides what to deploy)
│
├── main-network.bicep         ← deploys VNet only
├── main-compute.bicep         ← deploys VM only
├── main-full.bicep            ← deploys everything (optional)
│
├── modules/
│   ├── vnet.bicep             ← VNet module
│   ├── vm.bicep               ← VM module
│   ├── appservice.bicep       ← App Service module
│   └── sql.bicep              ← SQL module
│
└── environments/
    ├── dev.bicepparam
    ├── test.bicepparam
    └── prod.bicepparam