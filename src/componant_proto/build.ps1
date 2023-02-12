Write-Output "echo test proto"
if (-not (Test-Path variable:\compiler)){
    Write-Output "compiler variable not set by build_auto"
    if (-not (Test-Path ( ".\..\..\build\" + (Split-Path (Get-Item ".") -Leaf)))){$_ = New-Item -ItemType Directory -Path ( ".\..\..\build\" + (Split-Path (Get-Item ".") -Leaf))}
    $build_dir = Resolve-Path ( ".\..\..\build\" + (Split-Path (Get-Item ".") -Leaf))
    $compiler = Resolve-Path ".\..\..\tcc\tcc.exe"
    $compile_flag = ""
}
$org_dir = Resolve-Path "."

Write-Output $compiler
Write-Output $build_dir
Write-Output "compiler arg : "
Write-Output ((Get-ChildItem -Path . -Recurse -File -Include "*.c","*.h") -join + "$compile_flag")

$argList = ( (Get-ChildItem -Path . -Recurse -File -Include "*.c","*.h") -join + "$compile_flag")
$_ = Start-Process -FilePath $compiler -ArgumentList $argList -PassThru -NoNewWindow -Wait
# $_ = Set-Location $build_dir
Write-Output "build exe result"
Get-ChildItem -Filter *.exe | ForEach {
    $_t = Start-Process -FilePath (Resolve-Path $_.Name) -PassThru -NoNewWindow -Wait
}
$_ = Set-Location $org_dir