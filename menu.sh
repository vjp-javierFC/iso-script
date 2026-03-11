#!/bin/bash

show_menu() {
    clear
    echo "=============================="
    echo "           MENÚ               "
    echo "=============================="
    echo "1. Fichero passwd ordenado por /home/* en columnas"
    echo "2. Listado de ficheros vacíos en el árbol de directorios"
    echo "3. Generar 200 números aleatorios y contar repeticiones"
    echo "4. Mostrar información del sistema con fastfetch y lolcat"
    echo "5. Listado coloreado con lolcat del directorio actual"
    echo "6. Salir"
    echo "=============================="
    echo -n "Selecciona una opción: "
}

execute_command() {
    case "$1" in

        1)
            echo "Ficheros passwd ordenados por /home/*:"
            grep '/home/' /etc/passwd | sort | column -t -s:
            ;;

        2)
            echo "Buscando ficheros vacíos en el directorio actual..."
            find . -type f -empty 2>/dev/null
            ;;

        3)
            echo "Generando 200 números aleatorios y contando repeticiones..."
            shuf -i 1-100 -n 200 | sort | uniq -c | sort -rn
            ;;

        4)
            if command -v fastfetch >/dev/null 2>&1 && command -v lolcat >/dev/null 2>&1; then
                fastfetch | lolcat
            else
                echo "Error: instala fastfetch y lolcat primero."
            fi
            ;;

        5)
            if command -v lolcat >/dev/null 2>&1; then
                ls -la | lolcat
            else
                echo "Error: lolcat no está instalado."
            fi
            ;;

        6)
            echo "Saliendo..."
            exit 0
            ;;

        *)
            echo "Opción inválida. Intenta de nuevo."
            ;;

    esac
}

# Bucle principal del menú
while true; do
    show_menu
    read option
    execute_command "$option"
    echo
    read -p "Pulsa Enter para continuar..."
done
