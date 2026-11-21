source ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh_plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Sheldon
# eval "$(sheldon source)"

# 外部コマンドの初期化出力をキャッシュ（exe が更新された時だけ再生成）
_cache_eval() {  # $1=名前 $2=exeパス $3...=コマンド
  local name=$1 exe=$2 cache=~/.cache/zsh/$1.zsh; shift 2
  if [[ -z $exe ]]; then return; fi
  if [[ ! -s $cache || $exe -nt $cache ]]; then
    mkdir -p ${cache:h}; "$@" >| $cache
  fi
  source $cache
}

# Starship
_cache_eval starship "$(command -v starship)" starship init zsh

# ---- 以下は既存の設定をそのまま移植 ----

# 履歴
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt share_history          # 複数セッション間で履歴を共有
setopt hist_ignore_dups       # 重複を記録しない
setopt hist_ignore_space      # スペース始まりは記録しない
IGNOREEOF=10

# 補完
# .zcompdump が24時間以上古い時だけフルチェック、それ以外は -C で高速起動
autoload -Uz compinit
if [[ -n ~/.zcompdump(N.mh+24) ]]; then compinit; else compinit -C; fi
zstyle ':completion:*' menu select

# labcode関数など既存のbash設定もここに移植
export PYTHONHASHSEED=0

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/zsh_completion" ] && \. "$NVM_DIR/zsh_completion"  # This loads nvm bash_completion

# --- uv ---
_cache_eval uv "$(command -v uv)" uv generate-shell-completion zsh

# --- エイリアス ---
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias vpnup='sudo nmcli connection up "dred" passwd-file ~/.vpn-secret'
alias vpndown='sudo nmcli connection down "dred"'

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

bindkey "^[[3;5~" kill-word
bindkey "^H" backward-kill-word

WORDCHARS=''

