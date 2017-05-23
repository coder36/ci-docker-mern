from    ubuntu:16.04
run 	rm /bin/sh && ln -s /bin/bash /bin/sh
run     apt-get update

# make sure the package repository is up to date
run		echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
run     apt-get update
run		apt-get install -y unzip wget curl git lsb-release

# Install vnc, xvfb in order to create a 'fake' display and firefox
run		apt-get install -y --allow-unauthenticated google-chrome-stable
run     apt-get install -y x11vnc xvfb

run     mkdir ~/.vnc
# Setup a password
run     x11vnc -storepasswd 1234 ~/.vnc/passwd

ENV DISPLAY :99

# Install Xvfb init script
ADD xvfb_init /etc/init.d/xvfb
RUN chmod a+x /etc/init.d/xvfb
ADD xvfb-daemon-run /usr/bin/xvfb-daemon-run
RUN chmod a+x /usr/bin/xvfb-daemon-run

# Allow root to execute Google Chrome by replacing launch script
ADD google-chrome-launcher /usr/bin/google-chrome
RUN chmod a+x /usr/bin/google-chrome


run		wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
run		wget http://chromedriver.storage.googleapis.com/2.29/chromedriver_linux64.zip
run		unzip chromedriver_linux64.zip
run		chmod +x chromedriver
run		mv -f chromedriver /usr/local/share/chromedriver
run		ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver
run		ln -s /usr/local/share/chromedriver /usr/bin/chromedriver


# RVM
run		gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
run		curl -sSL https://get.rvm.io | bash -s stable


RUN 	/bin/bash -l -c rvm requirements
ENV 	PATH $PATH:/usr/local/rvm/bin
run		source /usr/local/rvm/scripts/rvm
run		rvm install 2.4.1
RUN 	echo "source /usr/local/rvm/scripts/rvm" >> /root/.bash_profile
RUN 	echo "rvm --default use 2.4.1" >> /root/.bash_profile
run			/bin/bash -l -c	rvm --default use 2.4.1

# NVM
run		wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
run 	tail -2 /root/.bashrc >> /root/.bash_profile
run		/bin/bash -l -c	"nvm install 7.9.0"
run     /bin/bash -l -c	"npm i npm-run -g"

RUN     apt-get install apt-transport-https
RUN     curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN     echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN     apt-get update && apt-get install -y yarn

# Mongo
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
RUN echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN apt-get update
RUN apt-get install -y mongodb-org
RUN mkdir -p /data/db

ENTRYPOINT /bin/bash -l
