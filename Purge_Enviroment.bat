@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

SET "DiscordCache=%USERPROFILE%\AppData\Roaming\discord"

ECHO =========================================
ECHO Verificando tamanho da pasta Discord...
ECHO =========================================

IF EXIST "%DiscordCache%" (
    ECHO Pasta encontrada: "%DiscordCache%"

    SET "DSIZE="

    REM Procurar a linha que contém o total de arquivos e o tamanho acumulado
    FOR /F "tokens=3" %%A IN ('DIR /S /-C "%DiscordCache%" ^| FINDSTR /I "Arquivo(s)"') DO (
        SET "DSIZE=%%A"
    )

    REM Remover pontos de milhar (ex: 1.234.567 => 1234567)
    SET "DSIZE=!DSIZE:.=!"

    IF "!DSIZE!"=="" (
        ECHO [ERRO] Falha ao obter tamanho da pasta. DSIZE vazia.
    ) ELSE (
        ECHO Tamanho total da pasta Discord: !DSIZE! bytes
    )
) ELSE (
    ECHO Pasta do Discord nao encontrada em "%DiscordCache%"
)

ENDLOCAL
