##Parameters
$SubscriptionID="XXX" #Enter here your subscriptionID
$Resourcegroup="XXX" #Write the resourcegroup name here
$Vnet="XXX" #Write the VNET Name here
$Subnetname="XXX"+"-snet" #write your name of the subnet
$Adressspace="XXX.XXX.XXX.XXX/XX" #Write the addressspace here
$NSGName="XXX"+"-nsg" #write a name for your NSG if needed
#For the rules its more easier to create them by hand in my opinion, but it is possible to use "az network nsg rule create" to automate some recurring ones.
$RouteTableName="XXX"+"-rt" #change Routetable name
#For RT Rules you can change/add/update them in line 31 to 37


##Execution Policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

##Installation of AZ Module
Install-Module -Name Az -Repository PSGallery -Force

##login to Azure Tenant
Connect-AzAccount

##change to the subscription
Set-AzContext -Subscription $SubscriptionID

##Creation of the NSG
az network nsg create -g $Resourcegroup -n $NSGName

#RT
#Creation of the RT
az network route-table create -g $Resourcegroup -n $RouteTableName
#Ruleset of the routetable
#Default Rule
az network route-table route create -g $Resourcegroup --route-table-name $RouteTableName -n "Virtual Network" --address-prefix $Adressspace --next-hop-type VnetLocal
#if you want your traffic to the internet is routed over an appliance you can add this rule:
#az network route-table route create -g $Resourcegroup --route-table-name $RouteTableName -n "Internet" --next-hop-type VirtualAppliance --address-prefix 0.0.0.0/0 --next-hop-ip-address xxx.xxx.xxx.xxx
#if you want your traffic to other networks is routed over an appliance you can add this rule:
#az network route-table route create -g $Resourcegroup --route-table-name $RouteTableName -n "Networkname" --next-hop-type VirtualAppliance --address-prefix xxx.xxx.xxx.xxx/xx --next-hop-ip-address xxx.xxx.xxx.xxx

#Create the subnet
az network vnet subnet create -g $Resourcegroup --vnet-name $Vnet -n $Subnetname --address-prefixes $Adressspace --network-security-group $NSGName --route-table $RouteTableName