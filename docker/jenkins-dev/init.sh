# Declare variable
CACHE_DIR=/cache
SOURCE_DIR=/source

# Execute script
if [[ -d ${CACHE_DIR} && -d ${SOURCE_DIR} ]];
then
    echo "init ${SOURCE_DIR} to ${CACHE_DIR}"
    cp ${SOURCE_DIR}/config.xml ${CACHE_DIR}/config.xml
    rsync -av --include=*.xml --include=*/ --exclude=* -r ${SOURCE_DIR}/jobs ${CACHE_DIR}
else
    echo "${CACHE_DIR} or ${SOURCE_DIR} is not exist"
fi
