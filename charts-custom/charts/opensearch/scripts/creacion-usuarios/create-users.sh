#!/bin/bash
# Purpose: Read Comma Separated CSV File
# Author: Vivek Gite under GPL v2.0+
# ------------------------------------------
ELASTIC=http://10.42.28.39:9200/_plugins/_security/api/internalusers
USER=admin
PASS=admin
INPUT=simple-usuarios.csv
OLDIFS=$IFS
IFS=','

url_encode() {
    [ $# -lt 1 ] && { return; }

    encodedurl="$1";

    # make sure hexdump exists, if not, just give back the url
    [ ! -x "/usr/bin/hexdump" ] && { return; }

    encodedurl=`
    echo $encodedurl | hexdump -v -e '1/1 "%02x\t"' -e '1/1 "%_c\n"' |
        LANG=C awk '
            $1 == "20"                    { printf("%s",   "+"); next } # space becomes plus
            $1 ~  /0[adAD]/               {                      next } # strip newlines
            $2 ~  /^[a-zA-Z0-9.*()\/-]$/  { printf("%s",   $2);  next } # pass through what we can
                                          { printf("%%%s", $1)        } # take hex value of everything else
    '`
    echo $encodedurl
    REPLY=$encodedurl
}

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

while read name email role uid
do
    #echo $ELASTIC/$( url_encode "$email" )    
	#curl -u $USER:$PASS -X PUT $ELASTIC/$( url_encode "$email" ) \
    #    -H "Content-Type: application/json" \
    #    --data-binary @- << EOF
    #    {
    #        "password": "123456",
    #        "backend_roles": ["$role"],
    #        "attributes": {
    #            "fullName": "$name"
    #        }
    #    }
#EOF

    echo PUT _plugins/_security/api/internalusers/$email
    echo {
    echo '   "password": "123456",'
    echo "   \"backend_roles\": [\"$role\"],"
    echo '   "attributes": {'
    echo "       \"fullName\": \"$name\""
    echo '   }'
    echo }
   
done < $INPUT

IFS=$OLDIFS