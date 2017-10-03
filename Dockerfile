FROM ubuntu:16.04

LABEL maintainer "Michael Molchanov <mmolchanov@adyax.com>"

USER root

# Install base.
RUN apt-get update \
  && apt-get -y install \
  bash \
  build-essential \
  curl \
  openssl \
  procps \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Install Java, jmeter, plugins.
ENV JAVA_HOME /usr
ENV JMETER_VERSION 3.3
ENV JMETER_HOME=/apache-jmeter
RUN apt-get update \
  && apt-get -y install openjdk-8-jre-headless maven \
  && rm -rf /var/lib/apt/lists/* \
  && curl -o /apache-jmeter.tgz https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
  && tar -C / -xzf /apache-jmeter.tgz \
  && rm /apache-jmeter.tgz \
  && mv /apache-jmeter-${JMETER_VERSION} /apache-jmeter \
  && curl -L -o /apache-jmeter/lib/ext/jmeter-plugins-manager.jar -O https://jmeter-plugins.org/get/ \
  && curl -L -o /apache-jmeter/lib/cmdrunner-2.0.jar http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.0/cmdrunner-2.0.jar \
  && java -cp /apache-jmeter/lib/ext/jmeter-plugins-manager.jar org.jmeterplugins.repository.PluginManagerCMDInstaller \
  && chmod 777 /apache-jmeter \
  && chmod 777 /apache-jmeter/lib \
  && chmod 777 /apache-jmeter/lib/ext \
  && chmod +x /apache-jmeter/bin/PluginsManagerCMD.sh \
  && bash -l /apache-jmeter/bin/PluginsManagerCMD.sh available \
  && bash -l /apache-jmeter/bin/PluginsManagerCMD.sh install jpgc-standard

# Install Taurus.
RUN apt-get update \
  && apt-get -y install \
  libxslt1.1 \
  libxslt1-dev \
  libxml2 \
  libxml2-dev \
  python-pip \
  && rm -rf /var/lib/apt/lists/* \
  && pip install bzt

ENTRYPOINT ["bzt"]
