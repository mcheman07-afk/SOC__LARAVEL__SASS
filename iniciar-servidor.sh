#!/usr/bin/env bash
# ============================================================
#  ISTE SECURE - Script de arranque (Linux / macOS)
#  Levanta el servidor sin revisar codigo manualmente.
#  Uso: chmod +x iniciar-servidor.sh && ./iniciar-servidor.sh
# ============================================================
set -e
cd "$(dirname "$0")"

echo "[1/6] Verificando PHP..."
if ! command -v php >/dev/null 2>&1; then
  echo "ERROR: PHP no esta instalado o no esta en el PATH."
  exit 1
fi
php --version | head -n 1

echo "[2/6] Verificando dependencias Composer..."
if [ ! -f "vendor/autoload.php" ]; then
  echo "Instalando dependencias PHP..."
  composer install --no-interaction
else
  echo "Dependencias PHP OK."
fi

echo "[3/6] Verificando archivo .env..."
if [ ! -f ".env" ]; then
  echo "Creando .env desde .env.example..."
  cp .env.example .env
  php artisan key:generate --ansi
fi

echo "[4/6] Migrando base de datos..."
php artisan migrate --force --ansi

echo "[5/6] Verificando assets frontend..."
rm -f public/hot
if [ ! -d "node_modules" ]; then
  echo "Instalando dependencias Node..."
  npm install
fi
if [ ! -f "public/build/manifest.json" ]; then
  echo "Compilando assets con Vite..."
  npm run build
fi

echo "[6/6] Limpiando cache de vistas y config..."
php artisan view:clear --ansi
php artisan config:clear --ansi

echo ""
echo "============================================================"
echo " ISTE SECURE listo: http://127.0.0.1:8000"
echo " Presiona Ctrl+C para detener el servidor."
echo "============================================================"
php artisan serve --host=127.0.0.1 --port=8000
