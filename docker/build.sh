#!/bin/bash -x
#if [ ! -f ./env-run ]; then
#    cp -v ./default-env ./env-run
#fi

#source ./env-run

#docker build --no-cache --progress=plain -t ${IMAGE} .

#echo "Script execution complete. Press Enter to close."
#read

#docker image inspect --format='{{range $index, $value := .Config.Env}}{{printf "%s\n" $value}}{{end}}' ${IMAGE} | sed -e '/^$/d' > ./env-base

#!/bin/bash -x
if [ ! -f ./env-run ]; then
    cp -v ./default-env ./env-run
fi

source ./env-run

docker build --no-cache --progress=plain -t ${IMAGE} .

#echo "Script execution complete. Press Enter to close."
#read
#docker image inspect --format='{{range $index, $value := .Config.Env}}{{printf "%s\n" $value}}{{end}}' ${IMAGE} | sed -e '/^$/d' > ./env-base
echo "PATH=\"$PATH\"" >> ./env-base
   TMP_ENV_FILE="./env-base.tmp"

   # Generate environment variables from Docker image
   docker image inspect --format='{{range $index, $value := .Config.Env}}{{printf "%s\n" $value}}{{end}}' ${IMAGE} | sed -e '/^$/d' > $TMP_ENV_FILE

   # Add the current PATH to the temp file
   echo "PATH=\"$PATH\"" >> $TMP_ENV_FILE

   # Move the temporary file to the final env-base to avoid overwriting issues
   mv $TMP_ENV_FILE ./env-base