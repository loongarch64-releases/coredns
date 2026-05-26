FROM lcr.loongnix.cn/library/golang:1.25

RUN apt-get update && apt-get install -y git tar jq && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

CMD ["/bin/bash"]


