#!/bin/sh
EXTERNAL=2
INTERNAL=10
FILENAME_SEQ=resultsLI_seq_E2_I2.csv
FILENAME_CONC=resultsLI_conc_E2_I2.csv

cmake CMakeLists.txt
make

echo "D,W,Time" > "$FILENAME_SEQ"
echo "D,W,Time"> "$FILENAME_CONC"

# Here we generated models for Cadmium
for D in `seq 5 5 11`; do
	for W in `seq 5 10 101`; do
 		RESULT=$(./cadmium-dynamic-devstone   \
                                 --kind=LI    \
                                 --width=${W} \
                                 --depth=${D} \
                                 --ext-cycles=${EXTERNAL} \
                                 --int-cycles=${INTERNAL})
        echo "Running model seq W:${W} D:${D} TIME:${RESULT}"
        echo "${D},${W},${RESULT}" >> "$FILENAME_SEQ"

        RESULT=$(./cadmium-dynamic-conc-devstone   \
                         --kind=LI    \
                         --width=${W} \
                         --depth=${D} \
                         --ext-cycles=${EXTERNAL} \
                         --int-cycles=${INTERNAL})
        echo "Running model conc W:${W} D:${D} TIME:${RESULT}"
        echo "${D},${W},${RESULT}" >> "$FILENAME_CONC"
    done
done
