# this file is sourced by all bash shells on startup

# test for interactive shell
[[ $- != *i* ]] && return

# return if this script is executed twice
[[ -n $(declare -p _DOTFILES_DIR 2>/dev/null) ]] && return

_DOTFILES_BRANCH="nutz"
_DOTFILES_DIR="${HOME}/.dotfiles"
_BASHRC_DIR="${_DOTFILES_DIR}/bashrc"

# self update magic
pushd ${_DOTFILES_DIR} &>/dev/null

if timeout 2 git fetch -q origin; then
	if [[ -n "$(git whatchanged HEAD..origin/${_DOTFILES_BRANCH})" ]]; then
		git checkout ssh/known_hosts
		if git merge origin/${_DOTFILES_BRANCH}; then
			git submodule update --init
			popd &>/dev/null
			exec ${SHELL} -li
		else
			echo -e "\033[1;31m*\033[0m merge failed! please merge manually."
		fi
	else
		echo -e "\033[1;32m*\033[0m dotfiles are up to date!"
	fi
else
	echo -e "\033[1;31m*\033[0m dotfile update timed out ... :("
fi

popd &>/dev/null

source "${_BASHRC_DIR}/bashrc"

# cleanup
unset _BASHRC_DIR _DOTFILES_DIR _DOTFILES_BRANCH
