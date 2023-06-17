URL='nex.nightfall.city/'
LINK=/
while [ -n "$LINK" ]
do
    HOST=${URL%%/*}
    QUERY=${URL#*/}
    PAGE=$(mktemp nexpage.XXXX.txt)
    echo /$QUERY |nc $HOST 1900 > $PAGE
    clear
    echo "=> nex://$URL <="
    cat $PAGE
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
