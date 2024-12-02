#!/bin/bash

archivo_logs="syslog_logs_5000.log"

while true; do
    echo "Menu"
    echo "1. Logs por fecha sin grep"
    echo "2. Logs por fecha con grep"
    echo "3. Cantidad de logs por cada servicio"
    echo "4. Salir"
    echo -n "Introduce la opción deseada: "
    read opcion

    case $opcion in
        1)
            echo "Has escogido 'Logs por fecha sin grep'."
            echo "¿Quieres logs del 11 de Noviembre o 12 de Noviembre? (11/12)"
            read fecha
            if [[ "$fecha" != "11" && "$fecha" != "12" ]]; then
                echo "Fecha no válida. Debes elegir 11 o 12."
                continue
            fi
            if [[ ! -f "$archivo_logs" ]]; then
                echo "El archivo '$archivo_logs' no existe. Intenta de nuevo."
                continue
            fi
            archivo_salida="logs_filtrados_$fecha.txt"
            count=0
            while IFS= read -r linea; do
                if [[ "$fecha" == "11" && "$linea" == *"Nov 11"* ]]; then
                    echo "$linea" >> "$archivo_salida"
                    ((count++))
                elif [[ "$fecha" == "12" && "$linea" == *"Nov 12"* ]]; then
                    echo "$linea" >> "$archivo_salida"
                    ((count++))
                fi
            done < "$archivo_logs"
            echo "Se han guardado $count líneas en el archivo '$archivo_salida'."
            ;;
        2)
            echo "Has escogido 'Logs por fecha con grep'."
            echo "¿Quieres logs del 11 de Noviembre o 12 de Noviembre? (11/12)"
            read fecha
            if [[ "$fecha" != "11" && "$fecha" != "12" ]]; then
                echo "Fecha no válida. Debes elegir 11 o 12."
                continue
            fi
            if [[ ! -f "$archivo_logs" ]]; then
                echo "El archivo '$archivo_logs' no existe. Intenta de nuevo."
                continue
            fi
            archivo_salida="logs_filtrados_$fecha.txt"
            grep "Nov $fecha" "$archivo_logs" > "$archivo_salida"
            count=$(grep -c "Nov $fecha" "$archivo_logs")
            echo "Se han guardado $count líneas en el archivo '$archivo_salida'."
            ;;
        3)
            if [[ ! -f "$archivo_logs" ]]; then
                echo "El archivo '$archivo_logs' no existe. Intenta de nuevo."
                continue
            fi
            echo "Has escogido 'Cantidad de logs por cada servicio'."
            awk '{ 
                match($5, /([a-zA-Z]+)\[/, arr); 
                if (arr[1] != "") { 
                    servicios[arr[1]]++; 
                } 
            } 
            END { 
                for (servicio in servicios) { 
                    print servicio " ha generado " servicios[servicio] " logs"; 
                } 
            }' "$archivo_logs"
            ;;
        4)
            echo "Has escogido 'Salir'."
            break
            ;;
        *)
            echo "Opción inválida. Por favor, elige una opción del 1 al 4."
            ;;
    esac
done

echo "Saliendo del programa."
