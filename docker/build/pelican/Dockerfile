FROM centos
MAINTAINER wilful <wilful@srv-nix.com>

RUN yum install -y -q epel-release
RUN yum install -y -q python34-pip
RUN pip3 install --upgrade pip
RUN pip3 install pelican
RUN pip3 install markdown

CMD ["/bin/bash"]

