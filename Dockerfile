FROM gocd/gocd-agent-ubuntu-16.04:v17.8.0

#INSTALL JAVA 8
# Install the python script required for "add-apt-repository"
RUN apt-get update && apt-get install -y software-properties-common

# Setup the openjdk 8 repo
RUN add-apt-repository ppa:openjdk-r/ppa

# Install java8
RUN apt-get update && apt-get install -y openjdk-8-jdk openjdk-8-doc openjdk-8-jre

# Setup JAVA_HOME, this is useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

#INSTALL MAVEN 3
ENV MAVEN_VERSION 3.3.9

RUN mkdir -p /usr/share/maven \
  && curl -fsSL http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | tar -xzC /usr/share/maven --strip-components=1 \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

# Add go user to the docker group
RUN groupadd -g 999 docker \
    && usermod -aG docker go

RUN echo "if [ -e /var/run/docker.sock ]; then sudo chown go:go /var/run/docker.sock; fi" >> /home/go/.bashrc
