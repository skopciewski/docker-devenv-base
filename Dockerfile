FROM alpine:edge

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk add --no-cache \
  ack \
  bash \
  coreutils \
  curl \
  git \
  grep \
  htop \
  hub@testing \
  jq \
  less \
  libnotify \
  make \
  mc \
  ncdu \
  ncurses \
  openssh-client \
  pypy3@testing \
  sudo \
  tmux \
  tree \
  tzdata \
  util-linux \
  vim \
  zsh \
  zsh-vcs

RUN /usr/bin/pypy3 -m ensurepip \
    && /usr/bin/pypy3 -m pip install tmuxp

ARG user=dev
ARG uid=1000
ARG gid=1000
ENV LANG=C.UTF-8
RUN echo 'export LANG="C.UTF-8"' > /etc/profile.d/lang.sh \
  && echo 'export PATH="/usr/lib/pypy/bin:$PATH"' > /etc/profile.d/pypy_path.sh \
  && mv /etc/profile.d/color_prompt.sh.disabled /etc/profile.d/color_prompt.sh \
  && addgroup -g ${gid} ${user} \
  && adduser -h /home/${user} -D -u ${uid} -G ${user} -s /bin/zsh ${user} \
  && echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" \
  && chmod 0440 "/etc/sudoers.d/${user}"

USER ${user}

ENV DEVDOTFILES_BASE_VER=1.4.3
RUN mkdir -p /home/${user}/opt \
  && cd /home/${user}/opt \
  && curl -fsSL https://github.com/skopciewski/dotfiles_base/archive/${DEVDOTFILES_BASE_VER}.tar.gz | tar xz \
  && cd dotfiles_base-${DEVDOTFILES_BASE_VER} \
  && make

RUN echo 'eval "$(_TMUXP_COMPLETE=zsh_source /usr/lib/pypy/bin/tmuxp)"' > /home/${user}/.zshrc_local_aliases/tmuxp.zshrc

ENV DEVDOTFILES_VIM_VER=1.6.4
RUN mkdir -p /home/${user}/opt \
  && cd /home/${user}/opt \
  && curl -fsSL https://github.com/skopciewski/dotfiles_vim/archive/${DEVDOTFILES_VIM_VER}.tar.gz | tar xz \
  && cd dotfiles_vim-${DEVDOTFILES_VIM_VER} \
  && make

COPY --chown=${user}:${user} data/tmux.zshrc /home/${user}/.zshrc_local_conf/

ENV DEVDIR=/mnt/devdir
WORKDIR ${DEVDIR}
CMD ["/bin/zsh"]
