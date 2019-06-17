FROM ubuntu:18.04

RUN apt-get update \
    && apt install -y curl wget \
    && apt-get install -y sudo software-properties-common \
    && apt-get install -y git \
    && apt-get install -y nano

RUN echo 'Creating user: developer' \
    && mkdir -p /home/developer \
    && echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd \
    && echo "developer:x:1000:" >> /etc/group \
    && sudo echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer \
    && sudo chmod 0440 /etc/sudoers.d/developer \
    && sudo chown developer:developer -R /home/developer \
	&& sudo chown root:root /usr/bin/sudo \
	&& chmod 4755 /usr/bin/sudo

RUN sudo chown developer:developer -R /home/developer

RUN sudo dpkg --add-architecture i386 \
	&& sudo apt update \
	&& sudo apt install -y libgtk-3-0:i386 libidn11:i386 libglu1-mesa:i386 \
	&& sudo apt install -y libxrender1 libxtst6 libxi6 \
	&& sudo apt install -y libxrender1:i386 libxtst6:i386 libxi6:i386 libgtk2.0-0:i386

# install node 11
RUN curl -sL https://deb.nodesource.com/setup_11.x | sudo -E bash - \
    && sudo apt-get install -y nodejs

# install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
    && sudo apt update && sudo apt install -y yarn

# install other tools
RUN sudo npm install -g sass \
    && sudo npm install -g typescript \
    && sudo npm install -g @angular/cli \
    && sudo npm install -g ionic cordova \
    && sudo npm install -g firebase-tools \
    && sudo npm install -g http-server

USER developer
WORKDIR /home/developer

