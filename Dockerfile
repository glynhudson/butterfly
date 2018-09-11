FROM ubuntu:16.04

RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    build-essential \
    libffi-dev \
    libssl-dev \
    python-dev \
    python-setuptools \
    ca-certificates \
    nano \
    git-core \
    avrdude \
    miniterm \
    minicom \
 && easy_install pip \
 && pip install --upgrade setuptools \
 && pip install -U platformio \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*


ADD emonupload /root
ADD emonupload/requirements.txt /root/requirements.txt
RUN pip install --no-cache-dir -r /root/requirements.txt

WORKDIR /opt
ADD . /opt/app
WORKDIR /opt/app

RUN python setup.py build \
 && python setup.py install

ADD docker/run.sh /opt/run.sh

EXPOSE 57575

CMD ["butterfly.server.py", "--unsecure", "--host=0.0.0.0"]
ENTRYPOINT ["docker/run.sh"]
