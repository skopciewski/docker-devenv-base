FROM alpine:3.10

RUN apk add --no-cache \
  ack \
  bash \
  curl \
  coreutils \
  git \
  grep \
  htop \
  jq \
  less \
  make \
  mc \
  ncdu \
  ncurses \
  openssh-client \
  ruby \
  sudo \
  tmux \
  tree \
  tzdata \
  util-linux \
  vim \
  zsh

ARG user=dev
ARG uid=1000
ARG gid=1000
ENV LANG=C.UTF-8
RUN echo 'export LANG="C.UTF-8"' > /etc/profile.d/lang.sh \
  && mv /etc/profile.d/color_prompt /etc/profile.d/color_prompt.sh \
  && addgroup -g ${gid} ${user} \
  && adduser -h /home/${user} -D -u ${uid} -G ${user} -s /bin/zsh ${user} \
  && echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" \
  && chmod 0440 "/etc/sudoers.d/${user}"

USER ${user}

ENV DEVDOTFILES_BASE_VER=1.0.8
RUN mkdir -p /home/${user}/opt \
  && cd /home/${user}/opt \
  && curl -fsSL https://github.com/skopciewski/dotfiles_base/archive/v${DEVDOTFILES_BASE_VER}.tar.gz | tar xz \
  && cd dotfiles_base-${DEVDOTFILES_BASE_VER} \
  && make

ENV DEVDOTFILES_VIM_VER=1.1.8
RUN mkdir -p /home/${user}/opt \
  && cd /home/${user}/opt \
  && curl -fsSL https://github.com/skopciewski/dotfiles_vim/archive/v${DEVDOTFILES_VIM_VER}.tar.gz | tar xz \
  && cd dotfiles_vim-${DEVDOTFILES_VIM_VER} \
  && make

ENV DEVDIR=/mnt/devdir
WORKDIR ${DEVDIR}
CMD ["/bin/zsh"]
