FROM ubuntu:16.04
FROM python:3.6-slim

RUN apt-get update -y

# Install core softwares
RUN apt-get install -y --no-install-recommends sudo
RUN apt-get install -y --no-install-recommends openssl ca-certificates
RUN apt-get install -y --no-install-recommends zsh wget curl vim

# Prepare locale
RUN apt-get install -y --no-install-recommends locales
RUN locale-gen en_US.UTF-8
RUN locale-gen zh_CN.UTF-8

# Install packages for develop
# RUN apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Install core tools
RUN apt-get install -y --no-install-recommends git ctags
RUN apt-get install -y --no-install-recommends fonts-powerline

# Setup user
ARG USERNAME="harold"
ARG USERHOME="/home/harold"

RUN useradd --create-home --shell=/usr/bin/zsh --groups=sudo ${USERNAME}
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chsh -s $(which zsh) ${USERNAME}
USER ${USERNAME}
WORKDIR ${USERHOME}

# Install oh-my-zsh
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install vim configuration
RUN git clone --depth=1 https://github.com/haroldrandom/vimrc.git ~/.vim_runtime
RUN sh ~/.vim_runtime/install_basic_vimrc.sh

# Install pyenv
RUN curl https://pyenv.run | bash

# Overwrite with my zshrc
COPY --chown=${USERNAME}:${USERNAME} ./zshrc ${USERHOME}/.zshrc
CMD ["zsh"]
