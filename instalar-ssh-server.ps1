#Requires -RunAsAdministrator
<#
.SYNOPSIS
Instala y configura el servidor SSH en Windows o Linux.

.DESCRIPTION
Este script instala, configura y habilita el servicio OpenSSH Server.
En sistemas Windows, sigue los pasos habituales de instalación mediante capacidades opcionales.
En sistemas Linux (basados en apt), instala el paquete openssh-server.

Además:
- Comprueba si el servidor SSH ya está instalado.
- Verifica si el servicio está en ejecución.
- Evita reinstalaciones innecesarias.

.PARAMETER None
Este script no requiere parámetros.

.EXAMPLE
.\instalar-ssh-server.ps1

Instala y configura el servidor SSH en el sistema.

.NOTES
Autor: Javier Fernández
Repositorio: iso-scripts
Requiere privilegios de administrador.
#>

Write-Host "=== Instalación de servidor SSH ===" -ForegroundColor Cyan

if ($IsLinux) {
    Write-Host "Sistema Linux detectado"

    $sshInstalled = dpkg -l | Select-String "openssh-server"

    if ($sshInstalled) {
        Write-Host "OpenSSH Server ya está instalado." -ForegroundColor Yellow
    } else {
        Write-Host "Instalando OpenSSH Server..."
        sudo apt update
        sudo apt install -y openssh-server
    }

    Write-Host "Habilitando servicio SSH..."
    sudo systemctl enable ssh
    sudo systemctl start ssh

    Write-Host "Estado del servicio:"
    sudo systemctl status ssh --no-pager
}
else {
    Write-Host "Sistema Windows detectado"

    $capability = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'

    if ($capability.State -eq "Installed") {
        Write-Host "OpenSSH Server ya está instalado." -ForegroundColor Yellow
    } else {
        Write-Host "Instalando OpenSSH Server..."
        Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    }

    $service = Get-Service -Name sshd -ErrorAction SilentlyContinue

    if ($service -and $service.Status -eq "Running") {
        Write-Host "El servicio SSH ya está en ejecución." -ForegroundColor Yellow
    } else {
        Write-Host "Configurando servicio SSH..."
        Set-Service -Name sshd -StartupType Automatic
        Start-Service sshd
    }

    Write-Host "Configurando regla de firewall..."
    if (-not (Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue)) {
        New-NetFirewallRule -Name "OpenSSH-Server-In-TCP" `
            -DisplayName "OpenSSH Server (sshd)" `
            -Enabled True `
            -Direction Inbound `
            -Protocol TCP `
            -Action Allow `
            -LocalPort 22
    }

    Write-Host "Estado del servicio:"
    Get-Service sshd
}

Write-Host "=== Proceso finalizado ===" -ForegroundColor Green