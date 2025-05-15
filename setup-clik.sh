#!/bin/bash

echo "=== Setup Tailwind CSS con PostCSS paso a paso ==="

read -p "Paso 1: Instalar tailwindcss, postcss y autoprefixer (npm install -D tailwindcss postcss autoprefixer). ¿Continuar? (s/n): " res
if [[ $res != "s" ]]; then
  echo "Abortando."
  exit 1
fi

npm install -D tailwindcss postcss autoprefixer
if [ $? -ne 0 ]; then
  echo "❌ Error instalando dependencias."
  exit 1
fi

read -p "Paso 2: Crear archivos de configuración tailwind.config.js y postcss.config.js (npx tailwindcss init -p). ¿Continuar? (s/n): " res
if [[ $res != "s" ]]; then
  echo "Abortando."
  exit 1
fi

npx tailwindcss init -p
if [ $? -ne 0 ]; then
  echo "❌ Error creando archivos de configuración."
  exit 1
fi

echo "Paso 3: Modificar tailwind.config.js..."
cat > tailwind.config.js <<EOL
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Open Sans', 'sans-serif'],
      },
    },
  },
  plugins: [],
}
EOL
echo "✅ Archivo tailwind.config.js creado."

read -p "Paso 4: Crear/modificar src/index.css con directivas Tailwind. ¿Continuar? (s/n): " res
if [[ $res != "s" ]]; then
  echo "Abortando."
  exit 1
fi

mkdir -p src
cat > src/index.css <<EOL
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Fuente personalizada */
@import url('https://fonts.googleapis.com/css2?family=Open+Sans&display=swap');

body {
  font-family: 'Open Sans', sans-serif;
}
EOL
echo "✅ Archivo src/index.css creado."

read -p "Paso 5: Agregar script build_css en package.json. ¿Continuar? (s/n): " res
if [[ $res != "s" ]]; then
  echo "Abortando."
  exit 1
fi

if [ -f package.json ]; then
  if command -v jq >/dev/null 2>&1; then
    tmpfile=$(mktemp)
    jq '.scripts.build_css = "tailwindcss -i ./src/index.css -o ./dist/output.css --watch"' package.json > "$tmpfile" && mv "$tmpfile" package.json
    echo "✅ Script build_css agregado usando jq."
  else
    echo "ℹ️ jq no está instalado. Usando sed como alternativa..."
    sed -i '/"scripts": {/a \    "build_css": "tailwindcss -i ./src/index.css -o ./dist/output.css --watch",' package.json
    echo "✅ Script build_css agregado con sed."
  fi
else
  echo "❌ No se encontró package.json. Ejecuta 'npm init -y' antes de correr este script."
  exit 1
fi

read -p "Paso 6: Ejecutar compilación de Tailwind (npm run build_css). ¿Continuar? (s/n): " res
if [[ $res != "s" ]]; then
  echo "Abortando."
  exit 1
fi

mkdir -p dist
npm run build_css

echo "✅ Proceso finalizado. El archivo dist/output.css está listo para ser enlazado en tu HTML."
