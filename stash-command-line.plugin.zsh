# aliases

# scl - stash-command-line
alias scl='stash'
alias sclp='scl pull-request'
alias sclb='scl browse'
alias so='sclb'

# alias -g @team='@reviewer1 @reviewer2'

# stash-command-line zsh completion

_stash-commad-line ()
{
    local curcontext="$curcontext" state line
    typeset -A opt_args

    local -a global_options
    global_options=(
        '(-h --help)-h[Display help documentation]'
        '(-v --version)-v[Display version information]'
        '(-t --trace)-t[Display backtrace when an error occurs]'
    )

    _arguments -C \
        $global_options \
        ':command:->command' \
        '*::options:->options'

    case $state in
        (command)
            __subcommands
        ;;

        (options)
            case $line[1] in

                (browse)
                _arguments \
                    '(-b --branch)-b[Open the Stash web ui at the specified branch, tag or commit hash. Defaults to the current branch]:remote-branch:__scl_git_remote_branch_names' \
                    '(-r --remote)-r[Open the Stash web ui at the remote repository]:remote:__scl_git_remotes' \
                    $global_options
                ;;

                (configure)
                    _arguments \
                    '--username[Writes your Stash username to the configuration file]:username: ' \
                    '--password[Writes your Stash user password to the configuration file. If omitted, password will be prompted to be entered]:password: ' \
                    '--stashUrl[Writes the Stash server url to the configuration file]:stash_url: ' \
                    '--remote[Pull requests will be created in the Stash repository specified by the given remote]:remote: ' \
                    $global_options
                ;;

                (pull-request)
                    _arguments \
                    '::branch:__scl_git_remote_branch_names' \
                    ':branch:__scl_git_remote_branch_names' \
                    '::reviewers:(@team)' \
                    '(-d --description)-d[Use the following description when creating the pull request]' \
                    '(-T --title)-T[Use the following title when creating the pull request]' \
                    '(-r --remote)-r[Creates the pull request in the Stash repository specified by the given remote]:remote:__scl_git_remotes' \
                    '(-o --open)-o[Open the created pull request page in a web browser]' \
                    $global_options
                ;;

                (help)
                    __subcommands
                ;;
            esac
        ;;
    esac
}

__subcommands ()
{
    local -a subcommands
    subcommands=(
        'browse:Open the Stash web ui for this repository'
        'configure:Setup configuration details to your Stash instance'
        'pull-request:Create a pull request in Stash'
        'help:Display global or [command] help documentation.'
    )
    _describe -t commands 'commands' subcommands
}

__scl_git_remote_branch_names () {
    local expl
    declare -a branch_names

    branch_names=(${${(f)"$(_call_program remote-branch-refs git for-each-ref --format='"%(refname)"' refs/remotes 2>/dev/null)"}#refs/remotes/})
    __scl_git_command_successful || return

    _wanted branch-names expl branch-name compadd $* - $branch_names
}

__scl_git_remotes () {
  local remotes expl

  remotes=(${(f)"$(_call_program remotes git remote 2>/dev/null)"})
  __scl_git_command_successful || return

  _wanted remotes expl remote compadd "$@" -a - remotes
}

__scl_git_command_successful () {
    if (( ${#pipestatus:#0} > 0 )); then
        _message 'not a git repository'
        return 1
    fi
    return 0
}

compdef _stash-commad-line stash
