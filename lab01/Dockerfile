FROM ubuntu
WORKDIR code
ADD source.list /etc/apt/
RUN apt-get update -y
RUN apt-get install valgrind gcc make -y

