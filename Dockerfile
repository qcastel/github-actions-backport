FROM qcastel/maven-git-gpg:latest

RUN apt-get install -y jq
COPY ./backport.sh /usr/local/bin
