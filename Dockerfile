FROM alpine:3.24@sha256:a2d49ea686c2adfe3c992e47dc3b5e7fa6e6b5055609400dc2acaeb241c829f4 AS builder

RUN apk add --no-cache curl ca-certificates fontconfig unzip

# Pandoc 3.9.0.2
COPY --from=pandoc/minimal:3.9.0.2@sha256:3dd01a498ef353594bd97620d667950c25e4131d15057310d79a97bf71f7a6de \
  /usr/local/bin/pandoc /usr/local/bin/pandoc

# Typst 0.14.2
RUN curl -fsSL \
      "https://github.com/typst/typst/releases/download/v0.14.2/typst-x86_64-unknown-linux-musl.tar.xz" \
    | tar -xJ --strip-components=1 -C /usr/local/bin \
      "typst-x86_64-unknown-linux-musl/typst"

# STIX Two Text 2.13b171
RUN mkdir -p /fonts/stix /tmp/stix \
    && curl -fsSL \
      "https://github.com/stipub/stixfonts/archive/refs/tags/v2.13b171.tar.gz" \
    | tar -xz -C /tmp/stix --strip-components=1 \
    && find /tmp/stix -name 'STIXTwoText-*.otf' -exec cp {} /fonts/stix/ \;

# Iosevka 34.6.1
RUN mkdir -p /fonts/iosevka \
    && curl -fsSL \
      "https://github.com/be5invis/Iosevka/releases/download/v34.6.1/PkgTTF-Iosevka-34.6.1.zip" \
      -o /tmp/iosevka.zip \
    && unzip -q /tmp/iosevka.zip 'Iosevka-Regular.ttf' -d /fonts/iosevka


FROM alpine:3.24@sha256:a2d49ea686c2adfe3c992e47dc3b5e7fa6e6b5055609400dc2acaeb241c829f4

RUN apk add --no-cache make fontconfig

COPY --from=builder /usr/local/bin/pandoc  /usr/local/bin/pandoc
COPY --from=builder /usr/local/bin/typst   /usr/local/bin/typst
COPY --from=builder /fonts                 /usr/share/fonts

RUN fc-cache -f

WORKDIR /work
