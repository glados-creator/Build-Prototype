$compiler = Resolve-Path ".\tcc\tcc.exe"
$build_dir = ".\build"
$compile_flag = ""
$original_path = Resolve-Path "."

Remove-Item -Recurse -Force $build_dir
$_ = New-Item -ItemType Directory -Path $build_dir
$build_dir = Resolve-Path ".\build" 

$already_build = Get-ChildItem $build_dir
$job = @{}
$to_build = Get-ChildItem ".\src\" | Where-Object {$_ -NotIn $already_build}
$to_build = $to_build | ForEach-Object {
    $path = (Resolve-Path (".\src\"+$_)).Path
    Write-Output $path
}

foreach ($project in $to_build) {
    Write-Output ("building ... " + $project)
    $job[$project] = Start-Job -ScriptBlock {
        param($project ,$build_dir ,$compiler ,$compile_flag)
        Set-Location $project
        $build_dir = (join-path $build_dir (Split-Path $project -Leaf))
        if (-not (Test-Path $build_dir)){$_ = New-Item -ItemType Directory -Path $build_dir}
        .\build.ps1 -config $using:build_dir $using:compiler $using:compile_flag
    } -ArgumentList $project ,$build_dir ,$compiler ,$compile_flag
}

Set-Location ".\build"
foreach ($key in $job.keys) {
    $j = $job[$key]
    $j = Wait-Job -Job $j
    $stdout = $j.ChildJobs[0].Output
    $stderr = $j.ChildJobs[0].Error
    $exitCode = $j.ChildJobs[0].State
    # Process the output here
    # For example, write the output to a log file
    $output = "$($stdout)`n$($stderr)"
    Set-Location (join-path $build_dir (Split-Path $key -Leaf))
    $output | Out-File ".\build_log.log" -Append
    # Print the output to the console
    Write-Output ($key + " output :" + $output)
    # Print the exit code
    Write-Output "Exit code: $exitCode"
    Set-Location ".\..\"
}

Set-Location $original_path