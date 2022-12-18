FROM golang:1.19.1-buster as go-target
RUN apt-get update && apt-get install -y wget
ADD . /go-mp4
WORKDIR /go-mp4/mp4tool
RUN go build
RUN wget https://github.com/strongcourage/fuzzing-corpus/raw/master/mp4/h264-aac-publicdomain-sample.mp4
RUN wget https://github.com/strongcourage/fuzzing-corpus/raw/master/mp4/mozilla/A4.mp4
RUN wget https://github.com/strongcourage/fuzzing-corpus/raw/master/mp4/mozilla/aac-sample.mp4


FROM golang:1.19.1-buster
COPY --from=go-target /go-mp4/mp4tool/mp4tool /
COPY --from=go-target /go-mp4/mp4tool/*.mp4 /testsuite/

ENTRYPOINT []
CMD ["/mp4tool", "dump", "@@"]
