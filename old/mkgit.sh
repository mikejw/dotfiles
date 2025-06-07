#/bin/bash

export BASE=/var/git

if [ "$1" != "" ]; then

    export DIR=${BASE}/${1}
    if [ ! -d "$DIR" ]; then
        echo $DIR
        
        mkdir -p /var/git/${1}
        cd ${DIR}
        git init --bare
        cd ../
        chown -R www-data:www-data .
        chmod -R 777 .
        echo "Done."
    fi    
fi



