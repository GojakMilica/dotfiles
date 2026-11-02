#!/usr/bin/env bash
# Obrada slike za temu: paleta (lutgen) → blago potamni → desna trećina prelazi u koru.
# Original se ne dira, rezultat ide u theme/images/generated/.
#
# Upotreba: theme/process-image.sh SLIKA [ŠIRINA:VISINA]
#   ŠIRINA:VISINA  opciono, centralno iseca na taj odnos pre gradijenta
#                  (npr. 4:9 za uspravnu sliku u rofi-ju, da prelaz padne na vidljivu ivicu)
set -euo pipefail

dir=$(cd "$(dirname "$0")" && pwd)
palette="$dir/palette"
out_dir="$dir/images/generated"

in=${1:?Upotreba: $0 SLIKA [ŠIRINA:VISINA]}
ratio=${2:-}
out="$out_dir/$(basename "${in%.*}").jpg"

mapfile -t colors < <(grep -E '^[a-z_]+=#' "$palette" | cut -d= -f2)
kora=$(grep '^kora=' "$palette" | cut -d= -f2)

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$out_dir"

# 1. provuci kroz paletu
lutgen apply -o "$tmp/paleta.png" "$in" -- "${colors[@]}"

# 2. opciono iseci na odnos, smanji (rofi ne treba 5000px) i blago potamni
crop=()
if [[ -n $ratio ]]; then
    read -r w h < <(magick identify -format '%w %h' "$tmp/paleta.png")
    rw=${ratio%:*} rh=${ratio#*:}
    cw=$(( h * rw / rh )) ch=$h
    if (( cw > w )); then cw=$w ch=$(( w * rh / rw )); fi
    crop=(-gravity center -crop "${cw}x${ch}+0+0" +repage)
fi
magick "$tmp/paleta.png" "${crop[@]}" -resize 'x1080>' -modulate 85 "$tmp/tamna.png"

# 3. desna trećina prelazi iz providnog u koru
read -r w h < <(magick identify -format '%w %h' "$tmp/tamna.png")
magick "$tmp/tamna.png" \
    \( -size "$(( w / 3 ))x$h" -define gradient:direction=east "gradient:${kora}00-${kora}" \) \
    -gravity east -composite -quality 90 "$out"

echo "$out"
