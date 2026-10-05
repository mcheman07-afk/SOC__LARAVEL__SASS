# Despliegue a hosting — ISTE SECURE

## 1. Archivos a subir
Subir todo el proyecto EXCEPTO:
- `node_modules/`
- `.git/` (si existiera)
- `.env` local
- `storage/logs/*`, `storage/framework/views/*`, `storage/framework/cache/*`
- `iniciar-servidor.bat` / `iniciar-servidor.sh` (solo para desarrollo local)
- `server.log` y temporales

> En hosting compartido con cPanel, el `DocumentRoot` debe apuntar a `public/`.
> Si no puedes cambiarlo, sube el proyecto fuera de `public_html` y mueve el
> contenido de `public/` a `public_html`, ajustando las rutas en `index.php`.

## 2. Configurar entorno en el servidor
1. Copiar `.env.production` como `.env` en el servidor.
2. Completar `APP_URL` con el dominio real (https), `APP_KEY` y datos MySQL.
3. Generar clave si está vacía: `php artisan key:generate --force`

## 3. Comandos en el servidor (en este orden)
```bash
composer install --no-dev --optimize-autoloader
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

Los assets ya van compilados en `public/build/`, no es necesario `npm` en el servidor.

## 4. Verificación post-despliegue
- [ ] La web carga por HTTPS sin errores 500
- [ ] `APP_DEBUG=false` (un error 404/500 NO muestra traza ni versión)
- [ ] Cabeceras presentes: `X-Frame-Options: DENY`, `Content-Security-Policy`, `X-Content-Type-Options: nosniff`
- [ ] Crear un incidente de prueba y resolverlo
- [ ] Probar escaneo normal y escaneo ransomware + reparación
- [ ] Revisar `storage/logs/laravel.log` sin errores nuevos

## 5. Notas de seguridad aplicadas
- Cabeceras de seguridad globales (`SecurityHeaders`), CSP y HSTS en HTTPS.
- Rate limiting en mutaciones: incidentes (20/min), escaneo (30/min),
  reparación (15/min), conversión (20/min) y resolución (30/min).
- Validación perimetral en todos los endpoints POST/PATCH.
- Cookies de sesión `Secure + HttpOnly + SameSite=lax` y sesión cifrada en producción.
- HTTPS forzado cuando `APP_ENV=production`.
- Sin versión de Laravel expuesta en el footer.
- `APP_DEBUG=false` obligatorio: las 4 advertencias de `composer audit`
  (framework 11.x) quedan mitigadas porque usan página de debug (apagada)
  y funciones no utilizadas (signed URLs, regla email). Plan recomendado:
  migrar a Laravel 12 cuando sea posible.
