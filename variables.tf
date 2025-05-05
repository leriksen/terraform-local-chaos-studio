variable "location" {
  type = string
}

variable "service_targets" {
  type = map(
    object(
      {
        target_type  = string
        target_id    = string
        capabilities = optional(list(string), [])
        cspa         = optional(
          object(
            {
              name    = string
              subnets = object(
                {
                  containerSubnetId = string
                  relaySubnetId     = string
                }
              )
            }
          ), null
        )
      }
    )
  )

  validation {
    condition = (
      alltrue(
        [
          for name, service_target in var.service_targets : (
            contains(
              [
                "Microsoft-VirtualMachine",
                "Microsoft-VirtualMachineScaleSet",
                "Microsoft-AzureKubernetesServiceChaosMesh",
                "Microsoft-KeyVault",
              ],
              service_target.target_type
            )
          )
        ]
      )
    )
    error_message = "Must only define targets of supported types"
  }
}
