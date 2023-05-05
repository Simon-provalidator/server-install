#!/bin/bash

chmod u+r+x ./config/config.sh

COSMOS=1
JUNO=2
SIFCHIAN=3
EVMOS=4
OSMOSIS=5
UMEE=6

# Select Chain
echo "What network you going to interact:"
echo "1. CosmosHub"
echo "2. Juno"
echo "3. Sifchian"
echo "4. Evmos"
echo "5. Osmosis"
echo "6. Umee"

read i

if [ {$i} == {$COSMOS} ]; then
    bash ./chians/cosmos_setting.sh
elif [ {$i} == {$JUNO} ]; then
    bash ./chians/juno_setting.sh
elif [ {$i} == {$SIFCHIAN} ]; then
    bash ./chians/sifchian_setting.sh
elif [ {$i} == {$EVMOS} ]; then
    bash ./chians/evmos_setting.sh
elif [ {$i} == {$OSMOSIS} ]; then
    bash ./chians/evmos_setting.sh
elif [ {$i} == {$UMEE} ]; then
    bash ./chians/umee_setting.sh
else
    echo "It's a chain that doesn't exist."
fi