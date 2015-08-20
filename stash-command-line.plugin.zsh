# stash zsh completion

_stash-commad-line ()
{
	local curcontext="$curcontext" state line
	typeset -A opt_args

	_arguments -C \
		':command:->command' \
		'*::options:->options'

	case $state in
		(command)

			local -a subcommands
			subcommands=(
				'browse:Open the Stash web ui for this repository'
				'configure:Setup configuration details to your Stash instance'
				'pull-request:Create a pull request in Stash'
				'help:Display global or [command] help documentation.'
			)
			_describe -t commands 'stash' subcommands
			_arguments \
					'(-h --help)'{-h,--help}'[Display help documentation]' \
					'(-v --version)'{-v,--version}'[Display version information]' \
					'(-t --trace)'{-t,--trace}'[Display backtrace when an error occurs]'
		;;

		(options)				
			case $line[1] in		
				(browse)
					_arguments \
						'(-b --branch)'{-b,--branch}'[Open the Stash web ui at the specified branch, tag or commit hash. Defaults to the current branch]:remote-branch:__git_remote_branch_names' \
						'(-r --remote)'{-r,--remote}'[Open the Stash web ui at the remote repository]:remote:__git_remotes'
				;;
				(configure)
					_arguments \
						{'--username','--username'}':[Writes your Stash username to the configuration file]' \
						{'--password','--password'}':[Writes your Stash user password to the configuration file. If omitted, password will be prompted to be entered]' \
						{'--stashUrl','--stashUrl'}':[Writes the Stash server url to the configuration file]' \
						{'--remote','--remote'}':[Pull requests will be created in the Stash repository specified by the given remote]' \
						
				;;
				(pull-request)
					_arguments \
						'(-d --description)'{-d,--description}':[Use the following description when creating the pull request]' \
						'(-t --title)'{-t,--title}':[Writes your Stash user password to the configuration file. If omitted, password will be prompted to be entered]' \
						'(-r --remote)'{-r,--remote}':[Writes the Stash server url to the configuration file]:remote:__git_remotes' \
						'(-o --open)'{-o,--open}':[Pull requests will be created in the Stash repository specified by the given remote]' \
						':branch:__git_remote_branch_names' \
						':branch:__git_remote_branch_names'
				;;				
			esac
		;;
	esac
}

compdef _stash-commad-line stash