# Path to your oh-my-zsh installation.
  export ZSH=/home/ktlee/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

# export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
setopt noincappendhistory
setopt nosharehistory

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR=vim

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias tocb="xclip -selection c"
alias wk="cd ~/workspace"
alias pg_rb="pg_ctl restart -l/tmp/log --mode=fast"
alias go14="ssh -p 10057 agens@27.117.163.21"
function put15 {
	scp -P10057 $@ ktlee@27.117.163.21:ktlee
}
alias go15="ssh -p 10058 ktlee@27.117.163.21"
function put15 {
	scp -P10058 $@ ktlee@27.117.163.21:download
}

#export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export JAVA_HOME=/home/ktlee/tools/jdk1.8.0_92
export NEO4J_HOME=~/tools/neo4j
export PG_HOME=~/tools/pgsql
export LD_LIBRARY_PATH=$PG_HOME/lib:$LD_LIBRARY_PATH
export PATH=~/bin:~/local/nodejs/bin:$PG_HOME/bin:$PATH:/usr/local/go/bin
export GOPATH=$(go env GOPATH)
export PATH=$PATH:$GOPATH/bin
export MANPATH=$PG_HOME/man:$MANPATH
export PGDATA=$PG_HOME/pg_data

ulimit -c unlimited
