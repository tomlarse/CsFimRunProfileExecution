function RunMaRunProfile
{
    param(
        [string]$MAToRun, 
        [string]$ProfileToRun
    )

    $filter = "Name='" + $MAToRun + "'"
    $MA = Get-WmiObject -Class MIIS_ManagementAgent -Namespace root/MicrosoftIdentityIntegrationServer -Filter $filter

    $result = $MA.Execute($ProfileToRun)

    return $result.ReturnValue
}

function CsFimMaRun
<#
	Runs FIM Run Profiles in the correct order for syncing Lync users

    CsFimMaRun -ManagementAgents @("ResourceForest","UserForest1","UserForest2") -Type Full

		Will run a Full Import, Sync and Export for the listed Management Agents. It is
        important that the Resource Forest Management Agent is listed first in the Array!

	CsFimMaRun -ManagementAgents @("ResourceForest","UserForest1","UserForest2") -Type Delta

		Will run a Delta Import, Sync and Export for the listed Management Agents. It is
        important that the Resource Forest Management Agent is listed first in the Array!
#>
{
    param(
        [Parameter(Mandatory=$true)]$ManagementAgents = @(),
        [Parameter(Mandatory=$true)][ValidateSet("Full","Delta")][string]$Type
    )

    switch ($Type)
    {
        "Full"
        {
            $Sync = "Full Sync"
            $Import = "Full Import"
        }
        "Delta"
        {
            $Sync = "Delta Sync"
            $Import = "Delta Import"
        }
    }

    #Import
    foreach ($MA in $ManagementAgents)
    {
        $result = RunMARunProfile -MAToRun $MA -ProfileToRun $Import
        Write-Debug "$MA Import - $result"
    }

    #Sync
    foreach ($MA in $ManagementAgents)
    {
        $result = RunMARunProfile -MAToRun $MA -ProfileToRun $Sync
        Write-Debug "$MA Sync - $result"
    }

    #Export
    $result = RunMARunProfile -MAToRun $MAs[0] -ProfileToRun "Export"
    Write-Debug "$MA Export - $result"
}

CsFimMaRun -ManagementAgents @("ResourceForest","UserForest1","UserForest2") -Type Delta
#CsFimMaRun -ManagementAgents @("ResourceForest","UserForest1","UserForest2") -Type Full