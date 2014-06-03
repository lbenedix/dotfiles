# this file is sourced by all bash shells on startup

# test for interactive shell
[[ $- != *i* ]] && return

# return if this script is executed twice
[[ -n $(declare -p _DOTFILES_DIR 2>/dev/null) ]] && return

_DOTFILES_BRANCH="master"
_DOTFILES_DIR="${HOME}/.dotfiles"
_BASHRC_DIR="${_DOTFILES_DIR}/bashrc"

# self update magic
self_update() {
	pushd ${_DOTFILES_DIR} &>/dev/null

	if timeout 10 git fetch -q origin; then
		if [[ -n "$(git whatchanged HEAD..origin/${_DOTFILES_BRANCH})" ]]; then
			git checkout ssh/known_hosts
			if git merge origin/${_DOTFILES_BRANCH}; then
				git submodule update --init
				popd &>/dev/null
#				exec ${SHELL} -li
			else
				echo -e "\033[1;31m*\033[0m merge failed! please merge manually."
			fi
		else
			echo -en "\r\033[1;32m\$\033[0m "
#			kill $$
#			exec ${SHELL} -li
		fi
	else
		echo -e "\033[1;31m*\033[0m dotfile update timed out ... :("
	fi

	popd &>/dev/null
}

(self_update &)

source "${_BASHRC_DIR}/bashrc"

if [ -e ~/.virtualenvs/py27/bin/activate ]; then
	source ~/.virtualenvs/py27/bin/activate
fi

# cleanup
unset _BASHRC_DIR _DOTFILES_DIR _DOTFILES_BRANCH
