<#
.SYNOPSIS
    This PowerShell script creates a new Hyper-V virtual machine.

.DESCRIPTION
    This script generate an GUI that facilitates the creation of a Hyper-V virtual machine by allowing the user to specify parameters such as VM name, memory allocation, number of processors, and the path to the virtual hard disk. The integrated graphical tool simplifies the process of entering these parameters and managing the VM creation.

.PARAMETERS
    -VmName: The name of the virtual machine to create.
    -Memory: The amount of RAM (in MB) to allocate to the VM.
    -ProcessorCount: The number of processors to assign to the VM.
    -VhdPath: The path to the virtual hard disk file (.vhd or .vhdx) for the VM.

.NOTES
    Additional information about the script's functionality and any prerequisites for running the script can be placed here.

.AUTHOR
    Dakhama Mehdi
#>



#----------------------------------------------
#region Application Functions
#----------------------------------------------

#endregion Application Functions

#----------------------------------------------
# Generated Form Function
#----------------------------------------------
function Show-Create-VM1_psf {

	#----------------------------------------------
	#region Import the Assemblies
	#----------------------------------------------
	[void][reflection.assembly]::Load('AspNetMMCExt, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	[void][reflection.assembly]::Load('AspNetMMCExt.resources, Version=2.0.0.0, Culture=fr, PublicKeyToken=b03f5f7f11d50a3a')
	[void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
	[void][reflection.assembly]::Load('System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	[void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
	#endregion Import Assemblies

	#----------------------------------------------
	#region Define SAPIEN Types
	#----------------------------------------------
	try{
		[FolderBrowserModernDialog] | Out-Null
	}
	catch
	{
		Add-Type -ReferencedAssemblies ('System.Windows.Forms') -TypeDefinition  @" 
		using System;
		using System.Windows.Forms;
		using System.Reflection;

        namespace SAPIENTypes
        {
		    public class FolderBrowserModernDialog : System.Windows.Forms.CommonDialog
            {
                private System.Windows.Forms.OpenFileDialog fileDialog;
                public FolderBrowserModernDialog()
                {
                    fileDialog = new System.Windows.Forms.OpenFileDialog();
                    fileDialog.Filter = "Folders|\n";
                    fileDialog.AddExtension = false;
                    fileDialog.CheckFileExists = false;
                    fileDialog.DereferenceLinks = true;
                    fileDialog.Multiselect = false;
                    fileDialog.Title = "Select a folder";
                }

                public string Title
                {
                    get { return fileDialog.Title; }
                    set { fileDialog.Title = value; }
                }

                public string InitialDirectory
                {
                    get { return fileDialog.InitialDirectory; }
                    set { fileDialog.InitialDirectory = value; }
                }
                
                public string SelectedPath
                {
                    get { return fileDialog.FileName; }
                    set { fileDialog.FileName = value; }
                }

                object InvokeMethod(Type type, object obj, string method, object[] parameters)
                {
                    MethodInfo methInfo = type.GetMethod(method, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
                    return methInfo.Invoke(obj, parameters);
                }

                bool ShowOriginalBrowserDialog(IntPtr hwndOwner)
                {
                    using(FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog())
                    {
                        folderBrowserDialog.Description = this.Title;
                        folderBrowserDialog.SelectedPath = !string.IsNullOrEmpty(this.SelectedPath) ? this.SelectedPath : this.InitialDirectory;
                        folderBrowserDialog.ShowNewFolderButton = false;
                        if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
                        {
                            fileDialog.FileName = folderBrowserDialog.SelectedPath;
                            return true;
                        }
                        return false;
                    }
                }

                protected override bool RunDialog(IntPtr hwndOwner)
                {
                    if (Environment.OSVersion.Version.Major >= 6)
                    {      
                        try
                        {
                            bool flag = false;
                            System.Reflection.Assembly assembly = Assembly.Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089");
                            Type typeIFileDialog = assembly.GetType("System.Windows.Forms.FileDialogNative").GetNestedType("IFileDialog", BindingFlags.NonPublic);
                            uint num = 0;
                            object dialog = InvokeMethod(fileDialog.GetType(), fileDialog, "CreateVistaDialog", null);
                            InvokeMethod(fileDialog.GetType(), fileDialog, "OnBeforeVistaDialog", new object[] { dialog });
                            uint options = (uint)InvokeMethod(typeof(System.Windows.Forms.FileDialog), fileDialog, "GetOptions", null) | (uint)0x20;
                            InvokeMethod(typeIFileDialog, dialog, "SetOptions", new object[] { options });
                            Type vistaDialogEventsType = assembly.GetType("System.Windows.Forms.FileDialog").GetNestedType("VistaDialogEvents", BindingFlags.NonPublic);
                            object pfde = Activator.CreateInstance(vistaDialogEventsType, fileDialog);
                            object[] parameters = new object[] { pfde, num };
                            InvokeMethod(typeIFileDialog, dialog, "Advise", parameters);
                            num = (uint)parameters[1];
                            try
                            {
                                int num2 = (int)InvokeMethod(typeIFileDialog, dialog, "Show", new object[] { hwndOwner });
                                flag = 0 == num2;
                            }
                            finally
                            {
                                InvokeMethod(typeIFileDialog, dialog, "Unadvise", new object[] { num });
                                GC.KeepAlive(pfde);
                            }
                            return flag;
                        }
                        catch
                        {
                            return ShowOriginalBrowserDialog(hwndOwner);
                        }
                    }
                    else
                        return ShowOriginalBrowserDialog(hwndOwner);
                }

                public override void Reset()
                {
                    fileDialog.Reset();
                }
            }
       }
"@ -IgnoreWarnings | Out-Null
	}
	#endregion Define SAPIEN Types

	#----------------------------------------------
	#region Generated Form Objects
	#----------------------------------------------
	[System.Windows.Forms.Application]::EnableVisualStyles()
	$formCreateHyperVMachineV = New-Object 'System.Windows.Forms.Form'
	$buttonCreate = New-Object 'System.Windows.Forms.Button'
	$buttonCancel = New-Object 'System.Windows.Forms.Button'
	$buttonBack = New-Object 'System.Windows.Forms.Button'
	$tabcontrolWizard = New-Object 'System.Windows.Forms.TabControl'
	$tabpageStep1 = New-Object 'System.Windows.Forms.TabPage'
	$Confbox = New-Object 'System.Windows.Forms.TextBox'
	$buttonConfPath = New-Object 'System.Windows.Forms.Button'
	$enabledifference = New-Object 'System.Windows.Forms.Button'
	$labelDifferenceMode = New-Object 'System.Windows.Forms.Label'
	$Diffgroupbox = New-Object 'System.Windows.Forms.GroupBox'
	$buttonDifferencielDisk = New-Object 'System.Windows.Forms.Button'
	$difftextbox = New-Object 'System.Windows.Forms.TextBox'
	$buttonHDDPatch = New-Object 'System.Windows.Forms.Button'
	$groupbox1 = New-Object 'System.Windows.Forms.GroupBox'
	$radiobuttonGeneration2 = New-Object 'System.Windows.Forms.RadioButton'
	$radiobuttonGeneration1 = New-Object 'System.Windows.Forms.RadioButton'
	$HDDBox = New-Object 'System.Windows.Forms.TextBox'
	$textboxName = New-Object 'System.Windows.Forms.TextBox'
	$labelVMName = New-Object 'System.Windows.Forms.Label'
	$tabpageStep2 = New-Object 'System.Windows.Forms.TabPage'
	$numrambox = New-Object 'System.Windows.Forms.NumericUpDown'
	$label8 = New-Object 'System.Windows.Forms.Label'
	$labelMB = New-Object 'System.Windows.Forms.Label'
	$labelMin = New-Object 'System.Windows.Forms.Label'
	$label28 = New-Object 'System.Windows.Forms.Label'
	$label22 = New-Object 'System.Windows.Forms.Label'
	$label16 = New-Object 'System.Windows.Forms.Label'
	$label32GB = New-Object 'System.Windows.Forms.Label'
	$label4 = New-Object 'System.Windows.Forms.Label'
	$1 = New-Object 'System.Windows.Forms.Label'
	$labelGB = New-Object 'System.Windows.Forms.Label'
	$checkboxDynamicMemory = New-Object 'System.Windows.Forms.CheckBox'
	$labelCPU = New-Object 'System.Windows.Forms.Label'
	$cpuupdown = New-Object 'System.Windows.Forms.NumericUpDown'
	$Hddsizebox = New-Object 'System.Windows.Forms.TextBox'
	$labelHDDSize = New-Object 'System.Windows.Forms.Label'
	$labelRAMStartup = New-Object 'System.Windows.Forms.Label'
	$checkboxCheckToContinue = New-Object 'System.Windows.Forms.CheckBox'
	$hscrollbar1 = New-Object 'System.Windows.Forms.HScrollBar'
	$tabpageStep3 = New-Object 'System.Windows.Forms.TabPage'
	$groupbox2 = New-Object 'System.Windows.Forms.GroupBox'
	$checkboxServiceGuest = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxSyncronizationTime = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxEnableTPM = New-Object 'System.Windows.Forms.CheckBox'
	$checkboxEnableAutoCheckPoint = New-Object 'System.Windows.Forms.CheckBox'
	$buttonDVDISO = New-Object 'System.Windows.Forms.Button'
	$DVDPatch = New-Object 'System.Windows.Forms.TextBox'
	$labelNetrworkSwitch = New-Object 'System.Windows.Forms.Label'
	$combobox1 = New-Object 'System.Windows.Forms.ComboBox'
	$buttonNext = New-Object 'System.Windows.Forms.Button'
	$menustrip1 = New-Object 'System.Windows.Forms.MenuStrip'
	$openfiledialog1 = New-Object 'System.Windows.Forms.OpenFileDialog'
	$folderbrowsermoderndialog1 = New-Object 'SAPIENTypes.FolderBrowserModernDialog'
	$fileToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$exitToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$aboutToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$languageToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$françaisToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$englishToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$portugalToolStripMenuItem = New-Object 'System.Windows.Forms.ToolStripMenuItem'
	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
	#endregion Generated Form Objects

	#----------------------------------------------
	# User Generated Script
	#----------------------------------------------
	
	#-------------------------------------------------------
	# NOTE: When new TabPage added place the validation code
	# 		in the Test-WizardPage function.
	#-------------------------------------------------------
	
	# Récupérer les propriétés du serveur Hyper-V
	$vmHost = Get-VMHost
	
	# Récupérer l'emplacement par défaut des disques durs virtuels
	$HDDBox.Text = $vmHost.VirtualHardDiskPath
	$Confbox.Text = $vmHost.VirtualMachinePath
	$script:messagecreate = "machine successfully created"
	
	function Test-WizardPage
	{
		[OutputType([boolean])]
		param([System.Windows.Forms.TabPage]$tabPage)
		
		if($tabPage -eq $tabpageStep1)
		{
			#TODO: Enter Validation Code here for Step 1
			if(-not $textboxName.Text)
			{
				return $false	
			}
			
			return $true
		}
		elseif ($tabPage -eq $tabpageStep2)
		{
			#TODO: Enter Validation Code here for Step 2
			if($checkboxCheckToContinue.Checked)
			{
				return $true
			}
			
			return $false
		}
		elseif ($tabPage -eq $tabpageStep3)
		{
			$Results = Get-VMSwitch
			foreach ($item in $Results)
			{
				$combobox1.Items.Add($item.name)
			}		
			{
				return $true
			}
		}
		
		#Add more pages here
		
		return $false
	}
	
	$Finish_Click ={
		#-------------------------------------------------------
		# TODO: Place finalization script here
		#-------------------------------------------------------
		
		$vmName = $textboxName.Text
		$vmPath = $HDDBox.Text # Spécifiez l'emplacement où vous souhaitez stocker les fichiers de la machine virtuelle		
		$vmSwitch = $combobox1.Text # Spécifiez le nom du commutateur virtuel auquel vous souhaitez connecter la machine virtuelle
		$vmMemory  = [int64]$numrambox.Value * 1MB
		$vmVHDSize = [int64]$Hddsizebox.Text * 1GB # Spécifiez la taille du disque dur virtuel
		$vmProcessorCount = [int]$cpuupdown.Value
		
		if ($radiobuttonGeneration1.Checked)
		{
			$VMgeneration = "1"
		}
		else { $VMgeneration = "2" }
		
		# Créer un disque dur virtuel pour la machine virtuelle
		if (!$difftextbox.Text)
		{
			$vmHardDisk = New-VHD -Path "$vmPath\$vmName.vhdx" -SizeBytes $vmVHDSize -ErrorVariable errordisk
		}
		else
		{
			$vmHardDisk = New-VHD -ParentPath $difftextbox.Text -Path "$vmPath\$vmName\$vmName.vhdx" -ErrorVariable errordisk
		}
		
		if ($errordisk)
		{
			[System.Windows.Forms.MessageBox]::Show($errordisk, 'Hyper-v Create Machine')
			&$buttonBack_Click
			&$buttonBack_Click
			return
		}
		
		# Définir les paramètres communs de la machine virtuelle
		$params = @{
			Name			    = $vmName
			MemoryStartupBytes  = $vmMemory
			Generation		    = $VMgeneration
			VHDPath			    = $vmHardDisk.Path
		}
		
		# Ajouter l'option de commutateur réseau si nécessaire
		if ($vmSwitch)
		{
			$params.Add("SwitchName", $vmSwitch)
		}
			
		# Ajouter l'option de chemin de dossier de configuration si nécessaire
		if ($difftextbox.Text)
		{
			$params.Add("Path", $vmPath)
		}
		
		# Créer la machine virtuelle en utilisant les paramètres définis
		$vmConfig = New-VM @params -ErrorVariable errorvm
		
		if ($errorvm)
		{
			[System.Windows.Forms.MessageBox]::Show($errorvm, 'Hyper-v Create Machine')
			&$buttonBack_Click
			&$buttonBack_Click
			return
		}
		
		
		# Configurer le nombre de processeurs
		Set-VMProcessor -VMName $vmName -Count $vmProcessorCount
		
		if ($checkboxEnableTPM.Checked -eq $true)
		{
			$owner = Get-HgsGuardian UntrustedGuardian
			$kp = New-HgsKeyProtector -Owner $owner -AllowUntrustedRoot
			Set-VMKeyProtector -VMName $vmName -KeyProtector $kp.RawData
			Enable-VMTPM -VMName $vmName
		}	
			
		# Ajouter le disque dur virtuel à la configuration de la machine virtuelle
		if ($checkboxSyncronizationTime.Checked -eq $false)
		{
			Disable-VMIntegrationService -VMName $vmName -Name "*Synchronisation*"
		}
		
		if ($checkboxServiceGuest.Checked -eq $true)
		{
			Enable-VMIntegrationService -VMName $vmName -Name "*Services*"
		}
		
		if ($checkboxEnableAutoCheckPoint.Checked -eq $true)
		{
			Set-VM -VMName $vmName -AutomaticCheckpointsEnabled $true
		}
		
		if ($checkboxDynamicMemory.Checked)
		{
			Set-VMMemory -VMName $vmName -DynamicMemoryEnabled $true
		}
		
		if ($DVDPatch.Text)
		{
			$dvddrive = Add-VMDvdDrive -VMName $vmName -Path $DVDPatch.Text
			$vmDVDDrive = Get-VMDvdDrive -VMName $vmName
			Set-VMFirmware -VMName $vmName -FirstBootDevice $vmDVDDrive
		}
		
		#[System.Windows.Forms.MessageBox]::Show("Microsoft Hyper Virtual Easy Manager `r`n`r`nDevelopped By : Dakhama Mehdi `r`n`r`nContribution : Souin Matthieu `r`n`r`nThanks to : Gabriel Luiz `r`n`r`nVersion 2.8.0 `r`nRelease   10/2022 `r`n.NET V3.5.2", 'Hyper - Virtual Easy Manager')
		[System.Windows.Forms.MessageBox]::Show($messagecreate, 'Hyper-v Create Machine')
		
		&$buttonBack_Click
		&$buttonBack_Click
		
		$textboxName.Clear()
		
	}
	
	
	#region Events and Functions
	$formCreateHyperVMachineV_Load={
		Update-NavButtons
	}
	
	function Update-NavButtons
	{
		$enabled = Test-WizardPage $tabcontrolWizard.SelectedTab
		$buttonNext.Enabled = $enabled -and ($tabcontrolWizard.SelectedIndex -lt $tabcontrolWizard.TabCount - 1)
		$buttonBack.Enabled = $tabcontrolWizard.SelectedIndex -gt 0
		$buttonCreate.Enabled = $enabled -and ($tabcontrolWizard.SelectedIndex -eq $tabcontrolWizard.TabCount - 1)	
	}
	
	$script:DeselectedIndex = -1
	$tabcontrolWizard_Deselecting=[System.Windows.Forms.TabControlCancelEventHandler]{
	#Event Argument: $_ = [System.Windows.Forms.TabControlCancelEventArgs]
		# Store the previous tab index
		$script:DeselectedIndex = $_.TabPageIndex
	}
	
	$tabcontrolWizard_Selecting=[System.Windows.Forms.TabControlCancelEventHandler]{
	#Event Argument: $_ = [System.Windows.Forms.TabControlCancelEventArgs]
		# We only validate if we are moving to the Next TabPage. 
		# Users can move back without validating
		if($script:DeselectedIndex -ne -1 -and $script:DeselectedIndex -lt $_.TabPageIndex)
		{
			#Validate each page until we reach the one we want
			for($index = $script:DeselectedIndex; $index -lt $_.TabPageIndex; $index++)
			{
				$_.Cancel = -not (Test-WizardPage $tabcontrolWizard.TabPages[$index])
				
				if($_.Cancel) 
				{
					# Cancel and Return if validation failed.
					return;
				}
			}
		}
		
		Update-NavButtons
	}
	
	$buttonBack_Click={
		#Go to the previous tab page
		if($tabcontrolWizard.SelectedIndex -gt 0)
		{
			$tabcontrolWizard.SelectedIndex--
		}
	}
	
	$buttonNext_Click={	
		#Go to the next tab page
		if($tabcontrolWizard.SelectedIndex -lt $tabcontrolWizard.TabCount - 1)
		{
			$tabcontrolWizard.SelectedIndex++
		}
	}
	
	#endregion
	
	#------------------------------------------------------
	# NOTE: When a Control State changes you should call
	# 		Update-NavButtons to trigger validation
	#------------------------------------------------------
	
	$textboxName_TextChanged={
		Update-NavButtons
	}
	
	$checkboxCheckToContinue_CheckedChanged={
		Update-NavButtons
	}
	
	$radiobuttonOption_CheckedChanged={
		
		if($this.Checked)
		{
			Update-NavButtons
		}
	}
	
	$labelHDDPatch_Click={
		#TODO: Place custom script here
		
	}
	
	$labelRAMStartup_Click={
		#TODO: Place custom script here
		
	}
	
	$labelHDDSize_Click={
		#TODO: Place custom script here
		
	}
	
	$HDDBox_TextChanged={
		#TODO: Place custom script here
		
	}
	
	
	$cpuupdown_ValueChanged={
		#TODO: Place custom script here
		
	}
	
	#region Control Helper Functions
	function Update-ComboBox
	{
	<#
		.SYNOPSIS
			This functions helps you load items into a ComboBox.
		
		.DESCRIPTION
			Use this function to dynamically load items into the ComboBox control.
		
		.PARAMETER ComboBox
			The ComboBox control you want to add items to.
		
		.PARAMETER Items
			The object or objects you wish to load into the ComboBox's Items collection.
		
		.PARAMETER DisplayMember
			Indicates the property to display for the items in this control.
		
		.PARAMETER Append
			Adds the item(s) to the ComboBox without clearing the Items collection.
		
		.EXAMPLE
			Update-ComboBox $combobox1 "Red", "White", "Blue"
		
		.EXAMPLE
			Update-ComboBox $combobox1 "Red" -Append
			Update-ComboBox $combobox1 "White" -Append
			Update-ComboBox $combobox1 "Blue" -Append
		
		.EXAMPLE
			Update-ComboBox $combobox1 (Get-Process) "ProcessName"
		
		.NOTES
			Additional information about the function.
	#>
		
		param
		(
			[Parameter(Mandatory = $true)]
			[ValidateNotNull()]
			[System.Windows.Forms.ComboBox]
			$ComboBox,
			[Parameter(Mandatory = $true)]
			[ValidateNotNull()]
			$Items,
			[Parameter(Mandatory = $false)]
			[string]
			$DisplayMember,
			[switch]
			$Append
		)
		
		if (-not $Append)
		{
			$ComboBox.Items.Clear()
		}
		
		if ($Items -is [Object[]])
		{
			$ComboBox.Items.AddRange($Items)
		}
		elseif ($Items -is [System.Collections.IEnumerable])
		{
			$ComboBox.BeginUpdate()
			foreach ($obj in $Items)
			{
				$ComboBox.Items.Add($obj)
			}
			$ComboBox.EndUpdate()
		}
		else
		{
			$ComboBox.Items.Add($Items)
		}
		
		$ComboBox.DisplayMember = $DisplayMember
	}
	#endregion
	
	
	$combobox1_SelectedIndexChanged={
		#TODO: Place custom script here
		
	}
	
	$tabpageStep3_Click={
		#TODO: Place custom script here
		
	}
	
	$checkboxEnableAutoCheckPoint_CheckedChanged={
		#TODO: Place custom script here
		
	}
	
	$groupbox1_Enter={
		#TODO: Place custom script here
		
	}
	
	$radiobuttonGeneration2_CheckedChanged={
		#TODO: Place custom script here
		
	}
	
	$checkboxDynamicMemory_CheckedChanged={
		#TODO: Place custom script here
		
	}
	
	$labelDVDISO_Click={
		#TODO: Place custom script here
		
	}
	
	$DVDPatch_TextChanged={
		#TODO: Place custom script here
		
	}
	
	$buttonDVDISO_Click={
		#TODO: Place custom script here
		$openfiledialog1.Filter = 'Image (*.ISO)|*.ISO'
		$openfiledialog1.Title = 'Select ISO'
		$openfiledialog1.FileName = ''
		$openfiledialog1.ShowDialog()
		
		$DVDPatch.Text = $openfiledialog1.FileName
	}
	
	$tabpageStep1_Click={
		#TODO: Place custom script here
		
	}
	
	$buttonHDDPatch_Click={
		#TODO: Place custom script here
		$folderbrowsermoderndialog1.ShowDialog()
		$path1 = $folderbrowsermoderndialog1.SelectedPath
		$HDDBox.Text = $folderbrowsermoderndialog1.SelectedPath
		
	}
	
	$difftextbox_TextChanged={
		#TODO: Place custom script here
		
	}
	
	$buttonDifferencielDisk_Click={
		#TODO: Place custom script here
		$openfiledialog1.Filter = 'Disk (*.VHDX)|*.VHDX'
		$openfiledialog1.Title = 'Select Disk'
		$openfiledialog1.FileName = ''
		$openfiledialog1.ShowDialog()
		
		$difftextbox.Text = $openfiledialog1.FileName
	}
	
	
	$hscrollbar1_Scroll=[System.Windows.Forms.ScrollEventHandler]{
	#Event Argument: $_ = [System.Windows.Forms.ScrollEventArgs]
		#TODO: Place custom script here
		$numrambox.Value = [math]::Round($hscrollbar1.Value / 100) * 100
	}
	
	$tabpageStep2_Click={
		#TODO: Place custom script here
		
	}
	
	$Hddsizebox_TextChanged={
		#TODO: Place custom script here
		
	}
	
	$Diffgroupbox_Enter={
		#TODO: Place custom script here
		
	}
	
	$enabledifference_Click={
		#TODO: Place custom script here
		if ($Diffgroupbox.Visible -eq $false)
		{
			$Diffgroupbox.Visible = $true
		}
		else
		{
			$Diffgroupbox.Visible = $false
		}
	}
	
	$numrambox_ValueChanged={
		#TODO: Place custom script here
		
	}
	
	$checkboxEnableTPM_CheckedChanged={
		#TODO: Place custom script here
		
	}
	
	$checkboxSyncronizationTime_CheckedChanged={
		#TODO: Place custom script here
		
	}
	
	$checkboxServiceGuest_CheckedChanged={
		#TODO: Place custom script here
		
	}
	
	$buttonCancel_Click={
		#TODO: Place custom script here
		
	}
	
	$exitToolStripMenuItem_Click={
		#TODO: Place custom script here
		$formCreateHyperVMachineV.Close()
	}
	
	$aboutToolStripMenuItem_Click={
		#TODO: Place custom script here
		[System.Windows.Forms.MessageBox]::Show("Developped By : Dakhama Mehdi`r`n`r`nContribution : Gabriel Luiz`r`n`r`nVersion 1.0 `r`nRelease   03/2024`r`n", 'About Create Hyper-V Machine')
	}
	
	
	$françaisToolStripMenuItem_Click={
		#TODO: Place custom script here
		$labelVMName.Text = "Nom de machine"
		$buttonConfPath.Text = "Configuration"
		$buttonHDDPatch.Text = "Disque"
		$groupbox1.Text = "Choix de génération"
		$checkboxDynamicMemory.Text = "Mémoire dynamique"
		$labelHDDSize.Text = "Taille du disque"
		$labelCPU.Text = "CPU"
		$labelNetrworkSwitch.Text = "Choix du réseau"
		$labelRAMStartup.Text = "RAM démarrage"
		$groupbox2.Text = "Plus d'options"
		$checkboxEnableAutoCheckPoint.Text = "Point de controlle Automatique"
		$checkboxEnableTPM.Text = "Activer TPM"
		$checkboxServiceGuest.Text = "Service d'invité"
		$checkboxSyncronizationTime.Text = "Synchronization date et heure"
		$buttonNext.Text = "Suivant"
		$buttonBack.Text = "Retour"
		$buttonCancel.Text = "Annuler"
		$buttonCreate.Text = "Créer"
		$checkboxCheckToContinue.Text = "Cocher pour continuer"
		$tabpageStep1.Text = "Etape 1"
		$tabpageStep2.Text = "Etape 2"
		$tabpageStep3.Text = "Etape 3"
		$script:messagecreate = "Machine créée avec succes"
	}
	
	$buttonConfPath_Click={
		#TODO: Place custom script here
		
	}
	
	$groupbox2_Enter={
		#TODO: Place custom script here
		
	}
	
	$englishToolStripMenuItem_Click={
		#TODO: Place custom script here
		$labelVMName.Text = "VM Name"
		$buttonConfPath.Text = "Conf Path"
		$buttonHDDPatch.Text = "Disk Parth"
		$groupbox1.Text = "Select Generation"
		$checkboxDynamicMemory.Text = "Memory dynamic"
		$labelHDDSize.Text = "Disk Size"
		$labelNetrworkSwitch.Text = "Select network"
		$labelRAMStartup.Text = "RAM Start'up"
		$groupbox2.Text = "More Settings"
		$checkboxEnableAutoCheckPoint.Text = "Enable Auto CheckPoint"
		$checkboxEnableTPM.Text = "Enable TPM"
		$checkboxServiceGuest.Text = "Service Guest"
		$checkboxSyncronizationTime.Text = "Synchronization date times"
		$buttonNext.Text = "Next"
		$buttonBack.Text = "Back"
		$buttonCancel.Text = "Cancel"
		$buttonCreate.Text = "Create"
		$checkboxCheckToContinue.Text = "Check to Continue"
		$tabpageStep1.Text = "Step 1"
		$tabpageStep2.Text = "Step 2"
		$tabpageStep3.Text = "Step 3"
		$labelDifferenceMode.Text = "Differencing Mode"
		$buttonDifferencielDisk.Text = "Differencing Disk"
		$script:messagecreate = "machine successfully created"
	}
	
	$portugalToolStripMenuItem_Click={
		#TODO: Place custom script here
		$labelVMName.Text = "Nome da VM"
		$buttonConfPath.Text = "Armazenar VM"
		$buttonHDDPatch.Text = "Caminho disco"
		$groupbox1.Text = "Selecione Geração"
		$checkboxDynamicMemory.Text = "Memória dinâmica"
		$labelHDDSize.Text = "Tamanho do disco"
		$labelNetrworkSwitch.Text = "Selecione a rede"
		$labelRAMStartup.Text = "Memória RAM"
		$groupbox2.Text = "Mais Configurações"
		$checkboxEnableAutoCheckPoint.Text = "Pontos Verificação Automático"
		$checkboxEnableTPM.Text = "Habilitar TPM"
		$checkboxServiceGuest.Text = "Serviços convidados"
		$checkboxSyncronizationTime.Text = "Sincronização de data/hora"
		$buttonNext.Text = "Próximo"
		$buttonBack.Text = "Voltar"
		$buttonCancel.Text = "Cancelar"
		$buttonCreate.Text = "Criar"
		$checkboxCheckToContinue.Text = "Marque para Continuar"
		$tabpageStep1.Text = "Passo 1"
		$tabpageStep2.Text = "Passo 2"
		$tabpageStep3.Text = "Passo 3"	
		$labelDifferenceMode.Text = "Modo Diferencial"
		$buttonDifferencielDisk.Text = "Caminho do disco rígido virtual diferencial"
		$script:messagecreate = "máquina criada com sucesso"
	}
	# --End User Generated Script--
	#----------------------------------------------
	#region Generated Events
	#----------------------------------------------
	
	$Form_StateCorrection_Load=
	{
		#Correct the initial state of the form to prevent the .Net maximized form issue
		$formCreateHyperVMachineV.WindowState = $InitialFormWindowState
	}
	
	$Form_Cleanup_FormClosed=
	{
		#Remove all event handlers from the controls
		try
		{
			$buttonCreate.remove_Click($Finish_Click)
			$buttonCancel.remove_Click($buttonCancel_Click)
			$buttonBack.remove_Click($buttonBack_Click)
			$buttonConfPath.remove_Click($buttonConfPath_Click)
			$enabledifference.remove_Click($enabledifference_Click)
			$buttonDifferencielDisk.remove_Click($buttonDifferencielDisk_Click)
			$difftextbox.remove_TextChanged($difftextbox_TextChanged)
			$Diffgroupbox.remove_Enter($Diffgroupbox_Enter)
			$buttonHDDPatch.remove_Click($buttonHDDPatch_Click)
			$radiobuttonGeneration2.remove_CheckedChanged($radiobuttonGeneration2_CheckedChanged)
			$groupbox1.remove_Enter($groupbox1_Enter)
			$HDDBox.remove_TextChanged($HDDBox_TextChanged)
			$textboxName.remove_TextChanged($textboxName_TextChanged)
			$tabpageStep1.remove_Click($tabpageStep1_Click)
			$numrambox.remove_ValueChanged($numrambox_ValueChanged)
			$checkboxDynamicMemory.remove_CheckedChanged($checkboxDynamicMemory_CheckedChanged)
			$cpuupdown.remove_ValueChanged($cpuupdown_ValueChanged)
			$Hddsizebox.remove_TextChanged($Hddsizebox_TextChanged)
			$labelHDDSize.remove_Click($labelHDDSize_Click)
			$labelRAMStartup.remove_Click($labelRAMStartup_Click)
			$checkboxCheckToContinue.remove_CheckedChanged($checkboxCheckToContinue_CheckedChanged)
			$hscrollbar1.remove_Scroll($hscrollbar1_Scroll)
			$tabpageStep2.remove_Click($tabpageStep2_Click)
			$checkboxServiceGuest.remove_CheckedChanged($checkboxServiceGuest_CheckedChanged)
			$checkboxSyncronizationTime.remove_CheckedChanged($checkboxSyncronizationTime_CheckedChanged)
			$checkboxEnableTPM.remove_CheckedChanged($checkboxEnableTPM_CheckedChanged)
			$checkboxEnableAutoCheckPoint.remove_CheckedChanged($checkboxEnableAutoCheckPoint_CheckedChanged)
			$groupbox2.remove_Enter($groupbox2_Enter)
			$buttonDVDISO.remove_Click($buttonDVDISO_Click)
			$DVDPatch.remove_TextChanged($DVDPatch_TextChanged)
			$combobox1.remove_SelectedIndexChanged($combobox1_SelectedIndexChanged)
			$tabpageStep3.remove_Click($tabpageStep3_Click)
			$tabcontrolWizard.remove_Selecting($tabcontrolWizard_Selecting)
			$tabcontrolWizard.remove_Deselecting($tabcontrolWizard_Deselecting)
			$buttonNext.remove_Click($buttonNext_Click)
			$formCreateHyperVMachineV.remove_Load($formCreateHyperVMachineV_Load)
			$exitToolStripMenuItem.remove_Click($exitToolStripMenuItem_Click)
			$aboutToolStripMenuItem.remove_Click($aboutToolStripMenuItem_Click)
			$françaisToolStripMenuItem.remove_Click($françaisToolStripMenuItem_Click)
			$englishToolStripMenuItem.remove_Click($englishToolStripMenuItem_Click)
			$portugalToolStripMenuItem.remove_Click($portugalToolStripMenuItem_Click)
			$formCreateHyperVMachineV.remove_Load($Form_StateCorrection_Load)
			$formCreateHyperVMachineV.remove_FormClosed($Form_Cleanup_FormClosed)
		}
		catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
	}
	#endregion Generated Events

	#----------------------------------------------
	#region Generated Form Code
	#----------------------------------------------
	$formCreateHyperVMachineV.SuspendLayout()
	$tabcontrolWizard.SuspendLayout()
	$tabpageStep1.SuspendLayout()
	$Diffgroupbox.SuspendLayout()
	$groupbox1.SuspendLayout()
	$tabpageStep2.SuspendLayout()
	$numrambox.BeginInit()
	$cpuupdown.BeginInit()
	$tabpageStep3.SuspendLayout()
	$groupbox2.SuspendLayout()
	$menustrip1.SuspendLayout()
	#
	# formCreateHyperVMachineV
	#
	$formCreateHyperVMachineV.Controls.Add($buttonCreate)
	$formCreateHyperVMachineV.Controls.Add($buttonCancel)
	$formCreateHyperVMachineV.Controls.Add($buttonBack)
	$formCreateHyperVMachineV.Controls.Add($tabcontrolWizard)
	$formCreateHyperVMachineV.Controls.Add($buttonNext)
	$formCreateHyperVMachineV.Controls.Add($menustrip1)
	$formCreateHyperVMachineV.AutoScaleDimensions = '8, 17'
	$formCreateHyperVMachineV.AutoScaleMode = 'Font'
	$formCreateHyperVMachineV.CancelButton = $buttonCancel
	$formCreateHyperVMachineV.ClientSize = '728, 452'
	$formCreateHyperVMachineV.FormBorderStyle = 'FixedDialog'
	$formCreateHyperVMachineV.MainMenuStrip = $menustrip1
	$formCreateHyperVMachineV.Margin = '5, 5, 5, 5'
	$formCreateHyperVMachineV.MaximizeBox = $False
	$formCreateHyperVMachineV.Name = 'formCreateHyperVMachineV'
	$formCreateHyperVMachineV.StartPosition = 'CenterScreen'
	$formCreateHyperVMachineV.Text = 'Create Hyper-V Machine V1.0'
	$formCreateHyperVMachineV.add_Load($formCreateHyperVMachineV_Load)
	#
	# buttonCreate
	#
	$buttonCreate.Location = '608, 406'
	$buttonCreate.Margin = '4, 4, 4, 4'
	$buttonCreate.Name = 'buttonCreate'
	$buttonCreate.Size = '100, 30'
	$buttonCreate.TabIndex = 4
	$buttonCreate.Text = 'Create'
	$buttonCreate.UseCompatibleTextRendering = $True
	$buttonCreate.UseVisualStyleBackColor = $True
	$buttonCreate.add_Click($Finish_Click)
	#
	# buttonCancel
	#
	$buttonCancel.Anchor = 'Bottom, Right'
	$buttonCancel.DialogResult = 'Cancel'
	$buttonCancel.Location = '504, 406'
	$buttonCancel.Margin = '4, 4, 4, 4'
	$buttonCancel.Name = 'buttonCancel'
	$buttonCancel.Size = '100, 30'
	$buttonCancel.TabIndex = 2
	$buttonCancel.Text = '&Cancel'
	$buttonCancel.UseCompatibleTextRendering = $True
	$buttonCancel.UseVisualStyleBackColor = $True
	$buttonCancel.add_Click($buttonCancel_Click)
	#
	# buttonBack
	#
	$buttonBack.Anchor = 'Bottom, Left'
	$buttonBack.Location = '17, 406'
	$buttonBack.Margin = '4, 4, 4, 4'
	$buttonBack.Name = 'buttonBack'
	$buttonBack.Size = '100, 30'
	$buttonBack.TabIndex = 1
	$buttonBack.Text = '< &Back'
	$buttonBack.UseCompatibleTextRendering = $True
	$buttonBack.UseVisualStyleBackColor = $True
	$buttonBack.add_Click($buttonBack_Click)
	#
	# tabcontrolWizard
	#
	$tabcontrolWizard.Controls.Add($tabpageStep1)
	$tabcontrolWizard.Controls.Add($tabpageStep2)
	$tabcontrolWizard.Controls.Add($tabpageStep3)
	$tabcontrolWizard.Anchor = 'Top, Bottom, Left, Right'
	$tabcontrolWizard.Location = '17, 28'
	$tabcontrolWizard.Margin = '4, 4, 4, 4'
	$tabcontrolWizard.Name = 'tabcontrolWizard'
	$tabcontrolWizard.SelectedIndex = 0
	$tabcontrolWizard.Size = '695, 370'
	$tabcontrolWizard.TabIndex = 0
	$tabcontrolWizard.add_Selecting($tabcontrolWizard_Selecting)
	$tabcontrolWizard.add_Deselecting($tabcontrolWizard_Deselecting)
	#
	# tabpageStep1
	#
	$tabpageStep1.Controls.Add($Confbox)
	$tabpageStep1.Controls.Add($buttonConfPath)
	$tabpageStep1.Controls.Add($enabledifference)
	$tabpageStep1.Controls.Add($labelDifferenceMode)
	$tabpageStep1.Controls.Add($Diffgroupbox)
	$tabpageStep1.Controls.Add($buttonHDDPatch)
	$tabpageStep1.Controls.Add($groupbox1)
	$tabpageStep1.Controls.Add($HDDBox)
	$tabpageStep1.Controls.Add($textboxName)
	$tabpageStep1.Controls.Add($labelVMName)
	$tabpageStep1.Location = '4, 26'
	$tabpageStep1.Margin = '4, 4, 4, 4'
	$tabpageStep1.Name = 'tabpageStep1'
	$tabpageStep1.Padding = '4, 4, 4, 4'
	$tabpageStep1.Size = '687, 340'
	$tabpageStep1.TabIndex = 0
	$tabpageStep1.Text = 'Step 1'
	$tabpageStep1.UseVisualStyleBackColor = $True
	$tabpageStep1.add_Click($tabpageStep1_Click)
	#
	# Confbox
	#
	$Confbox.Location = '135, 116'
	$Confbox.Margin = '5, 5, 5, 5'
	$Confbox.Name = 'Confbox'
	$Confbox.ReadOnly = $True
	$Confbox.Size = '344, 23'
	$Confbox.TabIndex = 12
	#
	# buttonConfPath
	#
	$buttonConfPath.Location = '12, 112'
	$buttonConfPath.Margin = '4, 4, 4, 4'
	$buttonConfPath.Name = 'buttonConfPath'
	$buttonConfPath.Size = '114, 30'
	$buttonConfPath.TabIndex = 11
	$buttonConfPath.Text = 'Conf path'
	$buttonConfPath.UseCompatibleTextRendering = $True
	$buttonConfPath.UseVisualStyleBackColor = $True
	$buttonConfPath.add_Click($buttonConfPath_Click)
	#
	# enabledifference
	#
	$enabledifference.Location = '130, 234'
	$enabledifference.Margin = '4, 4, 4, 4'
	$enabledifference.Name = 'enabledifference'
	$enabledifference.Size = '29, 28'
	$enabledifference.TabIndex = 10
	$enabledifference.Text = '>'
	$enabledifference.UseCompatibleTextRendering = $True
	$enabledifference.UseVisualStyleBackColor = $True
	$enabledifference.add_Click($enabledifference_Click)
	#
	# labelDifferenceMode
	#
	$labelDifferenceMode.AutoSize = $True
	$labelDifferenceMode.Location = '12, 240'
	$labelDifferenceMode.Margin = '5, 0, 5, 0'
	$labelDifferenceMode.Name = 'labelDifferenceMode'
	$labelDifferenceMode.Size = '109, 21'
	$labelDifferenceMode.TabIndex = 9
	$labelDifferenceMode.Text = 'Difference mode'
	$labelDifferenceMode.UseCompatibleTextRendering = $True
	#
	# Diffgroupbox
	#
	$Diffgroupbox.Controls.Add($buttonDifferencielDisk)
	$Diffgroupbox.Controls.Add($difftextbox)
	$Diffgroupbox.Location = '12, 265'
	$Diffgroupbox.Margin = '4, 4, 4, 4'
	$Diffgroupbox.Name = 'Diffgroupbox'
	$Diffgroupbox.Padding = '4, 4, 4, 4'
	$Diffgroupbox.Size = '467, 67'
	$Diffgroupbox.TabIndex = 8
	$Diffgroupbox.TabStop = $False
	$Diffgroupbox.Text = 'Differenciel Disk'
	$Diffgroupbox.UseCompatibleTextRendering = $True
	$Diffgroupbox.Visible = $False
	$Diffgroupbox.add_Enter($Diffgroupbox_Enter)
	#
	# buttonDifferencielDisk
	#
	$buttonDifferencielDisk.Location = '8, 24'
	$buttonDifferencielDisk.Margin = '4, 4, 4, 4'
	$buttonDifferencielDisk.Name = 'buttonDifferencielDisk'
	$buttonDifferencielDisk.Size = '117, 27'
	$buttonDifferencielDisk.TabIndex = 6
	$buttonDifferencielDisk.Text = 'Differenciel disk'
	$buttonDifferencielDisk.UseCompatibleTextRendering = $True
	$buttonDifferencielDisk.UseVisualStyleBackColor = $True
	$buttonDifferencielDisk.add_Click($buttonDifferencielDisk_Click)
	#
	# difftextbox
	#
	$difftextbox.Location = '134, 28'
	$difftextbox.Margin = '5, 5, 5, 5'
	$difftextbox.Name = 'difftextbox'
	$difftextbox.ReadOnly = $True
	$difftextbox.Size = '321, 23'
	$difftextbox.TabIndex = 7
	$difftextbox.add_TextChanged($difftextbox_TextChanged)
	#
	# buttonHDDPatch
	#
	$buttonHDDPatch.Location = '12, 65'
	$buttonHDDPatch.Margin = '4, 4, 4, 4'
	$buttonHDDPatch.Name = 'buttonHDDPatch'
	$buttonHDDPatch.Size = '114, 30'
	$buttonHDDPatch.TabIndex = 3
	$buttonHDDPatch.Text = 'HDD patch'
	$buttonHDDPatch.UseCompatibleTextRendering = $True
	$buttonHDDPatch.UseVisualStyleBackColor = $True
	$buttonHDDPatch.add_Click($buttonHDDPatch_Click)
	#
	# groupbox1
	#
	$groupbox1.Controls.Add($radiobuttonGeneration2)
	$groupbox1.Controls.Add($radiobuttonGeneration1)
	$groupbox1.Location = '12, 161'
	$groupbox1.Margin = '4, 4, 4, 4'
	$groupbox1.Name = 'groupbox1'
	$groupbox1.Padding = '4, 4, 4, 4'
	$groupbox1.Size = '270, 65'
	$groupbox1.TabIndex = 4
	$groupbox1.TabStop = $False
	$groupbox1.Text = 'Select Generation'
	$groupbox1.UseCompatibleTextRendering = $True
	$groupbox1.add_Enter($groupbox1_Enter)
	#
	# radiobuttonGeneration2
	#
	$radiobuttonGeneration2.Checked = $True
	$radiobuttonGeneration2.Location = '131, 25'
	$radiobuttonGeneration2.Margin = '4, 4, 4, 4'
	$radiobuttonGeneration2.Name = 'radiobuttonGeneration2'
	$radiobuttonGeneration2.Size = '139, 31'
	$radiobuttonGeneration2.TabIndex = 1
	$radiobuttonGeneration2.TabStop = $True
	$radiobuttonGeneration2.Text = 'Generation 2'
	$radiobuttonGeneration2.UseCompatibleTextRendering = $True
	$radiobuttonGeneration2.UseVisualStyleBackColor = $True
	$radiobuttonGeneration2.add_CheckedChanged($radiobuttonGeneration2_CheckedChanged)
	#
	# radiobuttonGeneration1
	#
	$radiobuttonGeneration1.Location = '8, 26'
	$radiobuttonGeneration1.Margin = '4, 4, 4, 4'
	$radiobuttonGeneration1.Name = 'radiobuttonGeneration1'
	$radiobuttonGeneration1.Size = '139, 31'
	$radiobuttonGeneration1.TabIndex = 4
	$radiobuttonGeneration1.Text = 'Generation 1'
	$radiobuttonGeneration1.UseCompatibleTextRendering = $True
	$radiobuttonGeneration1.UseVisualStyleBackColor = $True
	#
	# HDDBox
	#
	$HDDBox.Location = '135, 69'
	$HDDBox.Margin = '5, 5, 5, 5'
	$HDDBox.Name = 'HDDBox'
	$HDDBox.ReadOnly = $True
	$HDDBox.Size = '344, 23'
	$HDDBox.TabIndex = 5
	$HDDBox.add_TextChanged($HDDBox_TextChanged)
	#
	# textboxName
	#
	$textboxName.Location = '135, 23'
	$textboxName.Margin = '5, 5, 5, 5'
	$textboxName.MaxLength = 20
	$textboxName.Name = 'textboxName'
	$textboxName.Size = '344, 23'
	$textboxName.TabIndex = 1
	$textboxName.add_TextChanged($textboxName_TextChanged)
	#
	# labelVMName
	#
	$labelVMName.AutoSize = $True
	$labelVMName.Location = '12, 26'
	$labelVMName.Margin = '5, 0, 5, 0'
	$labelVMName.Name = 'labelVMName'
	$labelVMName.Size = '84, 21'
	$labelVMName.TabIndex = 0
	$labelVMName.Text = 'VM name    :'
	$labelVMName.UseCompatibleTextRendering = $True
	#
	# tabpageStep2
	#
	$tabpageStep2.Controls.Add($numrambox)
	$tabpageStep2.Controls.Add($label8)
	$tabpageStep2.Controls.Add($labelMB)
	$tabpageStep2.Controls.Add($labelMin)
	$tabpageStep2.Controls.Add($label28)
	$tabpageStep2.Controls.Add($label22)
	$tabpageStep2.Controls.Add($label16)
	$tabpageStep2.Controls.Add($label32GB)
	$tabpageStep2.Controls.Add($label4)
	$tabpageStep2.Controls.Add($1)
	$tabpageStep2.Controls.Add($labelGB)
	$tabpageStep2.Controls.Add($checkboxDynamicMemory)
	$tabpageStep2.Controls.Add($labelCPU)
	$tabpageStep2.Controls.Add($cpuupdown)
	$tabpageStep2.Controls.Add($Hddsizebox)
	$tabpageStep2.Controls.Add($labelHDDSize)
	$tabpageStep2.Controls.Add($labelRAMStartup)
	$tabpageStep2.Controls.Add($checkboxCheckToContinue)
	$tabpageStep2.Controls.Add($hscrollbar1)
	$tabpageStep2.Location = '4, 26'
	$tabpageStep2.Margin = '4, 4, 4, 4'
	$tabpageStep2.Name = 'tabpageStep2'
	$tabpageStep2.Padding = '4, 4, 4, 4'
	$tabpageStep2.Size = '687, 340'
	$tabpageStep2.TabIndex = 1
	$tabpageStep2.Text = 'Step 2'
	$tabpageStep2.UseVisualStyleBackColor = $True
	$tabpageStep2.add_Click($tabpageStep2_Click)
	#
	# numrambox
	#
	$numrambox.Increment = 100
	$numrambox.Location = '118, 65'
	$numrambox.Margin = '4, 4, 4, 4'
	$numrambox.Maximum = 32000
	$numrambox.Minimum = 500
	$numrambox.Name = 'numrambox'
	$numrambox.Size = '65, 23'
	$numrambox.TabIndex = 27
	$numrambox.Value = 1000
	$numrambox.add_ValueChanged($numrambox_ValueChanged)
	#
	# label8
	#
	$label8.AutoSize = $True
	$label8.Location = '299, 44'
	$label8.Margin = '4, 0, 4, 0'
	$label8.Name = 'label8'
	$label8.Size = '61, 21'
	$label8.TabIndex = 26
	$label8.Text = '|| 8||||||||||'
	$label8.UseCompatibleTextRendering = $True
	#
	# labelMB
	#
	$labelMB.AutoSize = $True
	$labelMB.Location = '191, 67'
	$labelMB.Margin = '4, 0, 4, 0'
	$labelMB.Name = 'labelMB'
	$labelMB.Size = '26, 21'
	$labelMB.TabIndex = 25
	$labelMB.Text = 'MB'
	$labelMB.UseCompatibleTextRendering = $True
	#
	# labelMin
	#
	$labelMin.AutoSize = $True
	$labelMin.Location = '224, 44'
	$labelMin.Margin = '4, 0, 4, 0'
	$labelMin.Name = 'labelMin'
	$labelMin.Size = '28, 21'
	$labelMin.TabIndex = 24
	$labelMin.Text = 'Min'
	$labelMin.UseCompatibleTextRendering = $True
	#
	# label28
	#
	$label28.AutoSize = $True
	$label28.ForeColor = 'Red'
	$label28.Location = '449, 44'
	$label28.Margin = '4, 0, 4, 0'
	$label28.Name = 'label28'
	$label28.Size = '36, 21'
	$label28.TabIndex = 23
	$label28.Text = '28||||'
	$label28.UseCompatibleTextRendering = $True
	#
	# label22
	#
	$label22.AutoSize = $True
	$label22.ForeColor = '255, 128, 0'
	$label22.Location = '406, 44'
	$label22.Margin = '4, 0, 4, 0'
	$label22.Name = 'label22'
	$label22.Size = '36, 21'
	$label22.TabIndex = 22
	$label22.Text = '22||||'
	$label22.UseCompatibleTextRendering = $True
	#
	# label16
	#
	$label16.AutoSize = $True
	$label16.ForeColor = 'Blue'
	$label16.Location = '361, 44'
	$label16.Margin = '4, 0, 4, 0'
	$label16.Name = 'label16'
	$label16.Size = '39, 21'
	$label16.TabIndex = 21
	$label16.Text = '16|||||'
	$label16.UseCompatibleTextRendering = $True
	#
	# label32GB
	#
	$label32GB.AutoSize = $True
	$label32GB.Location = '488, 44'
	$label32GB.Margin = '4, 0, 4, 0'
	$label32GB.Name = 'label32GB'
	$label32GB.Size = '45, 21'
	$label32GB.TabIndex = 20
	$label32GB.Text = '32 GB'
	$label32GB.UseCompatibleTextRendering = $True
	#
	# label4
	#
	$label4.AutoSize = $True
	$label4.ForeColor = '192, 192, 0'
	$label4.Location = '278, 44'
	$label4.Margin = '4, 0, 4, 0'
	$label4.Name = 'label4'
	$label4.Size = '24, 21'
	$label4.TabIndex = 18
	$label4.Text = '4|||'
	$label4.UseCompatibleTextRendering = $True
	#
	# 1
	#
	$1.AutoSize = $True
	$1.ForeColor = 'Lime'
	$1.Location = '257, 44'
	$1.Margin = '4, 0, 4, 0'
	$1.Name = '1'
	$1.Size = '24, 21'
	$1.TabIndex = 17
	$1.Text = '1|||'
	$1.UseCompatibleTextRendering = $True
	#
	# labelGB
	#
	$labelGB.AutoSize = $True
	$labelGB.Location = '167, 165'
	$labelGB.Margin = '5, 0, 5, 0'
	$labelGB.Name = 'labelGB'
	$labelGB.Size = '26, 21'
	$labelGB.TabIndex = 14
	$labelGB.Text = 'GB'
	$labelGB.UseCompatibleTextRendering = $True
	#
	# checkboxDynamicMemory
	#
	$checkboxDynamicMemory.CheckAlign = 'MiddleRight'
	$checkboxDynamicMemory.Checked = $True
	$checkboxDynamicMemory.CheckState = 'Checked'
	$checkboxDynamicMemory.Location = '8, 105'
	$checkboxDynamicMemory.Margin = '4, 4, 4, 4'
	$checkboxDynamicMemory.Name = 'checkboxDynamicMemory'
	$checkboxDynamicMemory.Size = '159, 31'
	$checkboxDynamicMemory.TabIndex = 3
	$checkboxDynamicMemory.Text = 'Dynamic Memory'
	$checkboxDynamicMemory.UseCompatibleTextRendering = $True
	$checkboxDynamicMemory.UseVisualStyleBackColor = $True
	$checkboxDynamicMemory.add_CheckedChanged($checkboxDynamicMemory_CheckedChanged)
	#
	# labelCPU
	#
	$labelCPU.AutoSize = $True
	$labelCPU.Location = '8, 218'
	$labelCPU.Margin = '5, 0, 5, 0'
	$labelCPU.Name = 'labelCPU'
	$labelCPU.Size = '35, 21'
	$labelCPU.TabIndex = 12
	$labelCPU.Text = 'CPU'
	$labelCPU.UseCompatibleTextRendering = $True
	#
	# cpuupdown
	#
	$cpuupdown.Location = '118, 216'
	$cpuupdown.Margin = '4, 4, 4, 4'
	$cpuupdown.Maximum = 16
	$cpuupdown.Minimum = 1
	$cpuupdown.Name = 'cpuupdown'
	$cpuupdown.Size = '48, 23'
	$cpuupdown.TabIndex = 5
	$cpuupdown.Value = 1
	$cpuupdown.add_ValueChanged($cpuupdown_ValueChanged)
	#
	# Hddsizebox
	#
	$Hddsizebox.Location = '118, 162'
	$Hddsizebox.Margin = '5, 5, 5, 5'
	$Hddsizebox.MaxLength = 4
	$Hddsizebox.Name = 'Hddsizebox'
	$Hddsizebox.Size = '48, 23'
	$Hddsizebox.TabIndex = 4
	$Hddsizebox.Text = '100'
	$Hddsizebox.add_TextChanged($Hddsizebox_TextChanged)
	#
	# labelHDDSize
	#
	$labelHDDSize.AutoSize = $True
	$labelHDDSize.Location = '8, 165'
	$labelHDDSize.Margin = '5, 0, 5, 0'
	$labelHDDSize.Name = 'labelHDDSize'
	$labelHDDSize.Size = '65, 21'
	$labelHDDSize.TabIndex = 11
	$labelHDDSize.Text = 'HDD size'
	$labelHDDSize.UseCompatibleTextRendering = $True
	$labelHDDSize.add_Click($labelHDDSize_Click)
	#
	# labelRAMStartup
	#
	$labelRAMStartup.AutoSize = $True
	$labelRAMStartup.Location = '8, 67'
	$labelRAMStartup.Margin = '5, 0, 5, 0'
	$labelRAMStartup.Name = 'labelRAMStartup'
	$labelRAMStartup.Size = '89, 21'
	$labelRAMStartup.TabIndex = 10
	$labelRAMStartup.Text = 'RAM Start''up'
	$labelRAMStartup.UseCompatibleTextRendering = $True
	$labelRAMStartup.add_Click($labelRAMStartup_Click)
	#
	# checkboxCheckToContinue
	#
	$checkboxCheckToContinue.Location = '8, 19'
	$checkboxCheckToContinue.Margin = '4, 4, 4, 4'
	$checkboxCheckToContinue.Name = 'checkboxCheckToContinue'
	$checkboxCheckToContinue.Size = '218, 31'
	$checkboxCheckToContinue.TabIndex = 1
	$checkboxCheckToContinue.Text = 'Check to Continue'
	$checkboxCheckToContinue.UseCompatibleTextRendering = $True
	$checkboxCheckToContinue.UseVisualStyleBackColor = $True
	$checkboxCheckToContinue.add_CheckedChanged($checkboxCheckToContinue_CheckedChanged)
	#
	# hscrollbar1
	#
	$hscrollbar1.LargeChange = 100
	$hscrollbar1.Location = '224, 65'
	$hscrollbar1.Maximum = 32000
	$hscrollbar1.Minimum = 500
	$hscrollbar1.Name = 'hscrollbar1'
	$hscrollbar1.Size = '298, 22'
	$hscrollbar1.SmallChange = 100
	$hscrollbar1.TabIndex = 15
	$hscrollbar1.Value = 1000
	$hscrollbar1.add_Scroll($hscrollbar1_Scroll)
	#
	# tabpageStep3
	#
	$tabpageStep3.Controls.Add($groupbox2)
	$tabpageStep3.Controls.Add($buttonDVDISO)
	$tabpageStep3.Controls.Add($DVDPatch)
	$tabpageStep3.Controls.Add($labelNetrworkSwitch)
	$tabpageStep3.Controls.Add($combobox1)
	$tabpageStep3.Location = '4, 26'
	$tabpageStep3.Margin = '4, 4, 4, 4'
	$tabpageStep3.Name = 'tabpageStep3'
	$tabpageStep3.Size = '687, 340'
	$tabpageStep3.TabIndex = 2
	$tabpageStep3.Text = 'Step 3'
	$tabpageStep3.UseVisualStyleBackColor = $True
	$tabpageStep3.add_Click($tabpageStep3_Click)
	#
	# groupbox2
	#
	$groupbox2.Controls.Add($checkboxServiceGuest)
	$groupbox2.Controls.Add($checkboxSyncronizationTime)
	$groupbox2.Controls.Add($checkboxEnableTPM)
	$groupbox2.Controls.Add($checkboxEnableAutoCheckPoint)
	$groupbox2.Location = '14, 135'
	$groupbox2.Margin = '4, 4, 4, 4'
	$groupbox2.Name = 'groupbox2'
	$groupbox2.Padding = '4, 4, 4, 4'
	$groupbox2.Size = '500, 192'
	$groupbox2.TabIndex = 9
	$groupbox2.TabStop = $False
	$groupbox2.Text = 'More Settings'
	$groupbox2.UseCompatibleTextRendering = $True
	$groupbox2.add_Enter($groupbox2_Enter)
	#
	# checkboxServiceGuest
	#
	$checkboxServiceGuest.CheckAlign = 'MiddleRight'
	$checkboxServiceGuest.Location = '8, 153'
	$checkboxServiceGuest.Margin = '4, 4, 4, 4'
	$checkboxServiceGuest.Name = 'checkboxServiceGuest'
	$checkboxServiceGuest.Size = '233, 31'
	$checkboxServiceGuest.TabIndex = 8
	$checkboxServiceGuest.Text = 'Service Guest'
	$checkboxServiceGuest.UseCompatibleTextRendering = $True
	$checkboxServiceGuest.UseVisualStyleBackColor = $True
	$checkboxServiceGuest.add_CheckedChanged($checkboxServiceGuest_CheckedChanged)
	#
	# checkboxSyncronizationTime
	#
	$checkboxSyncronizationTime.CheckAlign = 'MiddleRight'
	$checkboxSyncronizationTime.Checked = $True
	$checkboxSyncronizationTime.CheckState = 'Checked'
	$checkboxSyncronizationTime.Location = '8, 114'
	$checkboxSyncronizationTime.Margin = '4, 4, 4, 4'
	$checkboxSyncronizationTime.Name = 'checkboxSyncronizationTime'
	$checkboxSyncronizationTime.Size = '233, 31'
	$checkboxSyncronizationTime.TabIndex = 7
	$checkboxSyncronizationTime.Text = 'Syncronization Time'
	$checkboxSyncronizationTime.UseCompatibleTextRendering = $True
	$checkboxSyncronizationTime.UseVisualStyleBackColor = $True
	$checkboxSyncronizationTime.add_CheckedChanged($checkboxSyncronizationTime_CheckedChanged)
	#
	# checkboxEnableTPM
	#
	$checkboxEnableTPM.CheckAlign = 'MiddleRight'
	$checkboxEnableTPM.Location = '8, 75'
	$checkboxEnableTPM.Margin = '4, 4, 4, 4'
	$checkboxEnableTPM.Name = 'checkboxEnableTPM'
	$checkboxEnableTPM.Size = '233, 31'
	$checkboxEnableTPM.TabIndex = 6
	$checkboxEnableTPM.Text = 'Enable TPM'
	$checkboxEnableTPM.UseCompatibleTextRendering = $True
	$checkboxEnableTPM.UseVisualStyleBackColor = $True
	$checkboxEnableTPM.add_CheckedChanged($checkboxEnableTPM_CheckedChanged)
	#
	# checkboxEnableAutoCheckPoint
	#
	$checkboxEnableAutoCheckPoint.CheckAlign = 'MiddleRight'
	$checkboxEnableAutoCheckPoint.Location = '8, 36'
	$checkboxEnableAutoCheckPoint.Margin = '4, 4, 4, 4'
	$checkboxEnableAutoCheckPoint.Name = 'checkboxEnableAutoCheckPoint'
	$checkboxEnableAutoCheckPoint.Size = '233, 31'
	$checkboxEnableAutoCheckPoint.TabIndex = 5
	$checkboxEnableAutoCheckPoint.Text = 'Enable Auto CheckPoint'
	$checkboxEnableAutoCheckPoint.UseCompatibleTextRendering = $True
	$checkboxEnableAutoCheckPoint.UseVisualStyleBackColor = $True
	$checkboxEnableAutoCheckPoint.add_CheckedChanged($checkboxEnableAutoCheckPoint_CheckedChanged)
	#
	# buttonDVDISO
	#
	$buttonDVDISO.Location = '14, 79'
	$buttonDVDISO.Margin = '4, 4, 4, 4'
	$buttonDVDISO.Name = 'buttonDVDISO'
	$buttonDVDISO.Size = '100, 30'
	$buttonDVDISO.TabIndex = 8
	$buttonDVDISO.Text = 'DVD ISO'
	$buttonDVDISO.UseCompatibleTextRendering = $True
	$buttonDVDISO.UseVisualStyleBackColor = $True
	$buttonDVDISO.add_Click($buttonDVDISO_Click)
	#
	# DVDPatch
	#
	$DVDPatch.Location = '187, 83'
	$DVDPatch.Margin = '5, 5, 5, 5'
	$DVDPatch.Name = 'DVDPatch'
	$DVDPatch.ReadOnly = $True
	$DVDPatch.Size = '327, 23'
	$DVDPatch.TabIndex = 7
	$DVDPatch.add_TextChanged($DVDPatch_TextChanged)
	#
	# labelNetrworkSwitch
	#
	$labelNetrworkSwitch.AutoSize = $True
	$labelNetrworkSwitch.Location = '14, 33'
	$labelNetrworkSwitch.Margin = '5, 0, 5, 0'
	$labelNetrworkSwitch.Name = 'labelNetrworkSwitch'
	$labelNetrworkSwitch.Size = '107, 21'
	$labelNetrworkSwitch.TabIndex = 4
	$labelNetrworkSwitch.Text = 'Netrwork Switch'
	$labelNetrworkSwitch.UseCompatibleTextRendering = $True
	#
	# combobox1
	#
	$combobox1.DropDownStyle = 'DropDownList'
	$combobox1.FormattingEnabled = $True
	$combobox1.Location = '187, 29'
	$combobox1.Margin = '4, 4, 4, 4'
	$combobox1.Name = 'combobox1'
	$combobox1.Size = '327, 25'
	$combobox1.TabIndex = 3
	$combobox1.add_SelectedIndexChanged($combobox1_SelectedIndexChanged)
	#
	# buttonNext
	#
	$buttonNext.Anchor = 'Bottom, Right'
	$buttonNext.Location = '396, 406'
	$buttonNext.Margin = '4, 4, 4, 4'
	$buttonNext.Name = 'buttonNext'
	$buttonNext.Size = '100, 30'
	$buttonNext.TabIndex = 1
	$buttonNext.Text = '&Next >'
	$buttonNext.UseCompatibleTextRendering = $True
	$buttonNext.UseVisualStyleBackColor = $True
	$buttonNext.add_Click($buttonNext_Click)
	#
	# menustrip1
	#
	$menustrip1.ImageScalingSize = '20, 20'
	[void]$menustrip1.Items.Add($fileToolStripMenuItem)
	[void]$menustrip1.Items.Add($languageToolStripMenuItem)
	[void]$menustrip1.Items.Add($aboutToolStripMenuItem)
	$menustrip1.Location = '0, 0'
	$menustrip1.Name = 'menustrip1'
	$menustrip1.Padding = '8, 3, 0, 3'
	$menustrip1.Size = '728, 30'
	$menustrip1.TabIndex = 5
	$menustrip1.Text = 'menustrip1'
	#
	# openfiledialog1
	#
	$openfiledialog1.FileName = 'openfiledialog1'
	#
	# folderbrowsermoderndialog1
	#
	#
	# fileToolStripMenuItem
	#
	[void]$fileToolStripMenuItem.DropDownItems.Add($exitToolStripMenuItem)
	$fileToolStripMenuItem.Name = 'fileToolStripMenuItem'
	$fileToolStripMenuItem.Size = '44, 24'
	$fileToolStripMenuItem.Text = 'File'
	#
	# exitToolStripMenuItem
	#
	$exitToolStripMenuItem.Name = 'exitToolStripMenuItem'
	$exitToolStripMenuItem.Size = '108, 26'
	$exitToolStripMenuItem.Text = 'Exit'
	$exitToolStripMenuItem.add_Click($exitToolStripMenuItem_Click)
	#
	# aboutToolStripMenuItem
	#
	$aboutToolStripMenuItem.Name = 'aboutToolStripMenuItem'
	$aboutToolStripMenuItem.Size = '62, 24'
	$aboutToolStripMenuItem.Text = 'About'
	$aboutToolStripMenuItem.add_Click($aboutToolStripMenuItem_Click)
	#
	# languageToolStripMenuItem
	#
	[void]$languageToolStripMenuItem.DropDownItems.Add($françaisToolStripMenuItem)
	[void]$languageToolStripMenuItem.DropDownItems.Add($englishToolStripMenuItem)
	[void]$languageToolStripMenuItem.DropDownItems.Add($portugalToolStripMenuItem)
	$languageToolStripMenuItem.Name = 'languageToolStripMenuItem'
	$languageToolStripMenuItem.Size = '86, 24'
	$languageToolStripMenuItem.Text = 'Language'
	#
	# françaisToolStripMenuItem
	#
	$françaisToolStripMenuItem.Name = 'françaisToolStripMenuItem'
	$françaisToolStripMenuItem.Size = '139, 26'
	$françaisToolStripMenuItem.Text = 'Français'
	$françaisToolStripMenuItem.add_Click($françaisToolStripMenuItem_Click)
	#
	# englishToolStripMenuItem
	#
	$englishToolStripMenuItem.Name = 'englishToolStripMenuItem'
	$englishToolStripMenuItem.Size = '139, 26'
	$englishToolStripMenuItem.Text = 'English'
	$englishToolStripMenuItem.add_Click($englishToolStripMenuItem_Click)
	#
	# portugalToolStripMenuItem
	#
	$portugalToolStripMenuItem.Name = 'portugalToolStripMenuItem'
	$portugalToolStripMenuItem.Size = '139, 26'
	$portugalToolStripMenuItem.Text = 'Portugal'
	$portugalToolStripMenuItem.add_Click($portugalToolStripMenuItem_Click)
	$menustrip1.ResumeLayout()
	$groupbox2.ResumeLayout()
	$tabpageStep3.ResumeLayout()
	$cpuupdown.EndInit()
	$numrambox.EndInit()
	$tabpageStep2.ResumeLayout()
	$groupbox1.ResumeLayout()
	$Diffgroupbox.ResumeLayout()
	$tabpageStep1.ResumeLayout()
	$tabcontrolWizard.ResumeLayout()
	$formCreateHyperVMachineV.ResumeLayout()
	#endregion Generated Form Code

	#----------------------------------------------

	#Save the initial state of the form
	$InitialFormWindowState = $formCreateHyperVMachineV.WindowState
	#Init the OnLoad event to correct the initial state of the form
	$formCreateHyperVMachineV.add_Load($Form_StateCorrection_Load)
	#Clean up the control events
	$formCreateHyperVMachineV.add_FormClosed($Form_Cleanup_FormClosed)
	#Show the Form
	return $formCreateHyperVMachineV.ShowDialog()

} #End Function

#Call the form
Show-Create-VM1_psf | Out-Null
