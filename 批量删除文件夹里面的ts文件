# 批量删除TS文件的脚本
param(
    [Parameter(Mandatory=$true)]
    [string]$Path = $(Get-Location),

    [switch]$Recurse,

    [string[]]$ExcludeFolders = @(),

    [switch]$WhatIf,

    [switch]$DryRun
)

function Delete-TSFiles {
    param(
        [string]$SearchPath,
        [switch]$ShouldRecurse,
        [string[]]$ExcludedDirectories
    )

    # 获取所有TS文件
    $files = Get-ChildItem -Path $SearchPath -Filter *.ts -Recurse:$ShouldRecurse -ErrorAction SilentlyContinue

    # 排除指定目录
    $files = $files | Where-Object {
        $currentDir = Split-Path $_.FullName -Parent
        return $ExcludedDirectories -notcontains $currentDir
    }

    if ($files.Count -eq 0) {
        Write-Host "未找到需要删除的TS文件"
        return
    }

    # 显示待删除文件列表
    if (-not $DryRun -and -not $WhatIf) {
        Write-Host "即将删除以下文件："
        $files.FullName | Out-String | Write-Host
        $confirmation = Read-Host "确认删除？(Y/N)"
        if ($confirmation -ne 'Y') {
            Write-Host "操作已取消"
            return
        }
    }

    # 执行删除操作
    $deletedCount = 0
    $errorOccurred = $false
    foreach ($file in $files) {
        try {
            Remove-Item -Path $file.FullName -Force -ErrorAction Stop
            $deletedCount++
        } catch {
            Write-Error "无法删除文件 $($file.FullName): $_"
            $errorOccurred = $true
        }
    }

    if ($deletedCount -gt 0) {
        Write-Host "成功删除 $deletedCount 个TS文件"
    }
    if ($errorOccurred) {
        Write-Warning "部分文件删除失败，请检查文件权限"
    }
}

# 主程序执行
try {
    Delete-TSFiles -SearchPath $Path -ShouldRecurse $Recurse -ExcludedDirectories $ExcludeFolders
} catch {
    Write-Error "发生错误：$_"
    exit 1
}
