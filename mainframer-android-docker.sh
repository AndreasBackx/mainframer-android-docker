#!/bin/bash

set -e

COMMAND=$1

IMAGE_NAME="mainframer-android-docker"

function executeRemotely {
    if [ "$#" -ne 1 ]; then
        echo "A command must be passed to executeRemotely."
        exit 0
    fi

    BUILD_COMMAND=$1
    BUILD_COMMAND_SUCCESSFUL="false"

    echo "Running '$BUILD_COMMAND' on $REMOTE_MACHINE."
    echo ""

    set +e
    if ssh "$REMOTE_MACHINE" "echo 'set -e && cd '$PROJECT_DIR_ON_REMOTE_MACHINE' && echo \"$BUILD_COMMAND\" && echo "" && $BUILD_COMMAND' | bash" ; then
        BUILD_COMMAND_SUCCESSFUL="true"
    fi
    set -e
    echo ""

    if [ "$BUILD_COMMAND_SUCCESSFUL" == "true" ]; then
        echo "Execution done."
    else
        echo "Execution failed."
        exit 1
    fi
}

function build {
    TARGET_SDK_CONFIG_PROPERTY="android_target_sdk"
    BUILD_TOOLS_CONFIG_PROPERTY="android_build_tools"
    SDK_TOOLS_CONFIG_PROPERTY="android_sdk_tools"

    source ./mainframer-init.sh

    TARGET_SDK=$(readConfigProperty "$TARGET_SDK_CONFIG_PROPERTY")
    BUILD_TOOLS=$(readConfigProperty "$BUILD_TOOLS_CONFIG_PROPERTY")
    SDK_TOOLS=$(readConfigProperty "$SDK_TOOLS_CONFIG_PROPERTY")

    echo "Building..."
    echo "Target SDK:  $TARGET_SDK"
    echo "Build tools: $BUILD_TOOLS"
    echo "SDK tools:   $SDK_TOOLS"
    echo ""

    syncBeforeRemoteCommand
    executeRemotely "docker build -t $IMAGE_NAME . --build-arg ANDROID_TARGET_SDK=$TARGET_SDK --build-arg ANDROID_BUILD_TOOLS=$BUILD_TOOLS --build-arg ANDROID_SDK_TOOLS=$SDK_TOOLS"
}

function run {
    echo "Running"
    source ./mainframer-init.sh
    ./mainframer.sh "docker run -i --rm -v android:/root/.android -v sdk:/android-sdk-linux -v gradle:/root/.gradle -v $PROJECT_DIR_ON_REMOTE_MACHINE:/project:rw --name $IMAGE_NAME $IMAGE_NAME /project/gradlew ${@:2} -p /project"
}

function usage {
    echo "Usage: $0 {build|run}"
}


case "$COMMAND" in
        build)
            build $@
            exit 0
            ;;

        run)
            run $@
            exit 0
            ;;

        *)
            usage

esac

exit 1
