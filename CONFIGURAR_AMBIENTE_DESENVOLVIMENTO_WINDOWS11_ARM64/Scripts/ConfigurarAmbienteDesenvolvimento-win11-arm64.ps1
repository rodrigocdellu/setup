# ------------------------------------------------------------------------------
# SCRIPT DE CONFIGURAÇÃO DE AMBIENTE DE DESENVOLVIMENTO PARA O WINDOWS 11 (ARM64)
#   Desenvolvido por: Rodrigo Corrá Dellu
#   Atualização: 04/07/2026
# ------------------------------------------------------------------------------

# Verifica a decisão do usuário
Read-Host "Pressione <Enter> para iniciar o Setup de Configuração de Ambiente Desenvolvimento para Windows 11 (ARM64)."

# Função auxiliar para registrar os logs e mostrar na tela ao mesmo tempo
function Write-Log {
    param (
        [string]$Message,
        [string]$Type = 'INFO'
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Type] $Message"
    
    Add-Content -Path $LogFile -Value $LogMessage
    
    switch ($Type) {
        'SUCCESS' { Write-Host $LogMessage -ForegroundColor Green }
        'ERROR'   { Write-Host $LogMessage -ForegroundColor Red }
        'WARN'    { Write-Host $LogMessage -ForegroundColor Yellow }
        default   { Write-Host $LogMessage -ForegroundColor Cyan }
    }
}

# 1. Configura o arquivo de log no mesmo diretório do script
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$LogFile = Join-Path $ScriptDir "../Logs/ConfigurarAmbienteDesenvolvimento-win11-arm64.log"

# 2. Inicializa com o arquivo de log limpo
Clear-Content $LogFile -ErrorAction SilentlyContinue
Write-Log "Iniciando a instalações e a configurações do ambiente de desenvolvimento para o Windows 11 (arm64)..."

# 3. Verifica se a execução está no papel de administrador
$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($IsAdmin) {
    Write-Log "O PowerShell está rodando como administrador." 'SUCCESS'
} else {
    Write-Log "O PowerShell precisa estar rodando como administrador." 'ERROR'
    Exit
}

# 4. Verifica se tem conexão com a internet
Write-Log "Verificando conexão com a internet..."

if ((Test-NetConnection -ComputerName "microsoft.com" -Port 443).TcpTestSucceeded) {
    Write-Log "Conexão ativa detectada." 'SUCCESS'
} else {
    Write-Log "Não foi possível estabelecer conexão com a internet. Para executar este script eh necessário ter uma conexão ativa com a internet." 'ERROR'
    Exit
}

# ------------------------------------------------------------------------------
# ETAPA 1: INSTALAÇÃO E CONFIGURAÇÃO DO VS CODE (ARM64)
# ------------------------------------------------------------------------------
Write-Log "--- ETAPA 1: Instalação e Configuração do VS Code para o Windows 11 (arm64) ---"

try {
    if (Get-Command code -ErrorAction SilentlyContinue) {
        # Obtém a versão do VS Code instalado
        $VSCodeVersion = & code --version

        Write-Log "O VS Code já está instalado. Versão: $VSCodeVersion. Pulando a etapa de instalação..." 'SUCCESS'
    } else {
        # Define parâmetros de download e instalação
        $VSCodeUrl = "https://update.code.visualstudio.com/latest/win32-arm64/stable"
        $VSCodeInstaller = "$env:TEMP\VSCodeSetup-arm64.exe"
        
        Write-Log "Baixando o instalador do VS Code..."
        Invoke-RestMethod -Uri $VSCodeUrl -OutFile $VSCodeInstaller
        
        # Define parâmetros de instalação silenciosa
        $Arguments = "/VERYSILENT /NORESTART /MERGETASKS=!runcode,addcontextmenufiles,addcontextmenufolders,addtopath"
        
        Write-Log "Instalando o VS Code de forma silenciosa..."
        Start-Process -FilePath $VSCodeInstaller -ArgumentList $Arguments -Wait -NoNewWindow
        Remove-Item -Path $VSCodeInstaller -Force
        
        # Atualiza o PATH do processo atual pegando direto da Máquina e Usuário
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
        
        # Obtém a versão do VS Code instalado
        $VSCodeVersion = & code --version

        Write-Log "VS Code instalado com sucesso. Versão: $VSCodeVersion" 'SUCCESS'
        
        Write-Log "Instalando extensões padrão para o VS Code..."
        & code --install-extension MS-CEINTL.vscode-language-pack-pt-BR > $null
        & code --install-extension streetsidesoftware.code-spell-checker > $null
        & code --install-extension streetsidesoftware.code-spell-checker-portuguese-brazilian > $null
        Write-Log "Extensões padrão para o VS Code instaladas com sucesso." 'SUCCESS'
        
        Write-Log "Aplicando configurações do VS Code..."
        
        # Define o caminho do settings.json
        $VSCodeSettingsPath = "$env:APPDATA\Code\User\settings.json"

        # Lê o conteúdo atual (se existir)
        if (Test-Path $VSCodeSettingsPath) {
            $CurrentSettings = Get-Content $VSCodeSettingsPath -Raw | ConvertFrom-Json
        } else {
            $CurrentSettings = @{}
        }
    
        # Adiciona ou atualiza as configurações desejadas
        $CurrentSettings."cSpell.language" = "pt-BR"
        $CurrentSettings."cSpell.enableFiletypes" = @("markdown","plaintext")
    
        # Salva de volta em JSON
        $CurrentSettings | ConvertTo-Json -Depth 3 | Set-Content -Path $VSCodeSettingsPath -Encoding UTF8

        Write-Log "Configurações do VS Code aplicadas com sucesso." 'SUCCESS'
    }
}
catch {
    Write-Log "Erro durante a instalação e configuração do VS Code para o Windows 11 (arm64): $_" 'ERROR'
}

# --------------------------------------------------------------------------
# ETAPA 2: INSTALAÇÃO E CONFIGURAÇÃO DO SDK .NET 10 LTS (ARM64)
# --------------------------------------------------------------------------
Write-Log "--- ETAPA 2: Instalação e Configuração do SDK .NET 10 LTS para o Windows 11 (arm64) ---"

try {
    if (Get-Command dotnet -ErrorAction SilentlyContinue) {
        # Obtém a versão do SDK .NET 10 LTS instalado
        $DotNetVersion = & dotnet --version

        Write-Log "O SDK .NET 10 LTS já está instalado. Versão: $VSCodeVersion. Pulando a etapa de instalação..." 'SUCCESS'
    } else {
        Write-Log "Instalando o SDK .NET 10 LTS..."
        & winget install --id Microsoft.DotNet.SDK.10 --architecture arm64 --source winget --accept-source-agreements --accept-package-agreements > $null

        # Atualiza o PATH do processo atual pegando direto da Máquina e Usuário
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
        
        # Obtém a versão do SDK .NET 10 LTS instalado
        $DotNetVersion = & dotnet --version

        Write-Log "SDK .NET 10 LTS instalado com sucesso. Versão: $DotNetVersion" 'SUCCESS'
    }
}
catch {
    Write-Log "Erro durante a instalação e configuração do SDK .NET 10 LTS para o Windows 11 (arm64): $_" 'ERROR'
}

# ------------------------------------------------------------------------------
# ETAPA 3: INSTALAÇÃO E CONFIGURAÇÃO DO NODE.JS LTS VIA NVM (ARM64)
# ------------------------------------------------------------------------------
Write-Log "--- ETAPA 3: Instalação e Configuração do Node.js LTS via NVM para o Windows 11 (arm64) ---"

try {
    if (Get-Command node -ErrorAction SilentlyContinue) {
        # Obtém a versão do Node.js instalado
        $NodeJSVersion = & node --version

        Write-Log "O Node.js já está instalado. Versão: $NodeJSVersion. Pulando a etapa de instalação..." 'SUCCESS'
    } else {
        Write-Log "Instalando o NVM..."
        & winget install -e --id CoreyButler.NVMforWindows --accept-source-agreements --accept-package-agreements > $null
        
        # Atualiza o PATH do processo atual pegando direto da Máquina e Usuário
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
        
        # Busca especificamente as variáveis criadas pelo instalador do NVM no Registro do Windows
        $NvmHomeRegistry = [System.Environment]::GetEnvironmentVariable("NVM_HOME", "Machine")
        $NvmSymlinkRegistry = [System.Environment]::GetEnvironmentVariable("NVM_SYMLINK", "Machine")

        # Se encontrou no registro, força a aplicação na sessão atual do PowerShell
        if ($NvmHomeRegistry) { 
            $env:NVM_HOME = $NvmHomeRegistry
            $env:Path = "$env:Path;$NvmHomeRegistry"
        }
        if ($NvmSymlinkRegistry) { 
            $env:NVM_SYMLINK = $NvmSymlinkRegistry
            $env:Path = "$env:Path;$NvmSymlinkRegistry"
        }
        
        # Testa se o comando responde. Se falhar, tenta chamar pelo caminho absoluto padrão
        if (-not (Get-Command nvm -ErrorAction SilentlyContinue)) {
            if (Test-Path "C:\AppData\Roaming\nvm") { $env:Path = "$env:Path;C:\AppData\Roaming\nvm" }
            if (Test-Path "C:\Program Files\nvm") { $env:Path = "$env:Path;C:\Program Files\nvm" }
        }

        # Obtém a versão do NVM instalado
        $NVMVersion = & nvm version

        Write-Log "NVM instalado com sucesso. Versão: $NVMVersion" 'SUCCESS'
        
        Write-Log "Configurando a prioridade do NVM para binários arm64..."
        & nvm arch arm64 > $null
        
        Write-Log "Instalando e ativando o Node.js LTS arm64 via NVM..."
        & nvm install lts arm64 > $null
        & nvm use lts arm64 > $null

        # Obtém a versão do Node.js instalado
        $NodeJSVersion = & node --version

        Write-Log "Node.js instalado e ativado com sucesso. Versão: $NodeJSVersion" 'SUCCESS'
    }
}
catch {
    Write-Log "Erro durante a instalação e configuração do Node.js/NVM para o Windows 11 (arm64): $_" 'ERROR'
}

# ------------------------------------------------------------------------------
# ETAPA 4: INSTALAÇÃO E CONFIGURAÇÃO DO PYTHON VIA UV (ARM64)
# ------------------------------------------------------------------------------
Write-Log "--- ETAPA 4: Instalação e Configuração do Python via UV para o Windows 11 (arm64) ---"

try {
    # Define parâmetros de verificação de instalação
    $PythonCmd = Get-Command python -ErrorAction SilentlyContinue
    $PythonVersion = if ($PythonCmd) { (& python --version 2>$null) } else { $null }

    if ($PythonVersion -and $PythonVersion -notmatch "Microsoft Store") {
        # Obtém a versão do Python instalado
        $PythonVersion = (& python --version 2>$null)

        Write-Log "O Python já está instalado. Versão: $PythonVersion. Pulando a etapa de instalação..." 'SUCCESS'
    } else {
        Write-Log "Instalando o UV..."
        powershell -ExecutionPolicy Bypass -Command "irm https://astral.sh/uv/install.ps1 | iex" > $null

        # Atualiza o PATH do processo atual pegando direto da Máquina e Usuário
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

        # Obtém a versão do UV instalado
        $UVVersion = & uv --version

        Write-Log "UV instalado com sucesso. Versão: $UVVersion" 'SUCCESS'
        
        Write-Log "Instalando e configurando o Python 3.14 arm64 via UV..."
        & uv python install cpython-3.14-windows-aarch64 --default --preview-features python-install-default 2>$null
        & uv python pin cpython-3.14-windows-aarch64 --global > $null

        # Obtém a versão do Python instalado
        $PythonVersion = (& python --version 2>$null)

        Write-Log "Python instalado e configurado globalmente com sucesso. Versão: $PythonVersion" 'SUCCESS'
    }
}
catch {
    Write-Log "Erro durante a instalação e configuração do Python/UV para o Windows 11 (arm64): $_" 'ERROR'
}

# ------------------------------------------------------------------------------
# ETAPA 5: INSTALAÇÃO E CONFIGURAÇÃO DO GIT (ARM64)
# ------------------------------------------------------------------------------
Write-Log "--- ETAPA 5: Instalação e Configuração do Git para o Windows 11 (arm64) ---"

try {
    if (Get-Command git -ErrorAction SilentlyContinue) {
        # Obtém a versão do Git instalado
        $GitVersion = & git --version

        Write-Log "O Git já está instalado. Versão: $GitVersion. Pulando a etapa de instalação..." 'SUCCESS'
    } else {
        Write-Log "Instalando o Git..."
        & winget install --id Git.Git -e --source winget --accept-source-agreements --accept-package-agreements > $null

        # Atualiza o PATH do processo atual pegando direto da Máquina e Usuário
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

        # Obtém a versão do Git instalado
        $GitVersion = & git --version

        Write-Log "Git instalado com sucesso. Versão: $GitVersion" 'SUCCESS'
        
        Write-Log "Aplicando configurações do Git..."
        & git config --global user.name 'rodrigocdellu'
        & git config --global user.email 'rodrigocdellu.trabalho@outlook.com'
        & git config --global core.editor 'code --wait'
        & git config --global diff.tool vscode
        & git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
        & git config --global difftool.prompt false
        & git config --global merge.tool vscode
        & git config --global mergetool.vscode.cmd 'code --wait --merge $LOCAL $REMOTE $BASE $MERGED'
        & git config --global mergetool.vscode.use3WayMerge true
        Write-Log "Configurações do Git aplicadas com sucesso." 'SUCCESS'
    }
}
catch {
    Write-Log "Erro durante a instalação e configuração do Git para o Windows 11 (arm64): $_" 'ERROR'
}

# 5. Finaliza a execução do script
Write-Log "Instalações e configurações finalizadas! O arquivo de log completo está disponível em: $LogFile" 'SUCCESS'

# 6. Pergunta se o usuário deseja abrir o Visual Studio Installer
$ResultVisualStudio = Read-Host "Deseja abrir o Visual Studio Installer agora? (S/N)"

if ($ResultVisualStudio -match '^[Ss]$') {
    Start-Process "$ScriptDir/../Ferramentas/VisualStudioSetup-win11.exe"
    Write-Log "Abrindo o Visual Studio Installer..."
} else {
    Write-Log "O Visual Studio Installer não será aberto."
}

# 7. Pergunta se o usuário deseja abrir o Unity Hub Setup
$ResultUnityHub = Read-Host "Deseja abrir o Unity Hub Setup agora? (S/N)"

if ($ResultUnityHub -match '^[Ss]$') {
    Start-Process "$ScriptDir/../Ferramentas/UnityHubSetup-win11-arm64.exe"
    Write-Log "Abrindo o Unity Hub Setup..."
} else {
    Write-Log "O Unity Hub Setup não será aberto."
}

# 8. Pergunta se o usuário deseja abrir o GitHub
$ResultGitHub = Read-Host "Deseja abrir o GitHub de Rodrigo Corrá Dellu agora? (S/N)"

if ($ResultGitHub -match '^[Ss]$') {
    Start-Process "https://github.com/rodrigocdellu"
    Write-Log "Abrindo o GitHub de Rodrigo Corrá Dellu..."
} else {
    Write-Log "O GitHub não será aberto."
}

# 9. Verifica a decisão do usuário
Read-Host "Pressione <Enter> para finalizar o Setup de Configuração de Ambiente Desenvolvimento para Windows 11 (ARM64)."

Stop-Process -Id $PID

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
