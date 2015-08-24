# stash-command-line zsh completion

source /usr/local/share/zsh/functions/_git

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
                    '(-b --branch)-b[Open the Stash web ui at the specified branch, tag or commit hash. Defaults to the current branch]:remote-branch:__git_remote_branch_names' \
                    '(-r --remote)-r[Open the Stash web ui at the remote repository]:remote:__git_remotes' \
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
                    '::branch:__git_remote_branch_names' \
                    ':branch:__git_remote_branch_names' \
                    '::reviewers:(@team)' \
                    '(-d --description)-d[Use the following description when creating the pull request]' \
                    '(-t --title)-t[Writes your Stash user password to the configuration file. If omitted, password will be prompted to be entered]' \
                    '(-r --remote)-r[Writes the Stash server url to the configuration file]:remote:__git_remotes' \
                    '(-o --open)-o[Pull requests will be created in the Stash repository specified by the given remote]' \
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

compdef _stash-commad-line stash
