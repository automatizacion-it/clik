#!/bin/bash

# --- Funciones Auxiliares ---
confirm() {
    # $1: Mensaje de pregunta
    while true; do
        read -r -p "$1 [S/N]: " respuesta
        case $respuesta in
            [Ss]* ) return 0;; # Éxito (Sí)
            [Nn]* ) return 1;; # Fallo (No)
            * ) echo "Por favor, responde S o N.";;
        esac
    done
}

echo "----------------------------------------------------"
echo "  🚀 INICIANDO CONFIGURACIÓN: LIBRETA DE NOTAS 🚀 "
echo "----------------------------------------------------"
echo "Este script te guiará para configurar el proyecto."
echo "La carpeta actual del proyecto es: $(pwd)"
echo ""

# --- FASE 1: ESTRUCTURA BÁSICA Y ESTILOS INICIALES ---
echo "--- FASE 1: ESTRUCTURA BÁSICA Y ESTILOS INICIALES ---"

if confirm "¿Estás en la carpeta raíz del proyecto '/workspaces/clik/'?"; then
    echo "👍 Continuamos..."
else
    echo "✋ Por favor, navega a la carpeta correcta y ejecuta el script de nuevo."
    exit 1
fi
echo ""

# 1. Crear index.html
if confirm "¿1. Crear archivo 'index.html' con contenido base?"; then
    cat << 'EOF' > index.html
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ClickNotes - Tu Libreta</title>
    <link href="./dist/output.css" rel="stylesheet">
</head>
<body class="bg-gray-100 font-sans">
    <div class="container mx-auto p-4">
        <header class="text-center mb-8">
            <h1 class="text-4xl font-bold text-blue-600">ClickNotes</h1>
        </header>

        <main class="flex flex-col md:flex-row">
            <!-- Sección de Notas (izquierda/principal) -->
            <section id="notes-section" class="w-full md:w-3/4 md:pr-4 mb-6 md:mb-0">
                <h2 class="text-2xl font-semibold mb-4 text-gray-700">Mis Notas</h2>
                <!-- Formulario para añadir notas -->
                <form id="add-note-form" class="mb-6 p-4 bg-white shadow-md rounded-lg">
                    <input type="text" id="note-title" placeholder="Título de la nota" class="w-full p-2 border border-gray-300 rounded mb-2 focus:outline-none focus:ring-2 focus:ring-blue-500" required>
                    <textarea id="note-content" placeholder="Contenido..." rows="3" class="w-full p-2 border border-gray-300 rounded mb-2 focus:outline-none focus:ring-2 focus:ring-blue-500" required></textarea>
                    <div class="mb-3">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Importancia:</label>
                        <select id="note-importance" class="w-full p-2 border border-gray-300 rounded bg-white focus:outline-none focus:ring-2 focus:ring-blue-500">
                            <option value="1" class="bg-green-100">Baja (Verde)</option>
                            <option value="2" class="bg-yellow-100">Media (Amarillo)</option>
                            <option value="3" class="bg-red-100">Alta (Rojo)</option>
                        </select>
                    </div>
                    <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
                        Añadir Nota
                    </button>
                </form>

                <!-- Contenedor para mostrar las notas -->
                <div id="notes-container" class="space-y-4">
                    <!-- Las notas se insertarán aquí con JS -->
                </div>
            </section>

            <!-- Barra Lateral de Letras (derecha) -->
            <aside id="alphabet-sidebar" class="w-full md:w-1/4 md:pl-4 md:border-l md:border-gray-300">
                <h3 class="text-xl font-semibold mb-3 text-gray-600">Índice</h3>
                <ul id="alphabet-list" class="space-y-1">
                    <!-- Las letras se insertarán aquí con JS -->
                </ul>
            </aside>
        </main>

        <footer class="text-center mt-12 py-4 border-t border-gray-300">
            <p class="text-gray-600">© <span id="current-year"></span> ClickNotes</p>
        </footer>
    </div>
    <script src="./js/script.js"></script>
</body>
</html>
EOF
    echo "✅ 'index.html' creado."
else
    echo "ℹ️  Omitiendo creación de 'index.html'."
fi
echo ""

# 2. Crear src/input.css
if confirm "¿2. Crear carpeta 'src' y archivo 'src/input.css' con directivas de Tailwind?"; then
    mkdir -p src
    cat << 'EOF' > src/input.css
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Clases personalizadas para importancia de notas */
.note-importance-1 { @apply bg-green-50 border-green-300; }
.note-importance-1 .note-title { @apply text-green-700; }

.note-importance-2 { @apply bg-yellow-50 border-yellow-300; }
.note-importance-2 .note-title { @apply text-yellow-700; }

.note-importance-3 { @apply bg-red-50 border-red-300; }
.note-importance-3 .note-title { @apply text-red-700; }
EOF
    echo "✅ 'src/input.css' creado."
else
    echo "ℹ️  Omitiendo creación de 'src/input.css'."
fi
echo ""

# 3. Crear carpeta dist
if confirm "¿3. Crear carpeta 'dist' (para el CSS compilado)?"; then
    mkdir -p dist
    echo "✅ Carpeta 'dist' creada/asegurada."
else
    echo "ℹ️  Omitiendo creación de carpeta 'dist'."
fi
echo ""

# 4. Crear js/script.js
if confirm "¿4. Crear carpeta 'js' y archivo 'js/script.js' (inicialmente vacío o con estructura base)?"; then
    mkdir -p js
    cat << 'EOF' > js/script.js
document.addEventListener('DOMContentLoaded', () => {
    const addNoteForm = document.getElementById('add-note-form');
    const noteTitleInput = document.getElementById('note-title');
    const noteContentInput = document.getElementById('note-content');
    const noteImportanceInput = document.getElementById('note-importance');
    const notesContainer = document.getElementById('notes-container');
    const alphabetList = document.getElementById('alphabet-list');
    const currentYearSpan = document.getElementById('current-year');

    if (currentYearSpan) {
        currentYearSpan.textContent = new Date().getFullYear();
    }

    let notes = JSON.parse(localStorage.getItem('clicknotes_v2')) || []; // Usar v2 para evitar conflictos con versiones antiguas

    // --- RENDERIZADO ---
    function renderNotes(notesToRender = notes) {
        notesContainer.innerHTML = ''; // Limpiar notas existentes
        if (notesToRender.length === 0) {
            notesContainer.innerHTML = '<p class="text-gray-500">No hay notas todavía. ¡Añade una!</p>';
            return;
        }

        // Ordenar notas alfabéticamente por título
        const sortedNotes = [...notesToRender].sort((a, b) => a.title.localeCompare(b.title));

        sortedNotes.forEach(note => {
            const noteElement = document.createElement('div');
            noteElement.classList.add('p-4', 'border', 'rounded-lg', 'shadow', `note-importance-${note.importance}`);
            noteElement.innerHTML = \`
                <h3 class="note-title text-xl font-semibold mb-2">\${note.title}</h3>
                <p class="text-gray-700 mb-3 whitespace-pre-wrap">\${note.content}</p>
                <div class="text-xs text-gray-500 flex justify-between items-center">
                    <span>Importancia: \${getImportanceText(note.importance)}</span>
                    <button data-id="\${note.id}" class="delete-note-btn text-red-500 hover:text-red-700 font-semibold">Eliminar</button>
                </div>
            \`;
            notesContainer.appendChild(noteElement);
        });
        addDeleteEventListeners();
    }

    function getImportanceText(level) {
        if (level == 1 || level === "1") return 'Baja';
        if (level == 2 || level === "2") return 'Media';
        if (level == 3 || level === "3") return 'Alta';
        return 'Desconocida';
    }

    function renderAlphabetSidebar() {
        alphabetList.innerHTML = '';
        const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split('');
        const availableLetters = new Set(notes.map(note => note.title.charAt(0).toUpperCase()).filter(letter => letter.match(/[A-Z]/i)));


        // Botón "Todas"
        const allLi = document.createElement('li');
        const allButton = document.createElement('button');
        allButton.textContent = 'Todas';
        allButton.classList.add('w-full', 'text-left', 'p-1', 'hover:bg-blue-100', 'rounded', 'font-semibold', 'text-blue-600');
        allButton.addEventListener('click', () => renderNotes(notes));
        allLi.appendChild(allButton);
        alphabetList.appendChild(allLi);

        alphabet.forEach(letter => {
            const li = document.createElement('li');
            const button = document.createElement('button');
            button.textContent = letter;
            button.classList.add('w-full', 'text-left', 'p-1', 'hover:bg-gray-200', 'rounded');
            if (availableLetters.has(letter)) {
                button.classList.add('font-semibold', 'text-gray-800');
                button.addEventListener('click', () => filterNotesByLetter(letter));
            } else {
                button.classList.add('text-gray-400', 'cursor-not-allowed');
                button.disabled = true;
            }
            li.appendChild(button);
            alphabetList.appendChild(li);
        });
    }

    // --- LÓGICA DE NOTAS ---
    if (addNoteForm) {
        addNoteForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const title = noteTitleInput.value.trim();
            const content = noteContentInput.value.trim();
            const importance = noteImportanceInput.value;

            if (!title || !content) {
                alert('Por favor, completa el título y el contenido.');
                return;
            }

            const newNote = {
                id: Date.now(), // ID único simple
                title,
                content,
                importance
            };

            notes.push(newNote);
            saveNotes();
            renderNotes();
            renderAlphabetSidebar(); // Actualizar la barra lateral
            addNoteForm.reset(); // Limpiar formulario
        });
    }

    function deleteNote(noteId) {
        notes = notes.filter(note => note.id !== noteId);
        saveNotes();
        renderNotes(notes); // Re-render con la lista filtrada o la lista completa si no hay filtro activo
        renderAlphabetSidebar();
    }

    function addDeleteEventListeners() {
        document.querySelectorAll('.delete-note-btn').forEach(button => {
            // Remover event listeners anteriores para evitar duplicados si se llama varias veces
            const newButton = button.cloneNode(true);
            button.parentNode.replaceChild(newButton, button);

            newButton.addEventListener('click', (e) => {
                const noteId = parseInt(e.target.dataset.id);
                if (confirm('¿Estás seguro de que quieres eliminar esta nota?')) {
                    deleteNote(noteId);
                }
            });
        });
    }
    
    function filterNotesByLetter(letter) {
        const filtered = notes.filter(note => note.title.charAt(0).toUpperCase() === letter);
        renderNotes(filtered);
    }

    function saveNotes() {
        localStorage.setItem('clicknotes_v2', JSON.stringify(notes));
    }

    // --- INICIALIZACIÓN ---
    renderNotes();
    renderAlphabetSidebar();
});
EOF
    echo "✅ 'js/script.js' creado con la lógica base."
else
    echo "ℹ️  Omitiendo creación de 'js/script.js'."
fi
echo ""

# 5. Configurar tailwind.config.js
if confirm "¿5. Configurar 'tailwind.config.js' (se creará si no existe)?"; then
    if [ ! -f tailwind.config.js ]; then
        echo "tailwind.config.js no existe. Ejecutando 'npx tailwindcss init' para crearlo..."
        npx tailwindcss init # Crea un tailwind.config.js básico
    fi
    # Sobreescribir o asegurar el contenido correcto
    cat << 'EOF' > tailwind.config.js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./*.html",
    "./js/**/*.js",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF
    echo "✅ 'tailwind.config.js' configurado."
else
    echo "ℹ️  Omitiendo configuración de 'tailwind.config.js'."
fi
echo ""

# 6. Configurar package.json
if confirm "¿6. Añadir scripts 'dev' y 'build' a 'package.json'?"; then
    if [ ! -f package.json ]; then
        echo "'package.json' no encontrado. Por favor, ejecute 'npm init -y' primero."
    else
        # Usamos jq para modificar el JSON de forma segura si está instalado
        if command -v jq &> /dev/null; then
            jq '.scripts.dev = "tailwindcss -i ./src/input.css -o ./dist/output.css --watch" | .scripts.build = "NODE_ENV=production tailwindcss -i ./src/input.css -o ./dist/output.css --minify"' package.json > package.json.tmp && mv package.json.tmp package.json
            echo "✅ Scripts añadidos a 'package.json' usando jq."
        else
            echo "⚠️ 'jq' no está instalado. Tendrás que añadir los scripts manualmente a 'package.json':"
            echo '  "dev": "tailwindcss -i ./src/input.css -o ./dist/output.css --watch",'
            echo '  "build": "NODE_ENV=production tailwindcss -i ./src/input.css -o ./dist/output.css --minify"'
            echo "  (Asegúrate de que estén dentro de la sección \"scripts\" y que haya comas correctas)"
        fi
    fi
else
    echo "ℹ️  Omitiendo configuración de scripts en 'package.json'."
fi
echo ""

echo "--- FASE 1 COMPLETADA ---"
echo "RECOMENDACIÓN: Ejecuta 'npm install' si has modificado 'package.json' o no lo has hecho aún."
echo "Luego, ejecuta 'npm run dev' y abre 'index.html' en tu navegador para probar."
echo ""

# --- FASE 3: PREPARACIÓN PARA GITHUB PAGES (parcialmente automatizable) ---
echo "--- FASE 3: PREPARACIÓN PARA GITHUB PAGES ---"

if confirm "¿7. Generar CSS de producción ejecutando 'npm run build'?"; then
    if grep -q '"build":' package.json; then
        npm run build
        echo "✅ CSS de producción generado en 'dist/output.css'."
    else
        echo "⚠️  Script 'build' no encontrado en 'package.json'. Omitiendo."
    fi
else
    echo "ℹ️  Omitiendo generación de CSS de producción."
fi
echo ""

if confirm "¿8. Inicializar repositorio Git (si no existe)?"; then
    if [ -d .git ]; then
        echo "ℹ️  El repositorio Git ya existe."
    else
        git init
        echo "✅ Repositorio Git inicializado."
    fi
else
    echo "ℹ️  Omitiendo inicialización de Git."
fi
echo ""

if confirm "¿9. Crear archivo '.gitignore'?"; then
    cat << 'EOF' > .gitignore
node_modules/
.vscode/
npm-debug.log*
*.log
dist/ # Si usas GitHub Actions para construir, si no, comenta esta línea
# Si NO usas GitHub Actions para construir, entonces NO ignores 'dist/'
# y asegúrate de que 'dist/output.css' esté en el commit.
# Para el caso de despliegue directo desde la rama sin Actions,
# no deberías ignorar 'dist/'.
EOF
    echo "✅ '.gitignore' creado. REVISA SU CONTENIDO:"
    echo "   - Si despliegas compilando localmente y subiendo la carpeta 'dist', elimina o comenta la línea 'dist/'."
    echo "   - Si usas GitHub Actions para compilar en el servidor, está bien ignorar 'dist/'."
    echo "   Para un despliegue simple en GH Pages sin Actions, NO ignores 'dist/'."
    if confirm "¿Deseas eliminar 'dist/' de .gitignore para incluirlo en los commits (recomendado para GH Pages simple)?"; then
        # Esto comentará la línea dist/ en .gitignore si existe
        sed -i '/^dist\//s/^/#/' .gitignore
        echo "✅ 'dist/' ahora NO será ignorado por Git (línea comentada en .gitignore)."
    fi
else
    echo "ℹ️  Omitiendo creación de '.gitignore'."
fi
echo ""

echo "--- PASOS MANUALES IMPORTANTES PARA GITHUB ---"
echo "10. Ve a GitHub.com y CREA UN NUEVO REPOSITORIO PÚBLICO (ej. 'clicknotes')."
echo "    NO lo inicialices con README, .gitignore o licencia desde GitHub."
echo ""
read -r -p "Pega la URL HTTPS o SSH de tu nuevo repositorio de GitHub y presiona Enter: " GITHUB_REPO_URL

if [ -n "$GITHUB_REPO_URL" ]; then
    if confirm "¿11. Conectar repositorio local a '$GITHUB_REPO_URL' y establecer rama 'main'?"; then
        git remote remove origin 2>/dev/null # Elimina remote si existe
        git remote add origin "$GITHUB_REPO_URL"
        git branch -M main
        echo "✅ Repositorio local conectado y rama principal establecida a 'main'."
    else
        echo "ℹ️  Omitiendo conexión a repositorio remoto."
    fi
    echo ""

    if confirm "¿12. Hacer 'git add .', 'git commit', y 'git push origin main'?"; then
        git add .
        read -r -p "Introduce un mensaje para el commit (ej: 'Configuración inicial del proyecto'): " COMMIT_MESSAGE
        if [ -z "$COMMIT_MESSAGE" ]; then
            COMMIT_MESSAGE="Configuración inicial del proyecto ClickNotes"
        fi
        git commit -m "$COMMIT_MESSAGE"
        git push -u origin main
        echo "✅ Código subido a GitHub."
    else
        echo "ℹ️  Omitiendo commit y push."
    fi
else
    echo "⚠️  No se proporcionó URL del repositorio. Saltando pasos de conexión y subida a GitHub."
fi
echo ""

echo "--- FASE 3 COMPLETADA (parcialmente) ---"
echo ""
echo "--- FASE 4: DESPLEGAR EN GITHUB PAGES (MANUAL) ---"
echo "1. Ve a la página de tu repositorio en GitHub.com."
echo "2. Ve a 'Settings' (Configuración)."
echo "3. En el menú lateral, ve a 'Pages'."
echo "4. En 'Build and deployment', bajo 'Source', selecciona 'Deploy from a branch'."
echo "5. Bajo 'Branch', selecciona 'main', carpeta '/ (root)', y haz clic en 'Save'."
echo "6. Espera unos minutos y tu sitio estará disponible en https://TU_USUARIO.github.io/NOMBRE_DEL_REPOSITORIO/"
echo ""
echo "🎉 ¡Configuración Guiada Finalizada! 🎉"