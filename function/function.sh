set -o errexit    # abort script at first error
# set -o pipefail   # return the exit status of the last command in the pipe
set -o nounset    # treat unset variables and parameters as an error

readonly CUR_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

err() {
  printf '%b\n' ""
  printf '%b\n' "\033[1;31m[ERROR] $@\033[0m"
  printf '%b\n' ""
  exit 1
} >&2

success() {
  printf '%b\n' ""
  printf '%b\n' "\033[1;32m[SUCCESS] $@\033[0m"
  printf '%b\n' ""
}

extract() {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
