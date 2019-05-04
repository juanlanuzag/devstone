#!/bin/sh
EXTERNAL=1000
INTERNAL=1000
FILENAME_SEQ=resultsLI_seq_E1000_I1000.csv
FILENAME_CONC=resultsLI_conc_E1000_I1000.csv

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
                                 --int-cycles=${INTERNAL} 2> asdconc)
        echo "Running model seq W:${W} D:${D} TIME:${RESULT}"
        echo "${D},${W},${RESULT}" >> "$FILENAME_SEQ"

        RESULT=$(./cadmium-dynamic-conc-devstone   \
                         --kind=LI    \
                         --width=${W} \
                         --depth=${D} \
                         --ext-cycles=${EXTERNAL} \
                         --int-cycles=${INTERNAL} 2> asdconc)
        echo "Running model conc W:${W} D:${D} TIME:${RESULT}"
        echo "${D},${W},${RESULT}" >> "$FILENAME_CONC"
    done
done
