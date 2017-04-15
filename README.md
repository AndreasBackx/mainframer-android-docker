# Mainframer Docker proof of concept

mainframer-android-docker is a proof of concept that shows how [mainframer](https://github.com/gojuno/mainframer) could be used with Docker. It makes it easy to run everything remotely with almost no setup required besides SSH and Docker.

This example is specifically made for Android. It can be easily changed in order to work for other build systems. Simply change the `Dockerfile` to what is required for a build and change the command passed to mainframer used in `mainframer-android-docker.sh`'s `run` function.

## Configuration

See [mainframer](https://github.com/gojuno/mainframer) for an explanation on how its configuration works. You need to add following settings to `.mainframer/config`:

```
android_target_sdk=25
android_build_tools=25.0.2
android_sdk_tools=25.2.5
```

> Note: Because of how the Dockerfile gets the Android SDK Tools version, version 25.2.5 seems to be the latest available version when using `https://dl.google.com/android/repository/tools_r${ANDROID_SDK_TOOLS}-linux.zip`. This needs to be resolved.

## Usage

### Build docker image

The Docker image needs to be built before you can get started. It also needs to be rebuilt every time the version of the target sdk, build tools, or sdk tools changes.

```
./mainframer-android-docker.sh build
```

### Run gradle

The `./mainframer-android-docker.sh run` command simply executes the Gradle wrapper in the container and passes it the arguments that were passed to the script.

```
./mainframer-android-docker.sh run TASK_NAME
```

Example:

```
./mainframer-android-docker.sh run :app:assembleDebug
```

## Thank you

A quick thank you to [Ian Thomas](https://github.com/toxicbakery) and [Eddie Ringle](https://github.com/eddieringle) for providing me with the Dockerfile.
