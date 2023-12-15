# homebrew
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"
export PATH="${HOME}/.cargo/bin:$PATH"  # rust binary installation path
# keg-only installs
export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"
export PATH="/usr/local/opt/icu4c/bin:/usr/local/opt/icu4c/sbin:$PATH"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/usr/local/opt/icu4c/lib/pkgconfig"
export PATH="/Library/TeX/texbin:$PATH"  # mactex binary installation path (brew cask install mactex)

# homebrew bash completion https://docs.brew.sh/Shell-Completion#configuring-completions-in-bash
if type brew &>/dev/null; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "$COMPLETION" ]] && source "$COMPLETION"
    done
  fi
fi

# iterm integration
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
# init zoxide (rust) when available
eval "$(zoxide init bash)" || true



# pyenv direnv

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(direnv hook bash)"
eval "$(pyenv virtualenv-init -)"
export PROMPT_COMMAND='_pyenv_virtualenv_hook;_direnv_hook;history -a;history -c;history -r'
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

pyenv activate vv311


# exports

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR='subl -w'
export CC="/usr/local/bin/gcc-8"
export CXX="/usr/local/bin/g++-8"
# export HOMEBREW_CC="/usr/local/bin/gcc-8"
# export HOMEBREW_CXX="/usr/local/bin/g++-8"
export GPG_TTY=$(tty)
export BASH_SILENCE_DEPRECATION_WARNING=1


# aliases

# iTerm hack
function cd {
  builtin cd "$@"
  if [ $ITERM_SESSION_ID ]; then
    echo -ne "\033];${PWD##*/}\007";
  fi
}

alias back='cd -'
alias ls='exa --all --group-directories-first --icons --level=2'  # default level for --tree
alias ll='ls --long --sort=age --git --time=modified --time-style=iso'
alias h='history | tail -n 25'
alias cls='printf "\033c"'
alias dff='icdiff --highlight --line-numbers --numlines=3'
alias gcc='gcc-8'
alias moji='git status && git add . && pre-commit && gitmoji -c'
alias git-summary='~/git/git-summary/git-summary'
alias s='subl'
alias sm='smerge'
alias xdg-open='open'
alias pyenvls='pyenv virtualenvs | grep --invert-match "/envs/"'
alias i="
python -c 'import autotime, ipdb, pandas, rich' || pip install -U ipython-autotime ipdb pandas rich ipython

ipython -i -c '
# just make sure to use escaped double quotes
import os, logging, numpy as np, pandas as pd
from pathlib import Path
here = Path(\".\").resolve()

from rich import pretty, print
pretty.install()

# set to WARNING by default
logging.basicConfig(level=logging.INFO, format=\"%(asctime)s:%(levelname)-7s %(filename)20s:%(lineno)-4d %(name)s:%(message)s\")
logger = logging.getLogger(__name__)

# hotreload imports on each prompt
%load_ext autoreload
%autoreload 2

# pip install ipython-autotime
%load_ext autotime
'"
export PYTHONBREAKPOINT=ipdb.set_trace



# bash_history

# global bash history https://unix.stackexchange.com/a/1292
# Avoid duplicates
export HISTCONTROL=ignoredups  #:erasedups
# After each command, append to the history file and reread it
# export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
export HISTSIZE=
export HISTFILESIZE=
export HISTTIMEFORMAT="[%F %T] "
export HISTFILE=~/.bash_eternal_history
# When the shell exits, append to the history file instead of overwriting it
shopt -s histverify  # https://unix.stackexchange.com/a/4082
shopt -s histappend

# prompt

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
PS1="⨊  𝕯𝓭𝓵:\[\033[36m\]\w\[\033[m\]$ "  # ⚛ ⨊ 𝓓𝔇𝒟ℓℒ㎗ 🍺 ℵ ∯ ∰ ∞
# add working dir to tab name https://gist.github.com/phette23/5270658
# superceded by https://iterm2.com/documentation-badges.html
#if [ $ITERM_SESSION_ID ]; then
#  export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND";
#fi


# functions

# https://stackoverflow.com/a/73108928/5511061
dockersize() { docker manifest inspect -v "$1" | jq -c 'if type == "array" then .[] else . end' |  jq -r '[ ( .Descriptor.platform | [ .os, .architecture, .variant, ."os.version" ] | del(..|nulls) | join("/") ), ( [ .SchemaV2Manifest.layers[].size ] | add ) ] | join(" ")' | numfmt --to iec --format '%.2f' --field 2 | sort | column -t ; }
export -f dockersize
clusterimages() { kubectl get po -A -o json | jq -cr '.items[].spec.containers[].image' | grep -o '^[^@]\+' | sort -u | xargs -I _ bash -c 'echo - _ && dockersize _' ; }
export -f clusterimages

export HIDESYS=1
alias kubetop="python ~/git/kubetop.py"
# https://gist.github.com/ddelange/24575a702a10c2cb6348c4c7f342e0eb
kubelogs() {
  # View logs as they come in (like in Rancher) using mktemp and less -r +F.
  # Use ctrl+c to detach from stream (enter scrolling mode)
  # Use shift+f to attach to bottom of stream
  # Use ? to perform a backward search (regex possible)
  # Use N or n to find resp. next or previous search match
  # Set KUBELOGS_MAX to change amount of previous lines to fetch before streaming
  # Set $KUBECONFIG to deviate from "$HOME/.kube/config"
  if [ $# -ne 2 ]; then
      echo "Usage: kubelogs <your-namespace> <podname-prefix>"
      return
  fi
  local namespace=$1
  local pod=$2
  local podname=`kubectl get pods --kubeconfig ${KUBECONFIG:-"$HOME/.kube/config"} --namespace ${namespace} -o wide | grep Running | grep -o -m 1 "^${pod}[a-zA-Z0-9\-]*\b"`
  if [[ ${podname} != ${pod}* ]]; then
      echo "Pod \"${pod}\" not found in namespace \"${namespace}\""
      return
  fi
  local tmpfile=`mktemp`
  local log_tail_lines=${KUBELOGS_MAX:-10000}
  local sleep_amount=$((7 + log_tail_lines / 20000))
  echo "kubectl logs --kubeconfig ${KUBECONFIG:-"$HOME/.kube/config"} --namespace ${namespace} --since 24h --tail ${log_tail_lines} -f ${podname} > ${tmpfile}"
  kubectl logs --kubeconfig ${KUBECONFIG:-"$HOME/.kube/config"} --namespace ${namespace} --since 24h --tail ${log_tail_lines} -f ${podname} > ${tmpfile} &
  local k8s_log_pid=$!
  echo "Waiting ${sleep_amount}s for logs to download"
  sleep ${sleep_amount} && less -rf +F ${tmpfile} && kill ${k8s_log_pid} && echo "kubectl logs pid ${k8s_log_pid} killed"
}
export -f kubelogs

kubebash() {
  # Execute a bash shell in a pod
  # Set $KUBECONFIG to deviate from "$HOME/.kube/config"
  if [ $# -ne 2 ]; then
      echo "Usage: kubebash <your-namespace> <podname-prefix>"
      return
  fi
  local namespace=$1
  local pod=$2
  local podname=`kubectl get pods --kubeconfig ${KUBECONFIG:-"$HOME/.kube/config"} --namespace ${namespace} -o wide | grep Running | grep -o -m 1 "^${pod}[a-zA-Z0-9\-]*\b"`
  if [[ ${podname} != ${pod}* ]]; then
      echo "Pod \"${pod}\" not found in namespace \"${namespace}\""
      return
  fi
  kubectl exec -ti --kubeconfig ${KUBECONFIG:-"$HOME/.kube/config"} --namespace ${namespace} ${podname} -- bash
}
export -f kubebash

kubebranch() {
  # View a list of current branch[es] deployed for namespace [+ pod]
  # Set $KUBECONFIG to deviate from "$HOME/.kube/config"
  if [ $# -gt 2 ]; then
    echo "Usage: kubebranch <your-namespace> [<partial-podname>]"
    return
  fi
  if [ $# -lt 1 ]; then
    echo "Usage: kubebranch <your-namespace> [<partial-podname>]"
    return
  fi
  local namespace=$1
  if [ $# -eq 2 ]; then
    local pod=$2
    local podname=`kubectl get pods --kubeconfig ${KUBECONFIG:-"$HOME/.kube/config"} --namespace ${namespace} -o wide | grep Running | grep -o -m 1 "^${pod}[a-zA-Z0-9\-]*\b"`
    if [[ ${podname} != ${pod}* ]]; then
        echo "Pod \"${pod}\" not found in namespace \"${namespace}\""
        return
    fi
    kubectl get deployments --kubeconfig ${KUBECONFIG:-"$HOME/.kube/config"} --namespace ${namespace} -o wide | sed -n '1!p' | awk '{print $1 "\t" $8}' | uniq | tr ":" "\t" | column  -t | grep ${pod}
  else
    kubectl get deployments --kubeconfig ${KUBECONFIG:-"$HOME/.kube/config"} --namespace ${namespace} -o wide | sed -n '1!p' | awk '{print $1 "\t" $8}' | uniq | tr ":" "\t" | column  -t
  fi
}
export -f kubebranch

# generate 3 safe random passwords with default length 42
# takes one argument (pw length)
generate_password() {
  local defaultsize=42
  ((test -n "${1:-$defaultsize}" && test "${1:-$defaultsize}" -ge 0) && \
  #  -y or --symbols
  #  Include at least one special symbol in the password
  #  -B or --ambiguous
  #  Don't include ambiguous characters in the password
  pwgen -s -N 3 -cnBy -r ";'\`\"\|\#\$\&" ${1:-$defaultsize}) 2>&-;
};

# run last modified py file in home directory
lastpy() {
  local targetdir="$(pwd)"
  local pypath=$(find ${targetdir} -name "*.py" -type f -print0 | xargs -0 /bin/ls -t | head -n 1)
  echo "Running ${pypath}" # or ${pypath// /\ } [replace " " by "\ "]
  echo ""
  python "${pypath}"
#  open -R "${pypath}" # reveal in Finder (Mac command)
}
