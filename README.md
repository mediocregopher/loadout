# Mediocre Loadout

This repo contains everything needed to build my loadout, which is everything
which I tend to take from one linux machine to the next. This includes:

* My development environment (neovim + plugins + a lot of customization)
* My shell (zsh + plugins + a custom theme)
* My window manager (awesome + plugins + a lot of customization)

I'm calling the result the "Mediocre Loadout". It is designed to be completely
agnostic to the system it is running on, and to make little to no mutations to
that system.

# Build/Installation/Usage options

To build the Mediocre Loadout you must have a working
[nix](https://nixos.org/manual/nix/stable/) installation, as well as an `x86_64`
machine. That's it.

There are multiple build/installation options:

## nix Derivation

To build the nix derivation of the loadout you can do:

```
nix-build -A loadout
```

This will place the result in the `result` symlink in the root directory.
Components of the loadout can then be executed from the `bin` subdirectory,
e.g.:

```
./result/bin/nvim
```

## nix Environment

Alternatively, to install it to your nix profile do:

```
nix-env -i default.nix -A loadout
```

Assuming your nix environment is set up correctly, you should be able to execute
components directly:

```
nvim
```

## AppImage

An [AppImage](https://appimage.org/) binary can be built which can run any
component of the loadout individually. This binary can be copied from one
machine to the next without any of them requiring nix or any other dependencry
to run it.

To build the binary:

```
nix-build -A appimage
```

The resulting binary will be placed in the `result` symlink in the root
directory.

Specific components of the loadout can be run by passing an argument to the
binary:

```
./Mediocre_Loadout-x86_64.AppImage nvim
```

# Available Components

Components of the loadout can be run separate from the others, depending on what
you're trying to do. The following components are available to be run:

* `zsh` (`shell` in the AppImage): My terminal shell. There's some customization
  to it but it should be pretty self-explanatory to "just use".

* `nvim` (`editor` in the AppImage): My neovim development environment, plus all
  plugins I use. I mostly work in golang, so it's most tuned for that, but it
  does fine for general dev work. `Ctrl-N` will open NerdTree, `<backslash>tn`
  will open a terminal tab, and `<backslash>th`/`<backslash>tl` can be used to
  navigate tabs. There's a lot more customization that's been done, see the
  `nvim/init.vim` file.

* `alacritty` (`gui` in the AppImage, might be broken): Terminal which I use.
  Yes, I always use a light-mode theme, because I work in well lit spaces
  generally. There's not much else to this.

* `awesome` (`wm` in the AppImage, almost definitely broken): My window manager.
  There's so much customization I couldn't begin to start. `Meta+Enter` should
  open a terminal, where `Meta` is probably the windows key on your keyboard.

# Status

This configuration is still fairly new, and so expect it to be fairly broken.
I'll be updating it as I go though, so it should stabalize into something
functional.
