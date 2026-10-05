@echo off
title ISTE SECURE - Iniciando...
color 0B

echo.
echo  ================================================================
echo   ISTE SECURE ^| Sistema de Gestion de Incidentes de Seguridad
echo  ================================================================
echo.
echo  [1/3] Iniciando servidor Laravel (PHP Artisan)...
start "ISTE SECURE - PHP Server" cmd /k "cd /d "%~dp0" && php artisan serve --port=8000"

timeout /t 2 /nobreak >nul

echo  [2/3] Iniciando servidor de assets (Vite + Tailwind)...
start "ISTE SECURE - Vite Assets" cmd /k "cd /d "%~dp0" && npm run dev"

timeout /t 3 /nobreak >nul

echo  [3/3] Abriendo ISTE SECURE en el navegador...
start "" "http://localhost:8000"

echo.
echo  ================================================================
echo   OK  ISTE SECURE corriendo en: http://localhost:8000
echo  ================================================================
echo.
echo  Para detener los servidores, cierra las ventanas de terminal.
echo.
pause
