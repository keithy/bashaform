
bashaform="$here"

# Output control
DEBUG=${DEBUG:-false}
VERBOSE=${VERBOSE:-true}
QUIET=${QUIET:-false}

loud   () { ${QUIET:-false}   && : $("$@") || >&2 "$@" ;}
shh    () { ${VERBOSE:-false} && >&2 "$@" || : $("$@"); }
shhd   () { ${DEBUG:-false}   && >&2 "$@" || : $("$@"); }

# Terminal colour
green () { printf "\e[1m\e[32m" ; "$@" ; printf "\e[0m"; }
red    () { printf "\e[1m\e[31m" ; "$@" ; printf "\e[0m"; }
cyan   () { printf "\e[1m\e[36m" && "$@" && printf "\e[0m" ; }
yellow () { printf "\e[1m\e[33m" && "$@" && printf "\e[0m" ; }

show ()
{
    for v in "$@"; do
        printf "%s: %s\n" "${v^}" "${!v}"
    done
}

read_env ()
{   # Read a simple env file and export entries as environment variables

    local line input variable_name variable_value
    while read -r input; do

      line="${input%%#*}" # remove comments
      variable_name="${line%%=*}"

      # move on to the next line if no $= was found
      if [[ "$variable_name" == "$line" ]]; then continue; fi
  
      variable_value="${line##*=\'}"
      variable_value="${variable_value%\'}"

      if [[ "$variable_name" != "PASS_PHRASE" ]]; then
        shhd cyan echo "${variable_name}"="${variable_value}"
      fi

      export "${variable_name}"="${variable_value}"
 
    done < "$1"
}

add_options_from_env_prefixed ()
{
  local key value env_kv
  local prefix="$1"

  for env_kv in $(env); do
    key="${env_kv%%=*}"
    if [[ "$key" == "$prefix"* ]]; then
      value="${!key}"
      key="${key/$prefix/}"

      #if [ "${value:0:1}" = "{" ]
      #then #json
      #  options+=( "${key//_/-}" "'$value'" )
      #else
        options+=( "${key//_/-}" "$value" )
      #fi
    fi
  done
}
