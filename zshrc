# ConZoomerShellConfig
## 2026-01-31

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Global Vars
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="ghostty"
export TERM="xterm-ghostty"
export BROWSER="brave"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

#export PATH="$GOPATH:/opt/homebrew/bin:$HOME/.composer/vendor/bin:$HOME/.local/bin/scripts:$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/packages:/opt/homebrew/bin:$HOME/.composer/vendor/bin:$HOME/.local/bin/scripts:$HOME/.local/bin:$PATH"

# ~/ Home Dir Clean-up
#export XDG_DATA_HOME="$HOME/Library"
#export XDG_CACHE_HOME="$XDG_DATA_HOME/Caches"
#export XDG_CONFIG_HOME="$XDG_DATA_HOME/Preferences"
#export WGETRC="$HOME/.config/wget/wgetrc"
#export CARGO_HOME="$XDG_DATA_HOME/cargo"
#export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
#export GNUPGHOME="$XDG_DATA_HOME/gnupg"
#export NPM_CONFIG_USERCONFIG="$HOME/npm/npmrc"
#export ZDOTDIR="$HOME/.config/zsh"
#export JAVA_HOME=$(/usr/bin/java)
#export GOPATH="$HOME/projects/go"

# History Configuration
export HISTSIZE=1000000
export HISTFILE="$HOME/.config/zsh/zsh_history"
export LESSHISTFILE="-" #LESSHISTFILE='/dev/null'
export SAVEHIST=1000000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
alias history="history 0"     # force zsh to show the complete history
#setopt share_history         # share command history data

# Other program settings:
export LESS=-R
export MANPAGER="sh -c 'col -bx | bat -l man -p'" #MANPAGER="nvim -c 'set ft=man' -"
export FZF_DEFAULT_OPTS="
  --layout=reverse --height 40% --border
"

# ZShell Options
autoload -U colors && colors # Load colors
setopt autocd                # autocd into dirs
setopt correct               # auto correct mistakes
setopt interactive_comments  # allow comments in interactive mode
setopt magicequalsubst       # enable filename expansion fron args 'anything=expression'
setopt nonomatch             # hide error message if the is no match for pattern
setopt notify                # repoty the status of background jobs immediately
setopt numericglobsort       # sort filename numerically when it makes sence
setopt promptsubst           # enable command substitution in prompt
setopt vi                    # vi mode

# Aliases
alias\
  g='git'\
  la='eza -al'\
  lg='lazygit'\
  ls='eza --group-directories-first'\
  l='ls'\
  vim='nvim'\
  v='vim'\
  vimdiff='v -d'\
  artisan='php artisan'\
  tinker='artisan tinker'\
  wget='wget --hsts-file /dev/null'\
  rm='echo "This is not the command you are looking for."; false'\
  tm='tmux a'\
  t='tm'\
  pest='vendor/bin/pest'\
  p="pest"\
  files="yazi"\
  f="files"

# alias -g\
#   a="add"\
#   aa="add ."\
#   c="commit"\
#   p="push"\
#   s="status"

# Helper Funcs
a_tar           () { tar -cf $1 $2                                 }
commit          () { git commit -m "$1"                            }
crop_to_content () { convert $1 -flatten -fuzz 1% -trim +repage $2 }
cs_mp4          () { ffmpeg -i $1 -vcodec libx265 -crf 28 $2       }
cs_zip          () { zip -r "$1.zip" $1                            }
fcd             () { cd "$(find ~/projects/ ~/.local/share/ ~/.config /Applications | fzf)" }
fedit           () { fzf | xargs -r -I % $EDITOR %                 }
flush_dns       () { sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder }
fopen           () { fzf | xargs -r -I % open %                    }
fss             () { find ~/projects/ ~/.local/share/ ~/.config | fzf | xargs -r $EDITOR }
gen_passwd      () { gpg --gen-random --armor 1 "${1:-12}" }
git_ls_origin   () { git remote show origin  } # or git config --get remote.origin.url, or git remote show [remote-name] command
rm_ds           () { find $1 -name ".DS_Store" -type f -delete }

# Tab Completion
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hiddens

# File manager additions (yazi)
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# ZShell Extensions
source ~/.local/share/zsh-plugins/zsh-completions/zsh-completions.plugin.zsh
source ~/.local/share/zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.local/share/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source ~/.local/share/zsh-plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.local/share/zsh-plugins/wakatime-zsh/wakatime.plugin.zsh
fpath=(~/.local/share/zsh-plugins/zsh-completions/src $fpath)
eval "$(zoxide init --cmd cd zsh)"
eval "$(tirith init)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
