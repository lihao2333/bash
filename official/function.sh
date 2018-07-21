#------保持单引号----------
quote()
{
    local quoted=${1//\'/\'\\\'\'}
    printf "'%s'" "$quoted"
}

[root@k8s-n1 ~]# a="'/test1/test2''"
[root@k8s-n1 ~]# echo $a
'/test1/test2''
[root@k8s-n1 ~]# quote $a
''\''/test1/test2'\'''\'''
#----------------------------

#------转义字符的单引号然后注册到变量里------
# @param $1  Argument to quote
# @param $2  Name of variable to return result to
_quote_readline_by_ref()
{
    if [[ $1 == \'* ]]; then
        # Leave out first character
        printf -v $2 %s "${1:1}"
    else
        printf -v $2 %q "$1"
    fi

    # If result becomes quoted like this: $'string', re-evaluate in order to
    # drop the additional quoting.  See also: http://www.mail-archive.com/
    # bash-completion-devel@lists.alioth.debian.org/msg01942.html
    [[ ${!2} == \$* ]] && eval $2=${!2}
}

[root@k8s-n1 ~]# _quote_readline_by_ref "a'b" test
[root@k8s-n1 ~]# echo $test
a\'b
#----------------------------

#------把除了$1的参数全部赋值给$1------
# Assign variable one scope above the caller
# Usage: local "$1" && _upvar $1 "value(s)"
# Param: $1  Variable name to assign value to
# Param: $*  Value(s) to assign.  If multiple values, an array is
#            assigned, otherwise a single value is assigned.
# NOTE: For assigning multiple variables, use '_upvars'.  Do NOT
#       use multiple '_upvar' calls, since one '_upvar' call might
#       reassign a variable to be used by another '_upvar' call.
# See: http://fvue.nl/wiki/Bash:_Passing_variables_by_reference
_upvar()
{
    if unset -v "$1"; then           # Unset & validate varname
        if (( $# == 2 )); then
            eval $1=\"\$2\"          # Return single value
        else
            eval $1=\(\"\${@:2}\"\)  # Return array
        fi
    fi
}

[root@k8s-n1 ~]# _upvar test b
[root@k8s-n1 ~]# echo $test
b
[root@k8s-n1 ~]# _upvar test b x y z
[root@k8s-n1 ~]# echo $test
b
[root@k8s-n1 ~]# echo ${test[@]}
b x y z
#---------------------
