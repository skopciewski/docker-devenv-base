# Autostart tmuxp or tmux
if [[ ! -z "$ZSH_TMUXP_AUTOSTART" ]]; then
  ZSH_TMUX_AUTOSTART=false
else
  ZSH_TMUX_AUTOSTART=true
fi
ZSH_TMUX_AUTOSTART_ONCE=true
ZSH_TMUX_AUTOCONNECT=false
ZSH_TMUX_AUTOQUIT=false
ZSH_TMUX_FIXTERM=false

# Autostart if not already in tmux and enabled.
if [[ -z "$TMUX" && ! -z "$ZSH_TMUXP_AUTOSTART" && -z "$INSIDE_EMACS" && -z "$EMACS" && -z "$VIM" ]]; then
  # Actually don't autostart if we already did and multiple autostarts are disabled.
  if [[ "$ZSH_TMUX_AUTOSTART_ONCE" == "false" || "$ZSH_TMUX_AUTOSTARTED" != "true" ]]; then
    export ZSH_TMUX_AUTOSTARTED=true
    /usr/lib/pypy/bin/tmuxp load $ZSH_TMUXP_AUTOSTART
  fi
fi
