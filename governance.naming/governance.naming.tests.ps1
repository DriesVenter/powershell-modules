BeforeAll {
    Import-Module ./governance.naming.psm1 -Force   
}
Describe "New-DefaultResourceGroupName" {    
    Context "When all parameters are provided and a new resource group name is created" {
        It "Should return a valid resource group name" {
            $result = New-DefaultResourceGroupName -Environment "st" -Region "aue" -SystemName "abc" -SubSystemName "xyz" -Suffix "1"
            $expected = "ST-AUE-ABC-XYZ-1"
            $result | Should -Be $expected
        }
    }
    Context "When only mandatory parameters are provided and a new resource group name is created" {
        It "Should return a valid resource group name" {
            $result = New-DefaultResourceGroupName -Environment "st" -Region "aue" -SystemName "abc"
            $expected = "ST-AUE-ABC-1"
            $result | Should -Be $expected
        }
    }
    Context "When the resource group already exists" {
        It "Should throw an error" {
            # Arrange
            $existingResourceGroupName = "ST-AUE-ABC-XYZ-1"
            New-AzResourceGroup -Name $existingResourceGroupName -Location "AustraliaEast" -Force

            # Act + Assert
            { New-DefaultResourceGroupName -Environment "st" -Region "aue" -SystemName "abc" -SubSystemName "xyz" -Suffix "1" } | Should -Throw -ExpectedMessage "Resource group with name ST-AUE-ABC-XYZ-1 already exists. Please use a different suffix."
        }
    }
}
Describe "New-DefaultResourceName" {
    Context "When the ResourceGroupName is provided" {
        It "Should return a valid resource group name" {
            $resourceGroupName = "ST-AUE-ABC-XYZ-1"
            $subscriptionIdSuffix = ((Get-AzContext).Subscription.Id).Substring($subscriptionId.Length - 4)
            $result = New-DefaultResourceName -ResourceGroupName $resourceGroupName
            $expected = "staueabcxyz1"+$subscriptionIdSuffix
            $result | Should -Be $expected
        }
    }
}
AfterAll {
    Remove-AzResourceGroup -Name "ST-AUE-ABC-XYZ-1" -Force
}
