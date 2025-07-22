@echo off
setlocal

echo Definindo variaveis...
SET "RUBY_VERSION=3.3.3-1"
SET "RUBY_INSTALLER_URL=https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-%RUBY_VERSION%/rubyinstaller-devkit-%RUBY_VERSION%-x64.exe"
SET "DOWNLOAD_PATH=%USERPROFILE%\AppData\Local\Temp\rubyinstaller.exe"

echo.
echo Baixando o instalador do Ruby...
powershell -Command "(new-object System.Net.WebClient).DownloadFile('%RUBY_INSTALLER_URL%', '%DOWNLOAD_PATH%')"

:: Verifica se o download foi bem-sucedido
IF NOT EXIST "%DOWNLOAD_PATH%" (
    echo.
    echo ERRO: Falha ao baixar o arquivo de instalacao.
    echo Verifique sua conexao com a internet ou a URL do instalador.
    pause
    goto :eof
)
:: Executa a instalacao de forma completamente oculta
start /wait "" "%DOWNLOAD_PATH%" /VERYSILENT /SUPPRESSMSGBOXES /TASKS="addtosdk"

echo Preparando para limpar o arquivo de instalacao...

:: Tentativa de exclusao com re-tentativas
SET "RETRY_COUNT=0"
SET "MAX_RETRIES=5"
SET "RETRY_DELAY=2" :: Atraso entre as tentativas em segundos

:TRY_DELETE
IF %RETRY_COUNT% GEQ %MAX_RETRIES% (
    echo.
    echo ATENCAO: Nao foi possivel remover o arquivo de instalacao apos %MAX_RETRIES% tentativas.
    echo Por favor, remova-o manualmente: "%DOWNLOAD_PATH%"
    goto :END_DELETE_ATTEMPT
)

IF EXIST "%DOWNLOAD_PATH%" (
    echo Tentando remover: %DOWNLOAD_PATH% "Tentativa %RETRY_COUNT% de %MAX_RETRIES%"
    del "%DOWNLOAD_PATH%"
    IF EXIST "%DOWNLOAD_PATH%" (
        SET /A RETRY_COUNT+=1
        echo Arquivo ainda em uso. Aguardando %RETRY_DELAY% segundos e tentando novamente...
        timeout /t %RETRY_DELAY% /nobreak >nul
        goto :TRY_DELETE
    ) ELSE (
        echo Arquivo de instalacao removido com sucesso.
    )
)

:END_DELETE_ATTEMPT

echo.
echo =============================================================
echo  Instalacao do Ruby concluida com sucesso!
echo  IMPORTANTE: Voce precisa abrir um NOVO terminal (CMD ou PowerShell)
echo  para que as alteracoes no PATH do sistema tenham efeito.
echo  Para verificar a instalacao, abra um novo terminal e digite: ruby -v
echo =============================================================
echo.

endlocal
pause