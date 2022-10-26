#!/usr/bin/env bash
set -e

# MODE=${MODE:-run}
# E2E=${E2E:-false}
# if [[ ${E2E} == true ]]; then
#   MODE="test"
# fi

# AVALANCHE_LOG_LEVEL=${AVALANCHE_LOG_LEVEL:-INFO}

# echo "Running with:"
# echo VERSION: ${VERSION}
# echo MODE: ${MODE}
# echo AVALANCHE_LOG_LEVEL: ${AVALANCHE_LOG_LEVEL}

############################
# download avalanchego
# https://github.com/ava-labs/avalanchego/releases
# GOARCH=$(go env GOARCH)
# GOOS=$(go env GOOS)
# DOWNLOAD_URL=https://github.com/ava-labs/avalanchego/releases/download/v${VERSION}/avalanchego-linux-${GOARCH}-v${VERSION}.tar.gz
# DOWNLOAD_PATH=/tmp/avalanchego.tar.gz
# if [[ ${GOOS} == "darwin" ]]; then
#   DOWNLOAD_URL=https://github.com/ava-labs/avalanchego/releases/download/v${VERSION}/avalanchego-macos-v${VERSION}.zip
#   DOWNLOAD_PATH=/tmp/avalanchego.zip
# fi

# rm -rf /tmp/avalanchego-v${VERSION}
# rm -f ${DOWNLOAD_PATH}

# echo "downloading avalanchego ${VERSION} at ${DOWNLOAD_URL}"
# curl -L ${DOWNLOAD_URL} -o ${DOWNLOAD_PATH}

# echo "extracting downloaded avalanchego"
# if [[ ${GOOS} == "linux" ]]; then
#   tar xzvf ${DOWNLOAD_PATH} -C /tmp
# elif [[ ${GOOS} == "darwin" ]]; then
#   unzip ${DOWNLOAD_PATH} -d /tmp/avalanchego-build
#   mv /tmp/avalanchego-build/build /tmp/avalanchego-v${VERSION}
# fi
# find /tmp/avalanchego-v${VERSION}

# AVALANCHEGO_PATH=/tmp/avalanchego-v${VERSION}/avalanchego
# AVALANCHEGO_PLUGIN_DIR=/tmp/avalanchego-v${VERSION}/plugins

#################################
# download avalanche-network-runner
# https://github.com/ava-labs/avalanche-network-runner
curl -sSfL https://raw.githubusercontent.com/ava-labs/avalanche-network-runner/main/scripts/install.sh | sh -s

#################################
# run "avalanche-network-runner" server
echo "launch avalanche-network-runner in the background"
~/bin/avalanche-network-runner \
server \
--log-level debug \
--port=":12342" \
--disable-grpc-gateway &

sleep 5

cd rosetta-cli-conf
ls

~/bin/avalanche-network-runner control start \
--log-level debug \
--endpoint="0.0.0.0:8080" \
--number-of-nodes=5 \
--avalanchego-path /Users/xiaying.peng@coinbase.com/src/public/avalanchego/build/avalanchego \
--global-node-config '{"chain-config-dir": "rosetta-cli-conf/cchain"}'


curl -X POST -k http://localhost:8081/v1/ping -d ''