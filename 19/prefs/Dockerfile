# First stage: Runs JLink to create the custom JRE
FROM openjdk:19-slim-buster AS builder

RUN ["jlink", "--compress=2", "--module-path", \
     "$JAVA_HOME/jmods/", "--add-modules", \
     "java.base,java.prefs", \
     "--no-header-files", "--no-man-pages", "--strip-java-debug-attributes", "--output", "/opt/runtime"]

# Second stage: Copies the custom Java RuntimeImage into a bare alpine
FROM debian:buster-slim

RUN mkdir -p /usr/local/openjdk-19

COPY --from=builder /opt/runtime /usr/local/openjdk-19
ENV JAVA_HOME=/usr/local/openjdk-19 \
    PATH=${PATH}:/usr/local/openjdk-19/bin