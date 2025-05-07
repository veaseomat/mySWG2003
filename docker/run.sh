#!/bin/bash -x
#if [ ! -f ./env-run ]; then
#    cp -v ./default-env ./env-run
#fi

#source ./env-run

#docker build --no-cache --progress=plain -t ${IMAGE} .

#echo "Script execution complete. Press Enter to close."
#read
#docker image inspect --format='{{range $index, $value := .Config.Env}}{{printf "%s\n" $value}}{{end}}' ${IMAGE} | sed -e '/^$/d' > ./env-base
#echo "PATH=\"$PATH\"" >> ./env-base
   #TMP_ENV_FILE="./env-base.tmp"

   # Generate environment variables from Docker image
   #docker image inspect --format='{{range $index, $value := .Config.Env}}{{printf "%s\n" $value}}{{end}}' ${IMAGE} | sed -e '/^$/d' > $TMP_ENV_FILE

   # Add the current PATH to the temp file
   #echo "PATH=\"$PATH\"" >> $TMP_ENV_FILE

   # Move the temporary file to the final env-base to avoid overwriting issues
   #mv $TMP_ENV_FILE ./env-base



#!/bin/bash 
if [ ! -f ./env-run -a ! -f ./env-base ]; then
    echo "Run build.sh first."
    exit 1
fi


source ./env-run
source ./env-base

RUN_FORCE=false
RUN_KILL=false
    echo "Before While"
while [ $# -gt 0 ]
do
    case $1 in
        clean ) RUN_CLEAN=true; RUN_KILL=true ;;
        kill ) RUN_KILL=true ;;
    esac
    shift
done
    echo "After While"
if $RUN_KILL; then
    docker container kill ${GALAXY_NAME} || true
fi

if [ "$(docker inspect --format '{{.State.Status}}' ${GALAXY_NAME} 2> /dev/null)" = "running" ]; then
    echo "Container ${GALAXY_NAME} is already running."
    exit 100
fi

    echo "at set -x"
set -x
docker container rm ${GALAXY_NAME}

    echo "Before clean"
if $RUN_CLEAN; then
    docker volume rm swgemu-core3 || true
fi

    echo "Before docker run"
docker run -it \
    --name ${GALAXY_NAME} \
    --hostname ${GALAXY_NAME} \
    --cap-add=SYS_PTRACE \
    --restart=unless-stopped \
    --env-file env-base \
    --env-file env-run \
    -p ${SSHPORT}:${SSHPORT}/tcp \
    -p ${LOGINPORT}:${LOGINPORT}/udp \
    -p ${STATUSPORT}:${STATUSPORT}/tcp \
    -p ${PINGPORT}:${PINGPORT}/udp \
    -p ${ZONESERVERPORT}:${ZONESERVERPORT}/udp \
	-p 3306:3306 \
    -v shared-tre:/tre:ro \
    -v swgemu-core3:/home/swgemu \
    ${IMAGE}
	
	
echo "All setup steps completed successfully."
exit 0


#  # Debugging mode
#  set -x
#  # Print PATH variable
#  echo "Current PATH: $PATH"
#  # Check if docker is available
#  command -v docker || echo "Docker not found in PATH"

#echo "Script execution complete. Press Enter to close."
#read