# Azure Naming Convention

## Summary

To increase the manageability of Azure resources, we need to have a naming convention for all resources. This document describes the naming convention for Azure resources.

## Naming Convention

### Azure Resource Group

The naming components for Azure resource groups is as follows:

- **Environment**: The environment the resource group is deployed to. This can be one of the following:
  - **bt**: Build environment
  - **dt**: Development environment
  - **it**: Integration Test environment
  - **at**: Acceptance environment
  - **ut**: User Acceptance Test environment
  - **pp**: Pre-Production environment
  - **pd**: Production Diagnostic environment
  - **pr**: Production environment
- **Region**: The region the resource group is deployed to. This can be one of the following:
  - **aue**: Australia East
  - **aus**: Australia Southeast
  - **euw**: West Europe
  - **eus**: East US
  - **sea**: Southeast Asia
  - **weu**: West US
  - etc...
- **System**: The system the resource group is deployed to. This must be a 3 letter acronym for the system.
- **SubSystem**: The subsystem the resource group is deployed to. This must be a 3 letter acronym for the subsystem.
- **Suffix**: The suffix for the resource group. Suffix must not be "RG"

Because the resource group name has a fixed length for the mandatory components it makes it easier to calculate a name of the resource group.

```powershell
<environment>-<region>-<system>-<subsystem>-<suffix>
or
<environment>-<region>-<system>-<suffix>
or
<environment>-<region>-<system>
```

#### Examples Resource Group

    Environment: dt
    Region: aue
    System: abc
    SubSystem: xyz
    Suffix: 123
    Resulting Resource Group Name: DT-AUE-ABC-XYZ-123
    
    Environment: dt
    Region: aue
    System: abc
    Resulting Resource Group Name: DT-AUE-ABC
---

### Azure Resource

The naming components for Azure resources is the same as the Azure resource group it is deployed to except the hyphens are removed and the last four characters of the subscription id is suffixed to the name. And is all lowercase. The subscription id is used to ensure the resource name is globally unique. In the case where the resource name is not unique, the resource group name should be suffixed with a number starting at 1 and incrementing until the name is unique.

```powershell
#Depending on the resource group name the resource name can be one of the following:
<environment><region><system><subsystem><suffix><subscriptionidlast4digits>
or
<environment><region><system><suffix><subscriptionidlast4digits>
or
<environment><region><system><subscriptionidlast4digits>
```

#### Examples Resource

    Resource Group Name: DT-AUE-ABC-XYZ-XXX
    and Subscription Id: 12345678-1234-1234-1234-123456789012
    Resulting Resource Name: dtaueabcxyzxxx9012
