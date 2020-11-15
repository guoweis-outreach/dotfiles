# Load supplementary scripts
source ~/.bashrc.d/variables.bash
source ~/.bashrc.d/path.bash
source ~/.bashrc.d/aliases.bash
source ~/.bashrc.d/prompt.bash
source ~/.bashrc.d/utils.bash

source ~/.bashrc.local

# Outreach
source $HOME/.asdf/asdf.sh
source $OUTREACH_PROJECT_ROOT/dev-environment/voice/setup

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

# this line must be after the block above
source <(kubectl completion bash)
complete -C /usr/local/bin/kustomize kustomize

# find . -type f -name "*.go" | xargs sed -i '' 's/nolint:/nolint:gocritic,/g'

source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
PS1='$(kube_ps1)'$PS1

export PATH="$HOME/.poetry/bin:$PATH"
export NGROK_SUBDOMAIN=e76eb40729ab5670bcf3a5be0da8f4d9-guoweishieh
export NGROK_AUTH=1Z2VyY7hvaWjJAfXnombxcJO1tl_7KGT2u4fMyLmqrchaRjFt
export KUBECONFIG="$HOME/.kube/config:$HOME/.outreach/kubeconfig.yaml"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/guoweishieh/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/guoweishieh/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/guoweishieh/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/guoweishieh/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

