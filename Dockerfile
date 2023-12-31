## Build Stage
FROM alpine:3.18.3 AS build

# Update and install build libs in Alpine
RUN apk update
RUN apk add --no-cache build-base cmake git

# Copy
WORKDIR /soulrinha

COPY src/ ./src/
COPY cmake ./cmake
COPY CMakeLists.txt .

# Build
WORKDIR /soulrinha/build

RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN cmake --build . --parallel 8

## Mount final image
FROM alpine:3.18.3

# Define Labels
LABEL maintainer="Marcos Paulo <marcos@soulfox.dev>"
LABEL description="Compiler/Interpreter to use in Rinha de Compilers, mediate by aripiprazole"

# Update and install libs to run mount final image
RUN apk update
RUN apk add --no-cache libstdc++

# Define User
RUN addgroup -S rinha && adduser -S rinha -G rinha
USER rinha

# Copy build
COPY --chown=rinha:rinha --from=build ./soulrinha/build/src/soulrinha /usr/local/bin
COPY --chown=rinha:rinha ./var/rinha /var/rinha

# Add to PATH
ENV PATH="${PATH}:/usr/local/bin/soulrinha"

# Define entrypoint
ENTRYPOINT [ "tail", "-f", "/dev/null" ]
