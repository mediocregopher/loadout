
# prevents default audio devices from changing when connecting to audio dock
setup-pulseaudio:
	sudo sed -i 's/^load-module module-switch-on-connect$/# load-module module-switch-on-connect/g' /etc/pulse/default.pa
	pulseaudio -k

# add vfat to MODULES in /etc/mkinitcpio.conf
# add `cryptkey=UUID=<uuid>:vfat:/keyfile` to boot line in bootloader
#      - use lsblk -o NAME,UUID to get UUID
install-rm-keyfile:
	sudo cp ./base/rm-keyfile.service /etc/systemd/system
	sudo systemctl daemon-reload

install-pamd:
	drv=$$(nix-instantiate -E '((import ./pkgs.nix).stable {}).i3lock'); \
	store=$$(nix-store --realise $$drv); \
	sudo cp $$store"/etc/pam.d/i3lock" /etc/pam.d/i3lock

install-loadout:
	@if [ -z "$(HOSTNAME)" ]; then echo "USAGE: make HOSTNAME=... install-loadout"; exit 1; fi
	nix-env -i loadout -f default.nix --arg hostConfig "import ./config/$(HOSTNAME).nix"

install-fonts:
	@if [ -z "$(HOSTNAME)" ]; then echo "USAGE: make HOSTNAME=... install-loadout"; exit 1; fi
	mkdir -p ~/.local/share/fonts/
	p=$$(nix-build --no-out-link --arg hostConfig ./config/$(HOSTNAME).nix -A fonts); \
	cp -rL $$p/share/fonts ~/.local/share/fonts/loadout
	chmod o+w -R ~/.local/share/fonts/loadout
	fc-cache

install-keyboard:
	sudo cp ./base/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf

install: setup-pulseaudio install-pamd install-rm-keyfile install-fonts install-keyboard install-loadout
