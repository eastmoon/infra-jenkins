# Declare variable
CACHE_DIR=/cache
SOURCE_DIR=/source

# Execute script
if [[ -d ${CACHE_DIR} && -d ${SOURCE_DIR} ]];
then
    echo "sync ${CACHE_DIR} to ${SOURCE_DIR}"
    if [ -e ${CACHE_DIR}/config.xml ];
    then
        while :
        do
            rsync -av --exclude=*/builds/ --include=config.xml --include=*/ --exclude=* -r ${CACHE_DIR}/jobs ${SOURCE_DIR}
            rsync -av --include=*.xml -r ${CACHE_DIR}/config.xml ${SOURCE_DIR}/config.xml
            sleep 1
        done
    fi
else
    echo "${CACHE_DIR} or ${SOURCE_DIR} is not exist"
fi
