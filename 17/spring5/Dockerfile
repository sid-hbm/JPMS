# First stage: Runs JLink to create the custom JRE
FROM openjdk:17-alpine AS builder

RUN ["jlink", "--compress=2", "--module-path", \
     "$JAVA_HOME/jmods/", "--add-modules", \
     "java.base,java.logging,java.management,java.security.jgss,java.naming,java.instrument,java.desktop,jdk.unsupported", \
     "--no-header-files", "--no-man-pages", "--strip-java-debug-attributes", "--output", "/opt/runtime"]

# Second stage: Copies the custom Java RuntimeImage into a bare alpine
FROM alpine:3.15

RUN mkdir -p /opt/jdk

COPY --from=builder /opt/runtime /opt/jdk
ENV JAVA_HOME=/opt/jdk \
    PATH=${PATH}:/opt/jdk/bin