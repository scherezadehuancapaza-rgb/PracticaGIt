!/usr/bin/env bash
# ============================================================
# CASO B · SIN RESOLVER
# Dos integrantes del equipo trabajando al mismo tiempo, ambos
# comiteando directo sobre main (sin ninguna rama).
#
# Ejecuta este script y observa: "git branch" muestra una sola
# rama, y el log mezcla el trabajo de ambas personas sin separar.
# ============================================================
set -e
WORKDIR=$(mktemp -d)
cd "$WORKDIR"
git init -q -b main
git config user.email "equipo@aci.cl"
git config user.name "Equipo ACI"
echo "def login(usuario): pass" > auth.py
git add auth.py
git commit -q -m "Estructura inicial de auth.py"
# Ana trabaja directo en main
echo "def login(usuario, password): return usuario and password" > auth.py
git add auth.py
git commit -q -m "Ana: agrega validacion de login"
# Beto también trabaja directo en main, al mismo tiempo
echo "def logout(usuario): print('sesion cerrada')" >> auth.py
git add auth.py
git commit -q -m "Beto: agrega logout"
echo "=== git branch ==="
git branch
echo
echo "=== git log --oneline ==="
git log --oneline
echo
echo "Reto: si el cambio de Beto tuviera un bug, no hay forma de revertirlo sin tocar
t"
#Problema ambos Ana y Beto trabajan diectamente en main. Lo correcto es que cada integrante debe crear una rama propia por tarea
# (feature/ana-login, feature/beto-logout) y trabajar ahí de forma aislada. Cuando terminan, suben su rama al 
#repositorio remoto . Luego  hara  un Pull Request el administrador habiendo revisado el código y, solo si está correcto, 
#aprueba el merge hacia main.  De este modo si una rama introduce un bug, se detecta antes de llegar a main, o 
#se revierte fácilmente sin afectar el trabajo de los demás.
