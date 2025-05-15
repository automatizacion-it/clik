#!/bin/bash

echo "=== Configuración de Clik - Libreta de Notas ==="

read -p "Paso 1: Crear carpeta del proyecto y entrar en ella (clik). ¿Continuar? (s/n): " res
if [[ $res != "s" ]]; then echo "Abortado."; exit 1; fi

mkdir -p clik && cd clik
npm init -y

read -p "Paso 2: Instalar Tailwind CSS, PostCSS y Autoprefixer. ¿Continuar? (s/n): " res
if [[ $res != "s" ]]; then echo "Abortado."; exit 1; fi

npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

read -p "Paso 3: Configurar Tailwind con fuente y colores personalizados. ¿Continuar? (s/n): " res
if [[ $res != "s" ]]; then echo "Abortado."; exit 1; fi

cat > tailwind.config.js <<EOL
/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts}"],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Open Sans', 'sans-serif'],
      },
      colors: {
        nota1: '#FEF9C3',
        nota2: '#DBEAFE',
        nota3: '#FECACA',
      }
    },
  },
  plugins: [],
}
EOL

read -p "Paso 4: Crear archivo src/index.css con Tailwind y fuente. ¿Continuar? (s/n): " res
if [[ $res != "s" ]]; then echo "Abortado."; exit 1; fi

mkdir -p src
cat > src/index.css <<EOL
@tailwind base;
@tailwind components;
@tailwind utilities;

@import url('https://fonts.googleapis.com/css2?family=Open+Sans&display=swap');

body {
  font-family: 'Open Sans', sans-serif;
}
EOL

read -p "Paso 5: Crear index.html con barra alfabética. ¿Continuar? (s/n): " res
if [[ $res != "s" ]]; then echo "Abortado."; exit 1; fi

cat > index.html <<'EOL'
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Clik - Libreta Alfabética</title>
  <link rel="stylesheet" href="./dist/output.css" />
</head>
<body class="flex min-h-screen bg-gray-50 text-gray-800">
  <aside class="w-16 bg-white shadow p-2 flex flex-col items-center space-y-1 sticky top-0">
    <script>
      const letras = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('');
      document.write(letras.map(l => \`<a href="#\${l}" class="text-sm hover:font-bold">\${l}</a>\`).join(''));
    </script>
  </aside>

  <main class="flex-1 p-4 space-y-10" id="notas">
    <script>
      letras.forEach(letra => {
        document.write(\`
          <section id="\${letra}">
            <h2 class="text-xl font-bold mb-2">\${letra}</h2>
            <div class="space-y-2" id="seccion-\${letra}"></div>
            <button onclick="nuevaNota('\${letra}')" class="mt-2 text-sm bg-blue-200 hover:bg-blue-300 rounded px-2 py-1">+ Nota</button>
          </section>
        \`);
      });
    </script>
  </main>

  <script src="./src/main.js"></script>
</body>
</html>
EOL

read -p "Paso 6: Crear JavaScript para añadir notas con fecha y color aleatorio. ¿Continuar? (s/n): " res
if [[ $res != "s" ]]; then echo "Abortado."; exit 1; fi

cat > src/main.js <<'EOL'
function nuevaNota(letra) {
  const contenedor = document.getElementById(`seccion-${letra}`);
  const fecha = new Date().toLocaleString();
  const colores = ['nota1', 'nota2', 'nota3'];
  const color = colores[Math.floor(Math.random() * colores.length)];
  const div = document.createElement('div');
  div.className = `p-2 rounded shadow bg-${color}`;
  div.innerHTML = `
    <div class="text-xs text-gray-500 mb-1">${fecha}</div>
    <textarea class="w-full bg-transparent outline-none resize-none" rows="4" placeholder="Escribe tu nota..."></textarea>
  `;
  contenedor.appendChild(div);
}
EOL

read -p "Paso 7: Compilar Tailwind CSS (output.css). ¿Continuar? (s/n): " res
if [[ $res != "s" ]]; then echo "Abortado."; exit 1; fi

mkdir -p dist
npx tailwindcss -i ./src/index.css -o ./dist/output.css

read -p "Paso 8: Agregar script build_css al package.json. ¿Continuar? (s/n): " res
if [[ $res != "s" ]]; then echo "Abortado."; exit 1; fi

if command -v jq >/dev/null 2>&1; then
  tmp=$(mktemp)
  jq '.scripts.build_css = "tailwindcss -i ./src/index.css -o ./dist/output.css --watch"' package.json > "$tmp" && mv "$tmp" package.json
else
  echo "Agrega manualmente en package.json dentro de 'scripts':"
  echo '"build_css": "tailwindcss -i ./src/index.css -o ./dist/output.css --watch"'
fi

read -p "Paso 9: Copiar archivos a carpeta docs/ para GitHub Pages. ¿Continuar? (s/n): " res
if [[ $res != "s" ]]; then echo "Abortado."; exit 1; fi

mkdir -p docs
cp index.html docs/
cp -r dist docs/

echo "🎉 Proyecto listo. Ejecuta 'npm run build_css' y abre index.html o publica la carpeta docs/ en GitHub Pages."
