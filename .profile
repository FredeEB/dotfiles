# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

setxkbmap us -option caps:escape
TZ='Europe/Copenhagen'; export TZ

if [ -d "$HOME/go/bin" ] ; then
    PATH="$PATH:$HOME/go/bin"
fi

if [ -e /home/bun/.nix-profile/etc/profile.d/nix.sh ]; then . /home/bun/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
