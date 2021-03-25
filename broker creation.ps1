$clusterName     = 'Cluster38' 
$BrokerName     = 'ReplicaBroker' 
$BrokerIPAddress   = '10.38.0.99' 
$BrokerResourceName = "Virtual Machine Replication Broker" 
$TempBrokerGroupName = $BrokerName + 'Group'

Add-ClusterServerRole -Name $BrokerName -StaticAddress $BrokerIPAddress -IgnoreNetwork 10.38.1.0/24, 10.38.2.0/24 -Cluster $clusterName

Add-ClusterGroup -Name $TempBrokerGroupName -GroupType VMReplicaBroker -Cluster $clusterName

Add-ClusterResource -Name $BrokerResourceName -Group $TempBrokerGroupName -ResourceType 'Virtual Machine Replication Broker' -Cluster $clusterName

Move-ClusterResource -name $BrokerName -Group $TempBrokerGroupName -Cluster $clusterName 

Add-ClusterResourceDependency -Resource $BrokerResourceName -Provider $BrokerName -Cluster $clusterName

Remove-ClusterGroup -Name $BrokerName -RemoveResources -Force -Cluster $clusterName

Get-ClusterGroup -Name $TempBrokerGroupName -Cluster $clusterName | %{ $_.Name = $BrokerName }

Start-ClusterGroup -Name $BrokerName -Cluster $clusterName
Read-Host "Appuyer sur ENTER pour finir le script"