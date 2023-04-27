<#
.SYNOPSIS
    Module for creating resource group names and resource names in a standardised way in Azure
.EXAMPLE
    New-DefaultResourceGroupName -Environment "st" -Region "aue" -SystemName "abc" -SubSystemName "xyz" -Suffix "1"
    New-DefaultResourceName -ResourceGroupName "ST-AUE-ABC-XYZ-1"

.DESCRIPTION
    The function New-DefaultResourceGroupName creates a default resource group name for an Azure resource. The function takes five parameters:
        Environment: This is a mandatory parameter that takes a string value and is validated against a set of predefined values (dt, st, ut, pr). It represents the environment in which the resource will be deployed.
        Region: This is a mandatory parameter that takes a three-character string value and represents the Azure region where the resource will be deployed.
        SystemName: This is a mandatory parameter that takes a three-character string value and represents the name of the system or application to which the resource belongs.
        SubSystemName: This is an optional parameter that takes a three-character string value and represents a sub-system or module within the system.
        Suffix: This is an optional parameter that takes a string value and represents a suffix to add to the resource group name.
    The function then constructs the resource group name based on the parameters provided. If the SubSystemName and Suffix parameters are not provided, 
    the function constructs the resource group name by concatenating the Environment, Region, and SystemName parameters. If the Suffix parameter is provided, it is appended to the end of the resource group name.
    If the SubSystemName parameter is provided, it is appended to the end of the resource group name, separated by a hyphen. If the resource group with the generated name already exists, an error is thrown.
    If multiple resource groups with the same name are found, the function adds a numeric suffix to the name to ensure uniqueness. The function then returns the generated resource group name.    

    The New-DefaultResourceName function generates a default name for an Azure resource based on the provided resource group name. The function takes one parameter:
        ResourceGroupName: This is a mandatory parameter that takes a string value representing the name of the Azure resource group.
    The function then generates a default name for an Azure resource by removing any hyphens from the resource group name and converting the resulting string to lowercase. This generated name is returned by the function.
    For example, if the ResourceGroupName parameter is set to "my-resource-group", the function would generate the default name "myresourcegroup". This function is useful for generating default names for 
    resources that are created within a resource group, where the resource name is based on the resource group name.

.NOTES
    

.LINK
    https://docs.driesventer.com
#>

#region New-DefaultResourceGroupName
function New-DefaultResourceGroupName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)][ValidateSet('bt', 'dt', 'st', 'it', 'ut', 'pp', 'pd', 'pr')][string]$Environment,
        [Parameter(Mandatory = $true)][ValidateLength(3, 3)][string]$Region,
        [Parameter(Mandatory = $true)][ValidateLength(3, 3)][string]$SystemName,
        [Parameter(Mandatory = $false)][ValidateLength(3, 3)][string]$SubSystemName,
        [Parameter(Mandatory = $false)][string]$Suffix
    )
    if (!$SubSystemName -and !$Suffix) {
        $baseName = ($Environment + "-" + $Region + "-" + $SystemName).ToUpper()
    }
    elseif (!$SubSystemName -and $Suffix) {
        $defaultResourceGroupName = ($Environment + "-" + $Region + "-" + $SystemName + "-" + $Suffix).ToUpper()
    }
    elseif ($SubSystemName -and !$Suffix) {
        $baseName = ($Environment + "-" + $Region + "-" + $SystemName + "-" + $SubSystemName).ToUpper()
    }
    elseif ($SubSystemName -and $Suffix) {
        $defaultResourceGroupName = ($Environment + "-" + $Region + "-" + $SystemName + "-" + $SubSystemName + "-" + $Suffix).ToUpper()
        #check if the resource group already exists
        if (Get-AzResourceGroup -Name $defaultResourceGroupName -ErrorAction SilentlyContinue) {
            throw "Resource group with name $defaultResourceGroupName already exists. Please use a different suffix."
        }
    }
    if ($baseName) {
        $defaultResourceGroupName = ($baseName + "-" + "1").ToUpper()
        $count = 1
        while (Get-AzResourceGroup -Name $defaultResourceGroupName -ErrorAction SilentlyContinue) {
            $count++
            $defaultResourceGroupName = ($baseName + "-" + $count).ToUpper()
        }
    }
    return $defaultResourceGroupName
}
#endregion New-DefaultResourceGroupName

#region New-DefaultResourceName
function New-DefaultResourceName {
    param (
        [Parameter(Mandatory = $true)][string]$ResourceGroupName
    )
    #get last 4 digits from subscriptoin id
    $subscriptionIdSuffix = ((Get-AzContext).Subscription.Id).Substring($subscriptionId.Length - 4)
    $baseName = $ResourceGroupName.Replace("-", "")
    $defaultResourceName = ($baseName+$subscriptionIdSuffix).ToLower()
    return $defaultResourceName   
}
#endregion New-DefaultResourceName

#region Exported Functions
# public (exported)
Export-ModuleMember -function New-DefaultResourceGroupName
Export-ModuleMember -function New-DefaultResourceName

#endregion Exported Functions
