
DEBUG=${DEBUG:-false}
VERBOSE=${VERBOSE:-true}
QUIET=${QUIET:-false}

# Terminal colour
green () { printf "\e[1m\e[32m" ; "$@" ; printf "\e[0m"; }
red    () { printf "\e[1m\e[31m" ; "$@" ; printf "\e[0m"; }
cyan   () { printf "\e[1m\e[36m" && "$@" && printf "\e[0m" ; }
yellow () { printf "\e[1m\e[33m" && "$@" && printf "\e[0m" ; }
loud   () { $QUIET && : $("$@") || "$@" ;}
shh    () { $VERBOSE && "$@" || : $("$@"); }
shhd   () { $DEBUG && "$@" || : $("$@"); }

show ()
{
    for v in "$@"; do
        printf "%s: %s\n" "${v^}" "${!v}"
    done
}