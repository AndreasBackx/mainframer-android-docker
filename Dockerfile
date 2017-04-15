FROM openjdk:8-jdk

ENV ANDROID_HOME=${PWD}/android-sdk-linux
ENV PATH=${PATH}:${ANDROID_HOME}/platform-tools

RUN apt-get --quiet update --yes && \
 apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 build-essential file usbutils openssh-client && \
 apt-get autoremove --yes && \
 apt-get clean && \
 rm -rf /var/lib/apt/lists/*

ARG ANDROID_TARGET_SDK
ARG ANDROID_BUILD_TOOLS
ARG ANDROID_SDK_TOOLS

RUN wget -nv --output-document=android-sdk.zip https://dl.google.com/android/repository/tools_r${ANDROID_SDK_TOOLS}-linux.zip && \
 unzip -qo android-sdk.zip -d android-sdk-linux && \
 rm android-sdk.zip && \
 mkdir -p ~/.gradle && \
 echo "org.gradle.daemon=false" >> ~/.gradle/gradle.properties && \
 echo y | ${ANDROID_HOME}/tools/android --silent update sdk --no-ui --all --filter android-${ANDROID_TARGET_SDK} && \
 echo y | ${ANDROID_HOME}/tools/android --silent update sdk --no-ui --all --filter platform-tools && \
 echo y | ${ANDROID_HOME}/tools/android --silent update sdk --no-ui --all --filter build-tools-${ANDROID_BUILD_TOOLS} && \
 mkdir -p ${ANDROID_HOME}/licenses/ && \
 echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > ${ANDROID_HOME}/licenses/android-sdk-license && \
 echo "84831b9409646a918e30573bab4c9c91346d8abd" > ${ANDROID_HOME}/licenses/android-sdk-preview-license
