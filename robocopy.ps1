Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Threading

# Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "RoboCopy GUI - PowerShell Script GUI for RoboCopy CLI"
$form.Size = New-Object System.Drawing.Size(540, 365)
$form.StartPosition = "CenterScreen"
$form.Padding = New-Object System.Windows.Forms.Padding(20)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false

# Browse Folders button (source)
$buttonBrowseSourceFolders = New-Object System.Windows.Forms.Button
$buttonBrowseSourceFolders.Text = "Browse Folders"
$buttonBrowseSourceFolders.Location = New-Object System.Drawing.Point(120, 20)
$buttonBrowseSourceFolders.Size = New-Object System.Drawing.Size(100, 20)
$buttonBrowseSourceFolders.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
$form.Controls.Add($buttonBrowseSourceFolders)

# Browse Files button (source)
$buttonBrowseSourceFiles = New-Object System.Windows.Forms.Button
$buttonBrowseSourceFiles.Text = "Browse Files"
$buttonBrowseSourceFiles.Location = New-Object System.Drawing.Point(230, 20)
$buttonBrowseSourceFiles.Size = New-Object System.Drawing.Size(100, 20)
$buttonBrowseSourceFiles.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
$form.Controls.Add($buttonBrowseSourceFiles)

# Remove button (source)
$buttonRemoveSource = New-Object System.Windows.Forms.Button
$buttonRemoveSource.Text = "Remove"
$buttonRemoveSource.Location = New-Object System.Drawing.Point(340, 20)
$buttonRemoveSource.Size = New-Object System.Drawing.Size(80, 20)
$buttonRemoveSource.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
$form.Controls.Add($buttonRemoveSource)

# Label and text box to source items
$labelSource = New-Object System.Windows.Forms.Label
$labelSource.Text = "Source Folders/Files:"
$labelSource.Location = New-Object System.Drawing.Point(10, 50)
$labelSource.Size = New-Object System.Drawing.Size(100, 40)
$labelSource.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
$form.Controls.Add($labelSource)

$listBoxSource = New-Object System.Windows.Forms.ListBox
$listBoxSource.Location = New-Object System.Drawing.Point(120, 50)
$listBoxSource.Size = New-Object System.Drawing.Size(400, 100)
$listBoxSource.SelectionMode = [System.Windows.Forms.SelectionMode]::MultiExtended
$listBoxSource.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($listBoxSource)

$buttonBrowseSourceFolders.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select Source Folders"

    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        if (-not $listBoxSource.Items.Contains($folderBrowser.SelectedPath)) {
            $listBoxSource.Items.Add($folderBrowser.SelectedPath)
        }
    }
})

$buttonBrowseSourceFiles.Add_Click({
    $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $fileDialog.Multiselect = $true
    $fileDialog.Title = "Select Source Files"

    if ($fileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        foreach ($file in $fileDialog.FileNames) {
            if (-not $listBoxSource.Items.Contains($file)) {
                $listBoxSource.Items.Add($file)
            }
        }
    }
})

$buttonRemoveSource.Add_Click({
    $selectedItems = @($listBoxSource.SelectedItems)
    foreach ($item in $selectedItems) {
        $listBoxSource.Items.Remove($item)
    }
})

# Label and text box for destination folder
$labelDestination = New-Object System.Windows.Forms.Label
$labelDestination.Text = "Destination Folder:"
$labelDestination.Location = New-Object System.Drawing.Point(10, 170)
$labelDestination.Size = New-Object System.Drawing.Size(100, 20)
$labelDestination.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
$form.Controls.Add($labelDestination)

$textBoxDestination = New-Object System.Windows.Forms.TextBox
$textBoxDestination.Location = New-Object System.Drawing.Point(120, 170)
$textBoxDestination.Size = New-Object System.Drawing.Size(290, 20)  # Adjusted to fit the browse button
$textBoxDestination.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($textBoxDestination)

# Browse button (destination)
$buttonBrowseDestination = New-Object System.Windows.Forms.Button
$buttonBrowseDestination.Text = "Browse"
$buttonBrowseDestination.Location = New-Object System.Drawing.Point(420, 170)  # Adjusted inward
$buttonBrowseDestination.Size = New-Object System.Drawing.Size(100, 20)
$buttonBrowseDestination.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($buttonBrowseDestination)

$buttonBrowseDestination.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $textBoxDestination.Text = $folderBrowser.SelectedPath
    }
})

# Checkbox for multithreading
$checkBoxMultithreading = New-Object System.Windows.Forms.CheckBox
$checkBoxMultithreading.Text = "Enable Multithreading (Default: ON)"
$checkBoxMultithreading.Location = New-Object System.Drawing.Point(120, 210)  # Adjusted for more space
$checkBoxMultithreading.Size = New-Object System.Drawing.Size(300, 20)
$checkBoxMultithreading.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$checkBoxMultithreading.Checked = $true  # Default to checked
$form.Controls.Add($checkBoxMultithreading)

# Checkbox for buffered I/O
$checkBoxBufferedIO = New-Object System.Windows.Forms.CheckBox
$checkBoxBufferedIO.Text = "Enable Buffered I/O (Default: ON)"
$checkBoxBufferedIO.Location = New-Object System.Drawing.Point(120, 240)  # Adjusted for more space
$checkBoxBufferedIO.Size = New-Object System.Drawing.Size(300, 20)
$checkBoxBufferedIO.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$checkBoxBufferedIO.Checked = $true  # Default to checked
$form.Controls.Add($checkBoxBufferedIO)

# Start button (Start RoboCopy)
$buttonStart = New-Object System.Windows.Forms.Button
$buttonStart.Text = "Start Robocopy"
$buttonStart.Location = New-Object System.Drawing.Point(120, 280)  # Adjusted for more space
$buttonStart.Size = New-Object System.Drawing.Size(100, 30)
$buttonStart.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
$form.Controls.Add($buttonStart)

$global:robocopyProcess = $null

function Invoke-Robocopy {
    param (
        [string[]]$sourceItems,
        [string]$destinationFolder,
        [bool]$useMultithreading,
        [bool]$useBufferedIO
    )

    $startTime = Get-Date
    $logicalProcessorCount = [System.Environment]::ProcessorCount

    foreach ($source in $sourceItems) {
        $sourceName = [System.IO.Path]::GetFileName($source.TrimEnd('\'))
        $newDestination = [System.IO.Path]::Combine($destinationFolder, $sourceName)

        if ((Test-Path $source) -and ((Get-Item $source).PSIsContainer)) {
            $robocopyArgs = @(
                "`"$source`"",
                "`"$newDestination`"",
                "/S",
                "/E"
            )
            if ($useMultithreading) {
                $robocopyArgs += "/MT:$logicalProcessorCount"
            }
            if (-not $useBufferedIO) {
                $robocopyArgs += "/J"
            }

            # Combine all robocopy arguments into a single string
            $robocopyArgsString = $robocopyArgs -join ' '

            # Set console color and title, then run robocopy
            $cmdArgs = @(
                '/c',
                'color 0a',
                '&&',
                'title RoboCopy CLI - Press "Ctrl + Z" or close this window to cancel',
                '&&',
                'robocopy.exe',
                $robocopyArgsString
            )

            $global:robocopyProcess = Start-Process -FilePath "cmd.exe" -ArgumentList $cmdArgs -Wait -PassThru
            $global:robocopyProcess.WaitForExit()
        } else {
            Copy-Item -Path $source -Destination $newDestination -Force
        }
    }

    $endTime = Get-Date
    $duration = $endTime - $startTime
    return $duration
}

$buttonStart.Add_Click({
    $sourceItems = @($listBoxSource.Items)
    $destinationFolder = $textBoxDestination.Text
    $useMultithreading = $checkBoxMultithreading.Checked
    $useBufferedIO = $checkBoxBufferedIO.Checked

    if ($sourceItems.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Please select at least one source folder or file.")
    } elseif (-not (Test-Path $destinationFolder)) {
        [System.Windows.Forms.MessageBox]::Show("Please select a valid destination folder.")
    } else {
        $duration = Invoke-Robocopy -sourceItems $sourceItems -destinationFolder $destinationFolder -useMultithreading $useMultithreading -useBufferedIO $useBufferedIO
        [System.Windows.Forms.MessageBox]::Show("Copy operation completed.`nTime taken: $duration")
    }
})

$form.Show()
[System.Windows.Forms.Application]::Run($form)