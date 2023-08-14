FROM amazonlinux:2

RUN yum install -y gcc openssl-devel bzip2-devel libffi-devel wget zip tar gzip make && \
    cd /opt && \
    wget https://www.python.org/ftp/python/3.9.6/Python-3.9.6.tgz && \
    tar xzf Python-3.9.6.tgz && \
    /opt/Python-3.9.6/configure --enable-optimizations && \
    make altinstall && \
    rm -f /opt/Python-3.9.6.tgz && \
    python3.9 -m pip install --upgrade pip