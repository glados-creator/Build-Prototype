if (-not (Test-Path variable:\compiler)){
    Write-Output "compiler variable not set by build_auto"
    if (-not (Test-Path ( ".\..\..\build\" + (Split-Path (Get-Item ".") -Leaf)))){$_ = New-Item -ItemType Directory -Path ( ".\..\..\build\" + (Split-Path (Get-Item ".") -Leaf))}
    $build_dir = Resolve-Path ( ".\..\..\build\" + (Split-Path (Get-Item ".") -Leaf))
    $compiler = Resolve-Path ".\..\..\tcc\tcc.exe"
    $compile_flag = ""
}

$argList = "-o $build_dir " + (Get-ChildItem -Path . -Recurse -File -Include "*.c","*.h") + "$compile_flag"
$process = Start-Process -FilePath $compiler -ArgumentList $argList -Wait