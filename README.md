# Mike's XDG config

This repo uses the [XDG Base Direction Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) to organise config files. The official documentation is fairly sparse, so to get a better understanding of the system I'd recommend looking at the [archlinux wiki](https://wiki.archlinux.org/title/XDG_Base_Directory).

It assumes a ZSH shell and, notably, installs oh-my-zsh if it isn't installed.

## Getting started

1. Create a directory named `.xdg/` in your HOME directory
2. Clone this repo into `.xdg/config`
3. Link the zsh config files from this repo to the root ones
````
ln -s ~/.xdg/config/.zshrc ~/.zshrc
ln -s ~/.xdg/config/.zshenv ~/.zshenv
ln -s ~/.xdg/config/.zprofile ~/.zprofile
``````
4. Install base16-shell
```sh 
  git clone git@github.com:base16-project/base16-shell.git ~/.xdg/data/base16-shell
``````
5. If you are on Mac then for GUI programs launched from outside the terminal to
   detect your XDG config home you may also need to run this.

```sh
launchctl setenv XDG_CONFIG_HOME ~/.xdg/config
```


## Custom installation
The above is just a recommendation. Feel free to deviate, but remember to update
the values for the XDG environment variables. The defaults are defined in
`.zshenv`.

#### Debugging ZSH setup
Add the following line to output when a specific file is loaded

```sh
echo "loading: $0"
````

### TODO
- [ ] Handle personal and work config folders in XDG world, consider using
  XDG_CONFIG_DIRS
