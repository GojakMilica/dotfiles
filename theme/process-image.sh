#!/usr/bin/env bash
# Obrada slike za temu: paleta (lutgen) → blago potamni → desna polovina se pretapa u providno.
# Sa --lock: paleta → potamni korom (ispod svetlog teksta), blago zamućeno, bez pretapanja (pozadina za hyprlock).
# Original se ne dira, rezultat ide u theme/images/generated/.
#
# Upotreba: theme/process-image.sh [--lock] SLIKA [ŠIRINA:VISINA]
#   --lock         tamnija obrada za zaključan ekran, izlaz SLIKA-lock.jpg
#   ŠIRINA:VISINA  opciono, centralno iseca na taj odnos pre gradijenta
#                  (npr. 4:9 za uspravnu sliku u rofi-ju, da prelaz padne na vidljivu ivicu)
set -euo pipefail

dir=$(cd "$(dirname "$0")" && pwd)
palette="$dir/palette"
out_dir="$dir/images/generated"

lock=false
if [[ ${1:-} == --lock ]]; then lock=true; shift; fi

in=${1:?Upotreba: $0 [--lock] SLIKA [ŠIRINA:VISINA]}
ratio=${2:-}
name=$(basename "${in%.*}")
if $lock; then out="$out_dir/$name-lock.jpg"; else out="$out_dir/$name.png"; fi

mapfile -t colors < <(grep -E '^[a-z_]+=#' "$palette" | cut -d= -f2)

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$out_dir"

# 1. provuci kroz paletu
lutgen apply -o "$tmp/paleta.png" "$in" -- "${colors[@]}"

# 2. opciono iseci na odnos
crop=()
if [[ -n $ratio ]]; then
    read -r w h < <(magick identify -format '%w %h\n' "$tmp/paleta.png")
    rw=${ratio%:*} rh=${ratio#*:}
    cw=$(( h * rw / rh )) ch=$h
    if (( cw > w )); then cw=$w ch=$(( w * rh / rw )); fi
    crop=(-gravity center -crop "${cw}x${ch}+0+0" +repage)
fi

# lock: pokriva ceo ekran, pa veća rezolucija; potamni mešanjem sa korom (-modulate bi zamutio boje u smeđe)
#       i blago zamući, da svetao tekst bude čitljiv
if $lock; then
    kora=$(grep '^kora=' "$palette" | cut -d= -f2)
    magick "$tmp/paleta.png" "${crop[@]}" -resize 'x1440>' -fill "$kora" -colorize 58% -blur 0x4 -quality 90 "$out"
    echo "$out"
    exit
fi

# rofi: smanji (rofi ne treba 5000px) i blago potamni
magick "$tmp/paleta.png" "${crop[@]}" -resize 'x1080>' -modulate 85 "$tmp/tamna.png"

# 3. desna polovina postepeno postaje providna, pa se kroz nju vidi pozadina prozora
#    (ista kao iza panela, bez šava); sigmoid omekšava oba kraja prelaza
read -r w h < <(magick identify -format '%w %h\n' "$tmp/tamna.png")
fade=$(( w / 2 ))
magick -size "$(( w - fade ))x$h" xc:white \
    \( -size "${fade}x$h" -define gradient:direction=east gradient:white-black -sigmoidal-contrast 5x50% \) \
    +append "$tmp/maska.png"
magick "$tmp/tamna.png" "$tmp/maska.png" -alpha off -compose CopyOpacity -composite "$out"

echo "$out"
