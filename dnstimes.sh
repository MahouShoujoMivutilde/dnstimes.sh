#!/usr/bin/env sh

__plot='
# set terminal dumb

binwidth=5
bin(x,width)=width*floor(x/width)

set style fill solid 0.5

plot times using (bin($1,binwidth)):(1.0) smooth freq w boxes lc rgb"green" notitle
pause -1
'

__usage="
dnstimes.sh:
-----------
    ... your.dns.sever domains.txt [port] - measure latency per domain, print results
    ... -t dtimes.txt                     - print average and standard deviation
                                            for given output of previous run
    ... -p dtimes.txt                     - plot a histogram with gnuplot for it
"


case "$1" in
    *h|*help)
        echo "$__usage"
        ;;
    *t)
        avg=$(awk '{sum += $2} END {print sum/NR}' $2)
        std=$(awk "{sum += (\$2 - $avg)^2} END {print sqrt(sum/NR)}" $2)
        echo -e "avg: $avg" "\nstd: $std"
        ;;
    *p)
        plg="$(mktemp --suffix=.plg)"
        echo "$__plot" > "$plg"

        times="$(mktemp --suffix=.times)"
        awk '{print $2}' $2 > "$times"

        gnuplot -e "times='$times'" "$plg"
        rm -f $plg $times
        ;;
    *)
        [ -z $3 ] && set -- $1 $2 53

        for i in $(cat $2); do
            t=$(drill @$1 -p $3 "$i" |
                grep -Eo 'Query time: [0-9]+ msec' |
                awk '{print $3}');
            echo "$i" "$t"
        done
esac
