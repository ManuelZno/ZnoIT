#engineered by some awesome german dude :D

#clear all
clear

#context menu
Write-Host "Enter one of the following:"
Write-Host ""
Write-Host "1: Encrypt USB drive"
Write-Host "0: Exit the script"
Write-Host ""
Write-Host "Choose one:"
$Switchvar=Read-Host
Switch ($Switchvar)
{
    1 {clear}
    0 {Exit 0}
}

#check if user input exists
for ($i=0;!($Switchvar -eq 1);$i++)
{
clear
Write-Host "Selection is not existing. Please reenter a drive." -ForegroundColor yellow
Write-Host ""
Write-Host "Enter one of the following:"
Write-Host ""
Write-Host "1: Encrypt USB drive"
Write-Host "0: Exit the script"
Write-Host ""
Write-Host "Choose one:"
$Switchvar=Read-Host
Switch ($Switchvar){
    1 {clear}
    0 {Exit 0}
}}


#Enter parameters
$Drive="C:\TempBitlocker\"  #can be changed with every other path                               
$Driveletter = Read-Host "Please enter the drive Letter without ':'"
$existingdriveLetters= (Get-Volume).DriveLetter

$DrivewithCSVName =$Drive+"Bitlocker2Go.csv"

#check if driveletter exists
for($i=0; !($existingdriveLetters -contains $Driveletter); $i++){ 
$Driveletter = Read-Host "Drive letter not existing. Please reenter the drive letter without ':'"
}

#check if driveletter is already encrypted
if ((get-bitlockervolume -mountpoint $Driveletter).protectionstatus -eq "On"){
Write-Host "Drive is already encrypted. Please check and decrypt it if needed."
pause
Invoke-Expression -Command $PSCommandPath
Exit 0
}


$Number = Read-Host "Please enter the number of USB stick"
$DrivewithFileName =$Drive+$Number+".txt"
$PW = Read-Host "Please enter the Password with minimum 10 digits"

#check if password has 10 characters
for($i=0; $PW.Length -lt 10; $i++){
$PW = Read-Host "Thats too short. Please reenter a longer password with minimum 10 digits"
}

#check if folder exists
if (!(Test-Path $Drive)){
#Create Directory
New-Item -ItemType Directory -Force -Path $Drive
}

#check if file exists and reload script
if (Test-Path $DrivewithFileName){
Write-Host "File already existing. Check and change or delete existing file"
pause
Invoke-Expression -Command $PSCommandPath
Exit 0
}

#Convert PW to SecureString
$SecureString = ConvertTo-SecureString $PW -AsPlainText -Force

#Add Bitlocker to Drive
Write-Host "Drive encrypting in progress. Please wait."
Enable-BitLocker -MountPoint $Driveletter -PasswordProtector -Password $SecureString -EncryptionMethod Aes128 -UsedSpaceOnly
Write-Host "Drive is encrypted."

#Bitlocker Password Save as file
$PW > $DrivewithFileName
Write-Host "File is saved to " $Drive

#add line to CSV
if(Test-Path $DrivewithCSVName){
"{0},{1}" -f $Number,$PW | add-content -path $DrivewithCSVName
Write-Host "CSV line is added"
}
else{
Set-Content $DrivewithCSVName -Value "Number,Password"
"{0},{1}" -f $Number,$PW | add-content -path $DrivewithCSVName
Write-Host "CSV is created and line is added"
}
Write-Host "Script runned successfully. Please click enter to proceed."
pause

#reload the script
Invoke-Expression -Command $PSCommandPath
Exit 0