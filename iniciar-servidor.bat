@echo off
REM ============================================================
REM  ISTE SECURE - Script de arranque (Windows)
REM  Levanta el servidor sin revisar codigo manualmente.
REM  Uso: doble clic o ejecutar "iniciar-servidor.bat"
REM ============================================================
cd /d "%~dp0"

echo [1/6] Verificando PHP...
php --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: PHP no esta instalado o no esta en el PATH.
    echo Instalalo desde https://www.php.net/downloads o usa Laravel Herd / XAMPP.
    pause
    exit /b 1
)

echo [2/6] Verificando dependencias Composer...
if not exist "vendor\autoload.php" (
    echo Instalando dependencias PHP...
    composer install --no-interaction
    if errorlevel 1 (
        echo ERROR: fallo "composer install".
        pause
        exit /b 1
    )
) else (
    echo Dependencias PHP OK.
)

echo [3/6] Verificando archivo .env...
if not exist ".env" (
    echo Creando .env desde .env.example...
    copy ".env.example" ".env" >nul
    php artisan key:generate --ansi
)
php artisan key:generate --show >nul 2>&1

echo [4/6] Migrando base de datos...
php artisan migrate --force --ansi

echo [5/6] Verificando assets frontend...
if exist "public\hot" del /f /q "public\hot" >nul 2>&1
if not exist "node_modules" (
    echo Instalando dependencias Node...
    call npm install
)
if not exist "public\build\manifest.json" (
    echo Compilando assets con Vite...
    call npm run build
)

echo [6/6] Limpiando cache de vistas y config...
php artisan view:clear --ansi
php artisan config:clear --ansi

echo.
echo ============================================================
echo  ISTE SECURE listo: http://127.0.0.1:8000
echo  Presiona Ctrl+C para detener el servidor.
echo ============================================================
php artisan serve --host=127.0.0.1 --port=8000
