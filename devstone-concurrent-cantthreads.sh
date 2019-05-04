#!/bin/sh
W=100
D=5
kind=LI
INTERNAL=10000
EXTERNAL=10000
FILENAME_SEQ=resultados/exp3_results${kind}_seq_W${W}_D${D}_INT${INTERNAL}_EXT${EXTERNAL}.csv
FILENAME_CONC=resultados/exp3_results${kind}_conc_W${W}_D${D}_INT${INTERNAL}_EXT${EXTERNAL}.csv

cmake CMakeLists.txt
make

echo "threads,Time" > "$FILENAME_SEQ"
echo "threads,Time"> "$FILENAME_CONC"

# Here we generated models for Cadmium
RESULT=$(./cadmium-dynamic-devstone   \
                     --kind=${kind} \
                     --width=${W} \
                     --depth=${D} \
                     --ext-cycles=${EXTERNAL} \
                     --int-cycles=${INTERNAL})
echo "Running model seq TIME:${RESULT}"
echo "0,${RESULT}" >> "$FILENAME_SEQ"

for THREADS in `seq 0 1 16`; do
    RESULT=$(./cadmium-dynamic-conc-devstone   \
                     --kind=${kind} \
                     --width=${W} \
                     --depth=${D} \
                     --ext-cycles=${EXTERNAL} \
                     --int-cycles=${INTERNAL} \
                     --threads=${THREADS})
    echo "Running model conc THREADS:${THREADS} TIME:${RESULT}"
    echo "${THREADS},${RESULT}" >> "$FILENAME_CONC"
done
