#! /bin/bash

if [[ ! -e /usr/sbin/ioreg ]]; then
    echo "You're not running OSX." 2>&1
    exit 1
fi

batt_stat=`/usr/sbin/ioreg -c AppleSmartBattery`
if [[ $batt_stat != *"Capacity"* ]]; then
    # battery? what battery???
    echo "bat:N/A%"
else
    if [[ $batt_stat == *'"ExternalConnected" = Yes'* ]]; then
        pwr_src='chg'
    else
        pwr_src='bat'
    fi
    # print remaining battery life as a %
    numer_re='"CurrentCapacity" = ([0-9]*)'
    denom_re='"MaxCapacity" = ([0-9]*)'
    [[ $batt_stat =~ ${denom_re}.*$numer_re ]]
    denom=${BASH_REMATCH[1]}
    numer=${BASH_REMATCH[2]}
    pct=`echo $numer $denom | awk '{printf("%.1f\n", ($1 / $2) * 100)}'`
    echo "$pwr_src:$pct%"
fi

