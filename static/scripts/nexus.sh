URL='nex.nightfall.city/'
LINK=/
while [ -n "$LINK" ]
do
    HOST=${URL%%/*}
    QUERY=${URL#*/}
    PAGE=$(mktemp nexpage.XXXX)
    echo /$QUERY |nc $HOST 1900 > $PAGE
    clear
    echo "=> nex://$URL <="
    if grep 'text\|empty' <(file -i $PAGE) >/dev/null
    then
        cat $PAGE
        if [ $(tput lines) -lt $(wc -l < $PAGE) ]
        then
            less $PAGE
        fi
    else
        file -i $PAGE
        xdg-open $PAGE
    fi
    unset LINK
    select LINK in . .. $(grep '^=>' $PAGE|cut -d' ' -f 2)
    do
        if [[ ! ( $REPLY =~ ^[0-9]+$ ) ]]
        then
            LINK=$REPLY
        fi
        case $LINK in
            nex://*/)
                URL=${LINK:6}
            ;;
            nex://*)
                URL=${LINK:6}/
            ;;
            .)
                URL=${URL%/*}/
            ;;
            ..)
                URL=${URL%/*/}/
            ;;
            *)
                URL=${URL%/*}/${LINK}
            ;;
        esac
        break
    done
    rm $PAGE
done
