#!/bin/sh
# Datum na srpskom za hyprlock ("ponedeljak, 2. novembar"), bez oslanjanja na sr locale

dan=$(date +%u)    # 1 = ponedeljak
mesec=$(date +%-m)

set -- ponedeljak utorak sreda četvrtak petak subota nedelja
eval "dan_ime=\${$dan}"

set -- januar februar mart april maj jun jul avgust septembar oktobar novembar decembar
eval "mesec_ime=\${$mesec}"

echo "$dan_ime, $(date +%-d). $mesec_ime"
