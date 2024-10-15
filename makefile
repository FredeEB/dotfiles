HOSTNAME:=$(shell cat /etc/hostname)

nixos:
	sudo nixos-rebuild switch --flake .#${HOSTNAME}
home-manager:
	nix run home-manager -- switch --flake .#${USER}

bootstrap-home-manager:
	nix run --extra-experimental-features "nix-command flakes" home-manager -- switch --extra-experimental-features "nix-command flakes" --flake .#${USER}
