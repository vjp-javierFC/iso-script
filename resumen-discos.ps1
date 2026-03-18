<#
.SYNOPSIS
Muestra un resumen del uso de discos del sistema.

.DESCRIPTION
Este script obtiene información de los discos del sistema mediante Get-PSDrive
y muestra el espacio usado, libre y total en formato tabla, expresado en GB.

.PARAMETER None
Este script no requiere parámetros.

.EXAMPLE
.\resumen-discos.ps1

Muestra el resumen de discos en formato tabla.

.EXAMPLE
Get-Help .\resumen-discos.ps1 -Full

Muestra la documentación completa del script.

.NOTES
Autor: Javier Fernández
Repositorio: iso-scripts
#>

Write-Host "=== Resumen de discos ===" -ForegroundColor Cyan

Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    [PSCustomObject]@{
        Nombre      = $_.Name
        "Usado (GB)" = [math]::Round(($_.Used / 1GB), 2)
        "Libre (GB)" = [math]::Round(($_.Free / 1GB), 2)
        "Total (GB)" = [math]::Round((($_.Used + $_.Free) / 1GB), 2)
    }
} | Format-Table -AutoSize

Write-Host "==========================" -ForegroundColor Green