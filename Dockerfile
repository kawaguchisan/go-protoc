FROM golang:1.12.6-stretch

ENV GO111MODULE on

RUN apt-get update && apt-get install -y --no-install-recommends \
            autoconf=2.69-10 \
            automake=1:1.15-6 \
            libtool=2.4.6-2 \
            && rm -rf /var/lib/apt/lists/*

ENV PROTOBUF_VERSION 3.8.0
RUN wget -O /usr/local/src/protobuf.tar.gz "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protobuf-cpp-${PROTOBUF_VERSION}.tar.gz"
WORKDIR /usr/local/src
RUN tar xzf protobuf.tar.gz
WORKDIR /usr/local/src/protobuf-${PROTOBUF_VERSION}
RUN ./autogen.sh && ./configure && make && make install && ldconfig

ENV GO_PROTOBUF_VERSION 1.3.1
RUN git clone https://github.com/golang/protobuf /go/src/github.com/golang/protobuf
WORKDIR /go/src/github.com/golang/protobuf
RUN git checkout "v${GO_PROTOBUF_VERSION}"
RUN go install github.com/golang/protobuf/protoc-gen-go

ENV GRPC_GATEWAY_VERSION 1.9.2
RUN git clone https://github.com/grpc-ecosystem/grpc-gateway /go/src/github.com/grpc-ecosystem/grpc-gateway
WORKDIR /go/src/github.com/grpc-ecosystem/grpc-gateway
RUN git checkout "v${GRPC_GATEWAY_VERSION}"
RUN go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
RUN go install github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger

ENV GRPC_WEB_VERSION 1.0.4
RUN wget -O protoc-gen-grpc-web "https://github.com/grpc/grpc-web/releases/download/${GRPC_WEB_VERSION}/protoc-gen-grpc-web-${GRPC_WEB_VERSION}-linux-x86_64"
RUN mv protoc-gen-grpc-web /usr/local/bin/protoc-gen-grpc-web
RUN chmod +x /usr/local/bin/protoc-gen-grpc-web

RUN rm -rf /var/lib/apt/lists/* protobuf.tar.gz proto

