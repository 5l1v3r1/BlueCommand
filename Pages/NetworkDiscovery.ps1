New-UDPage -Name "Network - Discovery" -Icon search -Content {
        
    New-UDInput -Title "Discover Network Resources IPv4 Network Scan" -Id "DiscoveryInput" -Content {
        New-UDInputField -Type 'textarea' -Name 'StartAddress' -Placeholder 'Start IPv4 Address' -DefaultValue '192.168.200.1'
        New-UDInputField -Type 'textarea' -Name 'EndAddress' -Placeholder 'End IPv4 Address' -DefaultValue '192.168.200.255'
    
    } -Endpoint{
        param($StartAddress, $EndAddress)
        
        if (($StartAddress -ne '') -and ($EndAddress -ne ''))
        {
            # Do a IPV4 Scan
            $NetworkScanResults = .\Tools\NetworkScan\IPv4NetworkScan.ps1 -StartIPv4Address $StartAddress -EndIPv4Address $EndAddress

            # Output a new Grid based on that info
            New-UDInputAction -Content @(
            
                New-UDGrid -Title "Network Disovery Results" -Headers @("IPv4", "Status", "Hostname") -Properties @("IPv4", "Status", "Hostname") -Endpoint {
                    $NetworkScanResults | Select-Object -Property Hostname,@{Name="IPv4"; Expression = {$_.IPv4Address.IPAddressToString}},Status | Out-UDGridData
                }
        
            )

            # Save to JSON File

            if(Test-Path '.\scan.json')
            {
                # Clear Existings
                Clear-Content '.\scan.json'
            }
            
            $NetworkScanResults | Select-Object -Property Hostname,@{Name="IPv4"; Expression = {$_.IPv4Address.IPAddressToString}},Status | ConvertTo-Json >> '.\scan.json'

        }
        else {
            New-UDInputAction -Toast "Fill all required fields!"
        }

    }
}
