FROM golang:latest AS gotty
RUN export GOOS=linux && export GOARCH=@@GO_ARCH@@ && go get github.com/yudai/gotty

FROM dmkif/gnucobol:@@ARCH@@-latest
MAINTAINER Daniel Mulzer <daniel.mulzer@fau.de>

WORKDIR /opt/cobol

COPY --from=gotty /go/bin/linux_@@GO_ARCH@@/gotty .

EXPOSE 8081

# Execute Gotty
#ENTRYPOINT ["./gotty"]
#Default arguments ...
#CMD ["--port","8081","--permit-write","/bin/bash"]

