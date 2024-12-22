# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# add ltex-ls binaries to PATH
export PATH="$PATH:$HOME/.local/.ltex-ls/bin"

# add starship prompt
eval "$(starship init bash)"

# User specific environment and startup programs
