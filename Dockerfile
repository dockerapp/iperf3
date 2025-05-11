FROM    alpine:3.21 AS builder

ARG     IPERF3_VERSION=3.18

WORKDIR /iperf

RUN     apk add --no-cache \
            clang \
            git \
            make \
        && git clone https://github.com/esnet/iperf.git --branch ${IPERF3_VERSION} --single-branch . \
        && ./configure --enable-static "LDFLAGS=--static" --disable-shared \
        && make

RUN     rm -rf /tmp/*


FROM    scratch

COPY    --from=builder /iperf/src/iperf3 /iperf3
COPY    --from=builder /tmp /tmp

ENTRYPOINT ["/iperf3"]
