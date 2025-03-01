<#
.SYNOPSIS
删除指定目录中大小小于100KB的文档（自动排除脚本自身）

.DESCRIPTION
更新说明：增加对脚本文档自身的排除保护
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$TargetFolder = "."  # 默认当前目录
)

# 获取当前脚本的完整路径
$scriptSelf = $PSCommandPath

# 路径验证
if (-not (Test-Path -Path $TargetFolder -PathType Container)) {
    Write-Host "错误：指定的目录不存在！" -ForegroundColor Red
    exit 1
}

# 设置文档大小阈值（100KB）
$sizeThreshold = 2KB

try {
    # 获取所有符合条件的文档（排除目录和脚本自身）
    $filesToDelete = Get-ChildItem -Path $TargetFolder -File | 
                    Where-Object { 
                        $_.Length -lt $sizeThreshold -and 
                        $_.FullName -ne $scriptSelf  # 关键修改：排除自身
                    }

    # 后续代码保持不变...


    if ($filesToDelete.Count -eq 0) {
        Write-Host "未找到小于100KB的文档" -ForegroundColor Yellow
        exit
    }

    # 显示待删除文档列表
    Write-Host "以下文档将被删除：" -ForegroundColor Cyan
    $filesToDelete | Format-Table Name, @{Label="Size(KB)"; Expression={[math]::Round($_.Length/1KB, 2)}} -AutoSize

    # 用户确认
    $confirmation = Read-Host "是否确认删除以上 ${($filesToDelete.Count)} 个文档？(y/n)"
    if ($confirmation -ne 'y') {
        Write-Host "操作已取消" -ForegroundColor Yellow
        exit
    }

    # 执行删除操作
    $deletedCount = 0
    $filesToDelete | ForEach-Object {
        try {
            Remove-Item $_.FullName -Force -ErrorAction Stop
            Write-Host "已删除：$($_.Name)" -ForegroundColor Green
            $deletedCount++
        }
        catch {
            Write-Host "删除失败 [$($_.Name)]: $_" -ForegroundColor Red
        }
    }

    Write-Host "操作完成，成功删除 ${deletedCount} 个文档" -ForegroundColor Cyan
}
catch {
    Write-Host "发生错误: $_" -ForegroundColor Red
    exit 2
}
