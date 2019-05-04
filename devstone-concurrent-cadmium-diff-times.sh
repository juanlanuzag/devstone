#!/bin/sh
W=5
D=5
kind=HOmod
FILENAME_SEQ=resultados/exp2_results${kind}_seq_W${W}_D${D}.csv
FILENAME_CONC=resultados/exp2_results${kind}_conc_W${W}_D${D}.csv

cmake CMakeLists.txt
make

echo "EXTERNAL,INTERNAL,Time" > "$FILENAME_SEQ"
echo "EXTERNAL,INTERNAL,Time"> "$FILENAME_CONC"

# Here we generated models for Cadmium
for EXTERNAL in `seq 1 795500 1591003`; do  #1590000
	for INTERNAL in `seq 1 795500 1591003`; do
 		RESULT=$(./cadmium-dynamic-devstone   \
                                 --kind=${kind} \
                                 --width=${W} \
                                 --depth=${D} \
                                 --ext-cycles=${EXTERNAL} \
                                 --int-cycles=${INTERNAL})
        echo "Running model seq EXTERNAL:${EXTERNAL} INTERNAL:${INTERNAL} TIME:${RESULT}"
        echo "${EXTERNAL},${INTERNAL},${RESULT}" >> "$FILENAME_SEQ"

        RESULT=$(./cadmium-dynamic-conc-devstone   \
                         --kind=${kind} \
                         --width=${W} \
                         --depth=${D} \
                         --ext-cycles=${EXTERNAL} \
                         --int-cycles=${INTERNAL})
        echo "Running model conc EXTERNAL:${EXTERNAL} INTERNAL:${INTERNAL} TIME:${RESULT}"
        echo "${EXTERNAL},${INTERNAL},${RESULT}" >> "$FILENAME_CONC"
    done
done
