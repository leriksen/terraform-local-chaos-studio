# run "rg_provider" {
#   command = apply
#
#   module {
#     source = "./modules/rg"
#   }
#
#   variables {
#     name     = "chaos-studio"
#     location = "australiaeast"
#   }
# }
#
# run "context_provider" {
#   command = apply
#
#   module {
#     source = "./modules/context"
#   }
# }
#
# run "network_provider" {
#   command = apply
#
#   module {
#     source = "./modules/network"
#   }
#
#   variables {
#     rg           = run.rg_provider.rg.name
#     location     = run.rg_provider.rg.location
#     vnet_name    = "chaos"
#     vnet_range   = ["10.0.0.0/24"]
#     subnet_name  = "pe"
#     subnet_size  = 2
#     subnet_index = 0
#   }
# }
#
# run "akv_provider" {
#   command = apply
#
#   module {
#     source = "./modules/akv"
#   }
#
#   variables {
#     rg        = run.rg_provider.rg.name
#     location  = run.rg_provider.rg.location
#     tenant_id = run.context_provider.client_config.tenant_id
#     pe_subnet = run.network_provider.subnet.id
#   }
# }
#
# run "test_chaos_studio" {
#   command = apply
#
#   module {
#     source = "../"
#   }
#
#   variables {
#     location = run.rg_provider.rg.location
#     service_targets = {
#       (run.akv_provider.akv.name) = {
#         target_id   = run.akv_provider.akv.id
#         target_type = "Microsoft-KeyVault"
#         capabilities = [
#           "DenyAccess-1.0",
#           "DisableCertificate-1.0",
#           # "IncrementCertificateVersion-1.0",
#           "UpdateCertificatePolicy-1.0"
#         ]
#       }
#     }
#   }
#
#   assert {
#     condition     = azapi_resource.register_target["validate-target-akv"].parent_id == run.akv_provider.akv.id
#     error_message = "invalid target output"
#   }
# }
