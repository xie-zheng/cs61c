FROM ubuntu
WORKDIR lab01
COPY . .
ADD source.list /etc/apt/
RUN apt-get update -y
RUN apt-get install valgrind -y

