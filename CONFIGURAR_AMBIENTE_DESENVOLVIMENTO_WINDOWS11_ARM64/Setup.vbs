Option Explicit

' 1. Declara as variáveis necessárias
Dim Shell, ScriptPath, PowerShellArgs

' 2. Defini o path do script de setup
ScriptPath = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName) & _
             "\Scripts\ConfigurarAmbienteDesenvolvimento-win11-arm64.ps1"

' 3. Defini os argumentos para a execução do script de setup
PowerShellArgs = "-NoProfile -ExecutionPolicy Bypass -NoExit -File """ & ScriptPath & """"

' 4. Cria uma instância do Shell
Set Shell = CreateObject("Shell.Application")

' 5 Executa o script de setup via Shell sem janela
Shell.ShellExecute "powershell.exe", PowerShellArgs, "", "runas", 3
