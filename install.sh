#!/bin/sh

set -e

# Install Zsh and Oh My Zsh!
sudo apt-get install -y \
    zsh \
    curl

curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

# Install Oh My Zsh Plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


curl -L https://raw.githubusercontent.com/vitorhugoro1/dotfiles/master/.p10k.zsh | tee -a ~/.p10k.zsh
curl -L https://raw.githubusercontent.com/vitorhugoro1/dotfiles/master/aliases.sh | tee -a ~/aliases.sh
curl -L https://raw.githubusercontent.com/vitorhugoro1/dotfiles/master/.zshrc | tee -a ~/.zshrc

# Install Latest PHP
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

sudo apt install -y \
    php \
    php-common \
    php-mysql \
    php-pgsql \
    php-bcmath

sudo apt remove -y apache2


# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/local/bin/composer

