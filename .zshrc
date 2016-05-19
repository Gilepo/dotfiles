#zgen
# load zgen
source "${HOME}/.zgen/zgen.zsh"
# if the init scipt doesn't exist
if ! zgen saved; then
  echo "Creating a zgen save"
######Modules

##    zgen load  /home/larry/.zprezto/modules/history
    zgen load sorin-ionescu/prezto modules/history
    zgen load zsh-users/zsh-syntax-highlighting 
    zgen load zsh-users/zsh-history-substring-search
    zgen load RobSis/zsh-completion-generator
    #zgen load djui/alias-tips
    zgen load joel-porquet/zsh-dircolors-solarized.git
    zgen load chrissicool/zsh-256color
    zgen load zsh-users/zsh-autosuggestions
     
     #Themes
    zgen oh-my-zsh themes/steeef 
    #Example
    #zgen load /path/to/super-secret-private-plugin
    zgen save
    #IDN if this will work but running solrized setup command here after zgen got the plugin should do the trick
    setupsolarized dircolors.256dark
fi

# this allows for History Substring Search 
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down


##Corrections, #of errors #add colors # menu selection if more then 5 options
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select=5



zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

#zstyle ':completion:*:*:ps:*:processes' list-colors ${(s.:.)LS_COLORS}

#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,user,cputime,cmd'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:pkill:*' menu yes select

#zmodload -i zsh/complist


cdc() { 
  for fn in "$@"; do 
    source-highlight --out-format=esc -o STDOUT -i $fn 2>/dev/null || /bin/cat $fn;
  done 
}


#setopt correct

#
#autoload -U compinit && compinit

##Following Auto Reattaches a screen
#if [[ $STY = '' ]] then screen -xR; fi



# Customize to your needs...
#  autoload -Uz promptinit
#  promptinit
#  DISABLE_AUTO_UPDATE=true
COMPLETION_WAITING_DOTS="true"


## ALT+S adds sudo to the start of the line
insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey "^[s" insert-sudo



## Auto list contents afer cd
#cd() {
#  if [ -n "$1" ]; then
#    builtin cd "$@" && ls -lha --group-directories-first
#  else
#    builtin cd ~ && ls -lha --group-directories-first
#  fi
#}






## COMPRESSION FUNCTION ##
function compress_() {
   # Credit goes to: Daenyth
   FILE=$1
   shift
   case $FILE in
      *.tar.bz2) tar cjf $FILE $*  ;;
      *.tar.gz)  tar czf $FILE $*  ;;
      *.tgz)     tar czf $FILE $*  ;;
      *.zip)     zip $FILE $*      ;;
      *.rar)     rar a $FILE $*      ;;
      *)         echo "Filetype not recognized" ;;
   esac
}



####ManyTimes! Stolen from user http://stackoverflow.com/users/79566/bta on page http://stackoverflow.com/questions/3737740/is-there-a-better-way-to-run-a-command-n-ti$
###Modified with & on 6th line to Parallelize, could use GNU parallel but that wasn't on system and when installed seemed slow, was abandoned before testing so this c$
manyTimes() {
    n=0
    times=$1
    shift
    while [[ $n -lt $times ]]; do
        $@&
        n=$((n+1))
    done
}



## EXTRACT FUNCTION ##



extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       rar x $1       ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}

galiases=(
  ls	'ls --group-directories-first --color'
  la	'ls -laFh'
  #l	'ls -lFh'     #size,show type,human readable
  lr	'ls -tRFh'   #sorted by date,recursive,show type,human readable
  lt	'ls -ltFh'   #long list,sorted by date,show type,human readable
  ll	'ls -l'      #long list
  ldot	'ls -ld .*'
  lS	'ls -1FSsh'
  lart	'ls -1Fcart'
  lrt	'ls -1Fcrt'
  zshrc 'gksu gedit ~/.zshrc' # Quick access to the ~/.zshrc file
  sgrep	'grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

  showzip	'unzip "-l"'
  showrar	'unrar "la"'
  showtar	'tar tf'
  showtar.gz	'echo '
  showace	'unace l'
  hgrep		'fc -El 0 | grep'
  fd		'find . -type d -name' #find Dir
  ff		'find . -type f -name' #find File

  ahack  'telnet nethack.alt.org'
  grep   'grep --color=auto'
  egrep  'egrep --color=auto'
  fgrep  'fgrep --color=auto'
  ...    '../..'
  ....   '../../..'
  xG     '| grep'
  xH     '| head'
  xL     '| less'
  xM     '| more'
  xP     "| $PAGER"
  xT     '| tail'
###Dogeify shit
#zgen oh-my-zsh plugins/systemd
# fetch 'wget'
# lots 'find'
# many 'cp -r'
# notrly 'rm -rf'
# plz 'cd'
# rly 'ls -la'
# so 'echo'
# such 'man'
# very 'mkdir -p'
# want 'curl'


# end_2
)

