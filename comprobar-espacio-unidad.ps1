<#
.SYNOPSIS
Comprueba el espacio total, libre y ocupado de una unidad en GB.

.DESCRIPTION
Este script obtiene información sobre el espacio de disco de una unidad especificada
utilizando el cmdlet Get-PSDrive. Muestra el espacio total, libre y ocupado en GB,
redondeado a dos decimales.

Si el espacio ocupado supera el 90% o el espacio libre es inferior a 2 GB,
se muestra una advertencia con fondo rojo.

.PARAMETER Unidad
Letra de la unidad que se desea comprobar (por ejemplo: C, D, E).

.EXAMPLE
.\comprobar-espacio-unidad.ps1 -Unidad C

Muestra la información de espacio del disco C.

.NOTES
Autor: Javier Fernández
Fecha: 2026-03-16
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Unidad
)

try {
    # Obtener información de la unidad
    $drive = Get-PSDrive -Name $Unidad -ErrorAction Stop

    # Espacio en bytes
    $FreeSpaceBytes = $drive.Free
    $UsedSpaceBytes = $drive.Used
    $TotalSpaceBytes = $FreeSpaceBytes + $UsedSpaceBytes

    # Convertir a GB
    $FreeSpaceGB = [Math]::Round($FreeSpaceBytes / 1GB, 2)
    $UsedSpaceGB = [Math]::Round($UsedSpaceBytes / 1GB, 2)
    $TotalSpaceGB = [Math]::Round($TotalSpaceBytes / 1GB, 2)

    # Calcular porcentaje ocupado
    $UsedPercent = [Math]::Round(($UsedSpaceBytes / $TotalSpaceBytes) * 100, 2)

    # Mostrar resultados
    Write-Host "Unidad: $Unidad"
    Write-Host "Espacio total: $TotalSpaceGB GB"
    Write-Host "Espacio usado: $UsedSpaceGB GB ($UsedPercent%)"
    Write-Host "Espacio libre: $FreeSpaceGB GB"

    # Comprobación de alertas
    if ($UsedPercent -gt 90 -or $FreeSpaceGB -lt 2) {
        Write-Host "⚠ ADVERTENCIA: Espacio crítico en la unidad $Unidad" -BackgroundColor Red -ForegroundColor White
    }

}
catch {
    Write-Host "Error: No se pudo acceder a la unidad $Unidad" -ForegroundColor Red
}
