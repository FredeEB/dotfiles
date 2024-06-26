HOSTNAME:=$(shell cat /etc/hostname)

nixos:
	sudo nixos-rebuild switch --flake .#${HOSTNAME}
home-manager:
	nix run home-manager -- switch --flake .#${USER}
