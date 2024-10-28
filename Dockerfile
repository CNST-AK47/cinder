FROM ubuntu:22.04


RUN apt install -y openssh-server vim git net-tools bridge-utils && \
    sudo useradd -s /bin/bash -d /opt/stack -m stack &&  \
    echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack

USER stack
 
# 安装openstack
RUN cd ~ \
    git clone https://github.com/openstack/devstack.git && \
    cd devstack/ && \
    git checkout stable/zed && \
    RUN cat > local.conf << EOF \
    [[local|localrc]] \
    ADMIN_PASSWORD=secretone \
    DATABASE_PASSWORD=$ADMIN_PASSWORD \
    RABBIT_PASSWORD=$ADMIN_PASSWORD \
    SERVICE_PASSWORD=$ADMIN_PASSWORD \
    EOF &&  ./stack.sh\

EXPOSE 3306
