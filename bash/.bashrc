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
