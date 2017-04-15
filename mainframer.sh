#!/bin/bash

# Copyright 2017 Juno, Inc.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

echo ":: mainframer v2.1.0"
echo ""

source ./mainframer-init.sh

REMOTE_COMMAND="$*"
REMOTE_COMMAND_SUCCESSFUL="false"

if [ -z "$REMOTE_COMMAND" ]; then
    echo "Please pass remote command."
    exit 1
fi

pushd "$PROJECT_DIR" > /dev/null

syncBeforeRemoteCommand
executeRemoteCommand
syncAfterRemoteCommand

popd > /dev/null

FINISH_TIME="$(date +%s)"
echo ""

DURATION="$((FINISH_TIME-START_TIME))"

if [ "$REMOTE_COMMAND_SUCCESSFUL" == "true" ]; then
    echo "Success: took $(formatTime $DURATION)."
else
    echo "Failure: took $(formatTime $DURATION)."
    exit 1
fi
