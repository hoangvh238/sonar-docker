FROM openjdk:17-jdk-slim

RUN apt update && apt install -y git unzip curl && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone --depth=1 -b branch-10.2 https://github.com/SonarSource/sonarqube.git

WORKDIR /opt/sonarqube

RUN ./gradlew build -x test

RUN mkdir /opt/sonarqube-build && \
    cp -r server/sonar-server/build/install/sonarqube/* /opt/sonarqube-build/

RUN curl -L -o /opt/sonarqube-build/extensions/plugins/sonarqube-community-branch-plugin.jar \
    https://github.com/mc1arke/sonarqube-community-branch-plugin/releases/download/1.15.0/sonarqube-community-branch-plugin-1.15.0.jar

WORKDIR /opt/sonarqube-build
CMD ["./bin/linux-x86-64/sonar.sh", "console"]
