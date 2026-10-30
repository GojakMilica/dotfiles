#!/bin/sh
# Broj dostupnih update-a (repo + AUR) za waybar custom/updates
# Prazan text sakriva modul; klasa "many" na 50+ (boja u style.css)

# checkupdates vraća 2 kad nema update-a, yay -Qua 1; oba su u redu
list=$( { checkupdates 2>/dev/null; yay -Qua 2>/dev/null; } | sed 's/ -> / → /')

if [ -z "$list" ]; then
    echo '{"text": ""}'
    exit 0
fi

count=$(printf '%s\n' "$list" | wc -l)
class=""
[ "$count" -ge 50 ] && class="many"

# Imena i verzije paketa nemaju navodnike ni < &, pa nije potreban jq
tooltip=$(printf '%s\n' "$list" | head -n 20 | sed ':a;N;$!ba;s/\n/\\n/g')
[ "$count" -gt 20 ] && tooltip="$tooltip\\n… i još $((count - 20))"

printf '{"text": "󰏗 %s", "tooltip": "%s", "class": "%s"}\n' "$count" "$tooltip" "$class"
