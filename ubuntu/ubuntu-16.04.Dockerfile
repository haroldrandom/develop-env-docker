FROM ubuntu:16.04

RUN apt-get update -y

##################################
# Install core softwares
##################################
RUN apt-get install -y --no-install-recommends sudo
RUN apt-get install -y --no-install-recommends dos2unix
RUN apt-get install -y --no-install-recommends openssl ca-certificates
RUN apt-get install -y --no-install-recommends zsh wget curl vim

##################################
# Prepare locale
##################################
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y --no-install-recommends locales
RUN locale-gen en_US.UTF-8
RUN locale-gen zh_CN.UTF-8

##################################
# Install packages for develop
##################################
RUN apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

##################################
# Install core tools
##################################
RUN apt-get install -y --no-install-recommends git ctags
RUN apt-get install -y --no-install-recommends fonts-powerline

##################################
# Setup user
##################################
ARG USERNAME="harold"
ARG USERHOME="/home/harold"

RUN useradd --create-home --shell=/usr/bin/zsh --groups=sudo ${USERNAME}
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER ${USERNAME}
ENV USER=${USERNAME}
WORKDIR ${USERHOME}

##################################
# Install oh-my-zsh
##################################
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

##################################
# Install vim configuration
##################################
RUN git clone --depth=1 https://github.com/haroldrandom/vimrc.git ~/.vim_runtime
RUN sh ~/.vim_runtime/install_basic_vimrc.sh

##################################
# Install pyenv and Python
##################################
RUN curl https://pyenv.run | bash
ENV PYENV_ROOT="${USERHOME}/.pyenv"
ENV PATH="${PYENV_ROOT}/bin:$PATH"
RUN pyenv install 3.5.9
RUN pyenv install 3.6.8
RUN pyenv install 3.7.4
RUN pyenv install 3.8.0

##################################
# Overwrite with my zshrc and activate oh-my-zsh config
##################################
COPY --chown=${USERNAME}:${USERNAME} ./zshrc ${USERHOME}/.zshrc
RUN dos2unix ${USERHOME}/.zshrc
CMD ["zsh"]
