FROM alpine:3.6

RUN apk add --no-cache \
  bash \
  curl \
  git \
  htop \
  jq \
  make \
  mc \
  ncdu \
  ncurses \
  openssh-client \
  ruby \
  sudo \
  tmux \
  tree \
  zsh 

ARG user=dev
ARG uid=1000
ARG gid=1000
RUN addgroup -g ${gid} ${user} \
  && adduser -h /home/${user} -D -u ${uid} -G ${user} -s /bin/zsh ${user} \
  && echo "${user} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${user}" \
  && chmod 0440 "/etc/sudoers.d/${user}"

USER ${user}

ENV DEVDOTFILES_VER=1.0.4
RUN mkdir -p /home/${user}/opt \
  && cd /home/${user}/opt \
  && curl -fsSL https://github.com/skopciewski/dotfiles_base/archive/v${DEVDOTFILES_VER}.tar.gz | tar xz \
  && cd dotfiles_base-${DEVDOTFILES_VER} \
  && make

ENV DEVDIR=/mnt/devdir
WORKDIR ${DEVDIR}
CMD ["/bin/zsh"]
