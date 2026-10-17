#!/usr/bin/env bash
# set -e le dice a Bash: "Si algún comando de este script falla, detén la ejecución inmediatamente".
set -e

# ---------- Preparación del repositorio ----------

# mktemp -d crea una carpeta temporal en el sistema con un nombre aleatorio.
# Se guarda esa ruta en la variable WORKDIR. Como ves en tu comentario, es para no ensuciar tu escritorio.
WORKDIR=$(mktemp -d)

# cd entra a la carpeta temporal creada.
# todo lo que se cree se guardará en la carpeta.
cd "$WORKDIR"

# git init inicializa un repositorio vacío. 
# -q (quiet) significa "silencio": evita que Git imprima los mensajes típicos de inicialización en pantalla.
# -b main le dice a Git que cree la rama principal con el nombre "main" en lugar de "master".
git init -q -b main

# Configura el correo y nombre del autor SOLO para este repositorio (sin la etiqueta --global).
# simula que el proyecto lo hace un usuario llamado "Equipo ACI".
git config user.email "equipo@aci.cl"
git config user.name "Equipo ACI"

# echo imprime def login(usuario): pass y el ">" redirige esa salida a un archivo.
# Si "auth.py" no existe, lo crea. Si existe, lo sobrescribe. Asi crea el archivo con la primera línea.
echo "def login(usuario): pass" > auth.py

# git add prepara el archivo para el próximo commit (lo pasa al "Staging Area").
git add auth.py

# git commit guarda los cambios en el historial local. -q lo hace en silencio.
# -m indica que el mensaje del commit va a continuación entre comillas.
git commit -q -m "Estructura inicial de auth.py"

# Muestra en pantalla la ruta exacta de la carpeta temporal que se creó.
echo "Repositorio creado en: $WORKDIR"
echo


# ---------- Ana trabaja en su propia rama ----------

# git checkout -b crea una nueva rama Y se mueve a ella inmediatamente. 
# -q es silencio. Aquí Ana crea su rama "feature/ana-login".
git checkout -q -b feature/ana-login

# Vuelve a usar ">" para sobrescribir auth.py, pero esta vez con la versión mejorada de Ana.
echo "def login(usuario, password): return usuario and password" > auth.py

# Prepara el cambio de Ana y lo guarda en el historial de SU rama.
git add auth.py
git commit -q -m "Ana: agrega validacion de login"

# Como Ana ya terminó, vuelve a la rama principal "main".
# Su cambio NO se ha perdido, simplemente se quedó guardado en su rama.
git checkout -q main


# ---------- Beto trabaja en su propia rama ----------
git checkout -q -b feature/beto-logout
# Beto crea un archivo NUEVO (logout.py) para evitar el conflicto con el archivo de Ana.
echo "def logout(usuario): print('sesion cerrada')" > logout.py
git add logout.py
git commit -q -m "Beto: agrega logout en archivo separado"
# Beto termina su trabajo y vuelve a main.
git checkout -q main


# ---------- Estado actual ----------

echo "=== Ramas existentes ==="
git branch # Muestra las ramas existentes. 
echo

echo "=== Historial de main (solo el commit inicial) ==="
git log --oneline # Muestra el historial de la rama actual (main). 
# Solo el primer commit, porque los de Ana y Beto están "escondidos" en sus respectivas ramas.
echo

# cat muestra el contenido del archivo en la terminal.
# Como estamos en main (y no se ha hecho merge), vemos el auth.py original.
echo "=== Contenido de auth.py en main ==="
cat auth.py
echo
echo


# ---------- El admin revisa y mergea a Ana ----------

echo "=== Merge controlado de feature/ana-login (aprobado por revisor) ==="
# git merge fusiona la rama indicada con la rama actual (main).
# --no-ff obliga a Git a crear un "commit de merge" explícito (no un fast-forward).
# Esto deja un registro visual en el historial de que hubo un merge.
# -q silencio. -m es el mensaje del commit de merge.
git merge --no-ff -q feature/ana-login -m "Merge: feature/ana-login -> main (revisado y aprobado)"
echo


# ---------- El admin revisa y mergea a Beto ----------

echo "=== Merge controlado de feature/beto-logout (aprobado por revisor) ==="
# Como Beto creó un archivo nuevo (logout.py), no hay choque con el archivo de Ana.
# Git los fusiona automáticamente sin problemas.
git merge --no-ff -q feature/beto-logout -m "Merge: feature/beto-logout -> main (revisado y aprobado)"
echo


# ---------- Resultado final ----------

echo "=== Historial final de main ==="
# git log --oneline muestra el historial resumido.
# --graph dibuja líneas ASCII (como un árbol) para ver los merges.
# --all muestra TODAS las ramas, no solo main.
git log --oneline --graph --all
echo

echo "=== Contenido final de auth.py en main ==="
# Muestra el archivo auth.py. Aquí solo se verá la función de login de Ana.
cat auth.py
echo
echo

echo "=== Contenido final de logout.py en main ==="
# Muestra el archivo logout.py que creó Beto.
cat logout.py
echo
echo


# ---------- Simulacion de reversion aislada ----------

# texto informativo en pantalla.
echo "=== Caso hipotetico: Beto introduce un bug ==="
echo "Para revertir SOLO el cambio de Beto, sin tocar el de Ana:"
echo "  git revert <hash_del_merge_de_Beto> -m 1"
echo
echo "El commit de Ana permanece intacto porque estan en ramas separadas."
