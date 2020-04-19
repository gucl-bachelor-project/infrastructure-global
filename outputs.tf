output "logging_vm_ip" {
  value       = module.logging_vm.ipv4_address
  description = "IPv4 of business logic VM"
}
