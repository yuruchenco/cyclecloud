using './main.bicep'



param resource_group_name = 'rg-cyclecloud'
param location = 'eastus'
param vnetAddressPrefix = '10.0.0.0/16'
param vnetName = 'vnet-cyclecloud'

param subnet_admin_addressprefix = '10.0.1.0/24'
param subnet_admin_name = 'subnet-admin'
param subnet_anf_addressprefix = '10.0.2.0/24'
param subnet_anf_name = 'subnet-anf'
param subnet_compute_addressprefix = '10.0.3.0/24'
param subnet_compute_name = 'subnet-compute'

/*
param anf_account_name = 'anf_account'
param anf_capacity_pool_name = 'anf_capacity_pool'
param anf_capacity_pool_service_level = 'Standard'
param anf_capacity_pool_size = 4398046511104
param anf_volume_name = 'vol01'
param anf_volume_size = 107374182400
*/
param bastionName = 'bastion'
param bastionsku = 'Standard'
param bastionSubnetAddressPrefix = '10.0.4.0/24'


//VM parameters
param adminPassword = 'P@ssword1234!'
param adminUsername = 'cycleadmin'
param adminVMName = 'vm-admin' 
param adminVMSize = 'Standard_D2s_v3'
param ccVMName = 'vm-cyclecloud'
param ccVMSize  = 'Standard_D2s_v3'
