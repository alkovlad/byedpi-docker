FROM alpine:latest AS build

        RUN apk update && apk add --no-cache \
            git \
            build-base \
            openssl-dev \
            libpcap-dev \
            linux-headers \
            musl-dev

        RUN git clone https://github.com/hufrea/byedpi /opt/byedpi
        RUN git clone https://github.com/tiernano/transocks_ev /opt/transocks_ev
        WORKDIR /opt/byedpi
        RUN make
        WORKDIR /opt/transocks_ev
        RUN make
        
        FROM alpine:latest

        COPY --from=build /opt /opt
        EXPOSE 1080

        ENTRYPOINT ["/opt/byedpi/ciadpi"]
