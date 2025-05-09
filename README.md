# new-mac-setup

[![gitmoji](https://img.shields.io/badge/gitmoji-%20%F0%9F%98%9C%20%F0%9F%98%8D-ffdd67)](https://github.com/carloscuesta/gitmoji-cli)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)

A clean setup of Mac OS X 10.15 for Python development and more

For personal & professional use.

<!-- See also corresponding sublime user settings file in this repo.

Auto updates on save.

https://github.com/naokazuterada/MarkdownTOC#usage -->
<!-- MarkdownTOC -->

- [Notes](#notes)
- [Tech Stack](#tech-stack)
  - [Mac Look and Feel](#mac-look-and-feel)
    - [Apple look & feel optimisations](#apple-look--feel-optimisations)
  - [Terminal Look and Feel](#terminal-look-and-feel)
    - [Homebrew and its essentials](#homebrew-and-its-essentials)
    - [iTerm nerd font](#iterm-nerd-font)
    - [Casks](#casks)
    - [Mac App Store \(MAS\)](#mac-app-store-mas)
  - [Backups](#backups)
  - [pyenv and pyenv-virtualenv](#pyenv-and-pyenv-virtualenv)
  - [Terraform](#terraform)
  - [Git with 2FA](#git-with-2fa)
      - [Mac OSX specifics](#mac-osx-specifics)
      - [Aliases](#aliases)
        - [Shorthands](#shorthands)
        - [Cleaning](#cleaning)
        - [Rewriting history](#rewriting-history)
      - [Split diff](#split-diff)
      - [Mergetool](#mergetool)
  - [Cleanup \(different options\)](#cleanup-different-options)
- [Keyboard Shortcuts](#keyboard-shortcuts)
- [Misc](#misc)
  - [Kubernetes CLI \(kubectl\)](#kubernetes-cli-kubectl)
  - [Fancy Dropbox screen shot sharing](#fancy-dropbox-screen-shot-sharing)
  - [Gigabit USB Driver OS X 10.9+](#gigabit-usb-driver-os-x-109)
- [TODO](#todo)

<!-- /MarkdownTOC -->


## Notes

- Avoid committing secrets into this repo by running `pre-commit install` in this dir.
- Want to copy a big dir from an old Mac? Below is `brew install rsync`! It's much faster than Finder's copying util.
  ```
  # boot old Mac while holding `T` to go in Target Disk Mode
  # password prompt should pop up
  rsync -au --progress <drag src folder> ~/backup
  ```
- Don't forget to take with your whole `.gnupg` folder, `.gitconfig`, `.envrc` etc!
- Chrome settings/bookmarks are not backed up and are assumed to come from its builtin Sync.

## Tech Stack

### Mac Look and Feel

```bash
# Do you understand zsh internals? I don't.
chsh -s /bin/bash && reset
# show hidden files (finder restart needed)
defaults write com.apple.finder AppleShowAllFiles YES
# disable google chrome dark mode when Mojave dark mode is enabled
defaults write com.google.Chrome NSRequiresAquaSystemAppearance -bool yes
# fit more items in the menu bar [ref](https://apple.stackexchange.com/a/465674/292695)
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 6
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 6
```

#### Apple look & feel optimisations

<!-- TODO convert these to https://github.com/msanders/setup/blob/master/defaults.yaml -->

- `System Preferences/Appearance/`
  - `Show scroll bars:` Always
  - `Click in the scroll bar to:` Jump to the spot that's clicked
- `System Preferences/Keyboard/`
  - Slide `Key Repeat` to `Fast`
  - Slide `Delay Until Repeat` to tick one before `Short`
  - Enable `Keyboard navigation`
  - Under `Text Input`, untick/remove all `Text Replacements...`
- `System Preferences/Security & Privacy/`
  - Under `FileVault`, turn on FileVault
- `System Preferences/Accessibility/`
  - Under `Zoom`, tick `Use scroll gesture with modifier keys to zoom:`
  - Under `Display`, untick `Shake mouse pointer to locate`
  - Under `Pointer Control/Trackpad Options...`, tick `Enable dragging/three finger drag`
- `System Preferences/Trackpad/`
  - Under `Point & Click`, set `Click Medium`, enable Tap to click
  - Under `Scroll & Zoom`, ticks 0, 1, 0, 1
  - Under `More Gestures`, set everything to four fingers, disable `Swipe between pages`, disable `Launchpad`, enable `Show Desktop`
- `System Preferences/Desktop & Dock/`
  - Tick `Automatically hide and show the Dock`
  - Untick `Show suggested and recent apps in Dock`
- `System Preferences/Language & Region/`
  - Set `Number Format` to 1 234 567.89
  - Untick `Show suggested and recent apps in Dock`
- `System Preferences/Keyboard`
  - Under `Text Input/Input Sources/Edit...` untick everything
- Finder preferences
  - `General`
    - `New Finder windows show:` home
  - `Advanced`
    - Tick `Show all filename extensions`
    - `When performing a search:` Search the Current Folder
- Finder View Options (go home: <kbd>⌘⇧H</kbd>, then <kbd>⌘J</kbd>)
  - Change to list view
  - Tick `Always open in List View`
    - Tick `Browse in List View`
  - `Group by:` None
  - `Sort by:` Name
  - Tick `Calculate all sizes`
  - Tick `Show Library Folder`
  - **Click** `Use as Defaults`
- Finder `View` menu item
  - `Show Tab Bar`
  - `Show Path Bar`
  - `Show Status Bar`
- TextEdit preferences
  - `New Document`
    - `Format`: Plain text
    - Untick `Check spelling as you type`
  - `Open and Save`
    - Untick `Add ".txt" extension to plain text files`
    - Under `Plain Text File Encoding`, select two times `UTF-8`
- Screenshot `Options` (to open: <kbd>⌘⇧5</kbd>)
  - Save to `Clipboard`
  - Untick  `Show Floating Thumbnail`


### Terminal Look and Feel

#### Homebrew and its essentials

```bash
# install homebrew (which installs command-line tools)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew tap buo/cask-upgrade  # `brew cu -a docker` - https://github.com/buo/homebrew-cask-upgrade#usage
# check whether all is good
brew doctor

# and some essentials
brew install git gitmoji bash-completion rsync curl openssl readline automake xz zlib sshfs htop ncdu direnv pwgen gcc rust sqlite3 libpq
```


#### iTerm [nerd font](https://github.com/ryanoasis/nerd-fonts/blob/master/readme.md)

```bash
brew install --cask iterm2 font-inconsolata-lgc-nerd-font

# some blazing fast rust
cargo install ripgrep  # rg (search for regex occurrences in directory, fastest regex implementation in the world)
cargo install zoxide  # z (cd with auto-complete) - echo 'eval "$(zoxide init bash)"' > ~.bash_profile
brew install zenith # fancy htop with persistent network and disk I/O history graphs
brew install eza  # modern alternative for ls https://github.com/eza-community/eza
brew install tealdeer  # rust implementation of tldr (man for lazy people) https://github.com/tealdeer-rs/tealdeer
tldr --update  # populate cache
# use exa with icons and git status instead of builtin ls
# this is in .bash_profile already
alias ls="eza --all --group-directories-first --icons --level=2"  # default level for --tree
alias ll="ls --long --sort=age --git --time=modified --time-style=iso"
```


#### Casks

```bash
# Docker CE - docker.com/community-edition - Open Docker.app manually to install helper and to enable CLI
brew install --cask docker
# Sublime Text - sublimetext.com
brew install --cask sublime-text
# Sublime Merge - sublimemerge.com
brew install --cask sublime-merge
# Google Chrome - google.com/chrome
brew install --cask google-chrome
# PIA VPN - privateinternetaccess.com - Requires manual install from ~/Library/Caches/Homebrew/downloads
brew install --cask private-internet-access
# Tunnelblick OpenVPN - tunnelblick.net
# brew install --cask tunnelblick
# The Unarchiver - theunarchiver.com
brew install --cask the-unarchiver
# f.lux - justgetflux.com - In Preferences/Sessions, tick 'Allow Display Sleep'
# brew install --cask flux
# VLC - videolan.org/vlc
brew install --cask vlc
# Slack - slack.com
# brew install --cask slack
# Zoom.us - zoom.us
brew install --cask zoom
# Whatsapp - whatsapp.com
# brew install --cask whatsapp
# Dropbox - dropbox.com
# brew install --cask dropbox
# Authy - authy.com - Set Master Password in preferences after init
# brew install --cask authy
# Jitsi Meet - jit.si
# brew install --cask jitsi-meet
# Maccy - maccy.app
brew install --cask maccy
# pdflatex - tug.org/mactex/
brew install --cask mactex-no-gui
# stats in menu bar https://github.com/exelban/stats
brew install --cask stats
# rectangle window resizer https://github.com/rxhanson/Rectangle
brew install --cask rectangle
```


#### Mac App Store (MAS)

When launching apps for the first time, you might have to accept the dev under `System Preferences/Security & Privacy/General`

Note: mas will not allow you to install (or even purchase) an app for the first time: it must already be in the Purchased tab of the App Store.

```bash
brew install mas
```

```bash
# DaisyDisk - daisydiskapp.com
# give full disk access under sysprefs security tab
mas install 411643860
# Amphetamine - roaringapps.com/app/amphetamine
mas install 937984704
# Telegram - macos.telegram.org - set password and enter behaviour after init
mas install 747648890
```


### Backups

Note: first open Chrome for the first time

- Clone (a fork of) this repo and set things up
  ```bash
  mkdir ~/git
  git clone https://github.com/ddelange/new-mac-setup.git ~/git/new-mac-setup
  ln -s ~/git/new-mac-setup/.bash_profile ~/.bash_profile && source ~/.bash_profile
  ln -s ~/git/.envrc ~/.envrc # tell direnv to look for env vars when entering/leaving ~ (same file works for nested directories in a cumulative fashion)
  touch ~/.env # fill this one with your secrets/env vars like `export PYENV_VERSION=vv`
  mkdir -p ~/.config/htop && ln -s ~/git/new-mac-setup/htoprc ~/.config/htop/htoprc

  # Sublime Text 3 backup
  # restore
  mkdir -p "${HOME}/Library/Application Support/Sublime Text 3/Packages/User" && \
      rsync -a "${HOME}/git/new-mac-setup/sublime_text_user_settings/" "${HOME}/Library/Application Support/Sublime Text 3/Packages/User"

  # create
  rsync -a "${HOME}/Library/Application Support/Sublime Text 3/Packages/User/" "${HOME}/git/new-mac-setup/sublime_text_user_settings"

  # Chrome search engines backup
  # restore
  sqlite3 "${HOME}/Library/Application Support/Google/Chrome/Default/Web Data" < "${HOME}/git/new-mac-setup/search-engine-export.sql"
  # create
  (printf 'begin transaction;\n'; sqlite3 "${HOME}/Library/Application Support/Google/Chrome/Default/Web Data" 'select short_name,keyword,url,favicon_url from keywords' | awk -F\| '{ printf "REPLACE INTO keywords (short_name, keyword, url, favicon_url) values ('"'"%s"'"', '"'"%s"'"', '"'"%s"'"', '"'"%s"'"');\n", $1, $2, $3, $4 }'; printf 'end transaction;\n') > ./search-engine-export.sql
  ```
- iTerm2 preferences: under `General/Preferences`, tick `Load preferences from a custom folder or URL` and paste `~/git/new-mac-setup`. Quit iTerm
- Stats preferences: in `General/Import Settings...`, select `Stats settings.plist`. Drag & drop menu bar items with ⌘+drag
- iStat Menus preferences: in `File/Import Settings...`, select `iStat Menus Settings.ismp`. Drag & drop menu bar items with ⌘+drag
- Quickly download audio & video with [`yt`](https://github.com/ddelange/yt)
  ```bash
  brew install ddelange/brewformulae/yt
  ``` 


### [pyenv](https://github.com/pyenv/pyenv/blob/master/COMMANDS.md#command-reference) and [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv#usage)

- Note: pyvenv-virtualenv needs to be initialised in [`~/.bash_profile`](/.bash_profile) (already present there in the right order to cooperate with direnv), or in `~/.bashrc` if both files are [maintained separately](https://github.com/pyenv/pyenv-virtualenv/issues/36#issuecomment-48387008):
  ```bash
  eval "$(pyenv init -)"
  if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
  ```
- Set up latest Python versions (this needs the `LDFLAGS` and `CPPFLAGS` in `.bash_profile`):
  ```bash
  brew install pyenv pyenv-virtualenv
  # get your favourite python versions - github.com/momo-lab/pyenv-install-latest
  git clone https://github.com/momo-lab/pyenv-install-latest.git "$(pyenv root)"/plugins/pyenv-install-latest
  git clone https://github.com/concordusapps/pyenv-implict.git "$(pyenv root)"/plugins/pyenv-implict
  pyenv install -l | grep '^\s*[0-9]' # list all available python versions
  pyenv install-latest 2
  pyenv install-latest 3.12
  pyenv versions  # see currently installed versions
  pyenv global $(pyenv install-latest --print 3.12) $(pyenv install-latest --print 2.7)  # set default versions: prefer py3 over py2
  # install virtualenv 'vv' based latest pyenv Python version 3.x, inheriting installed packages
  pyenv virtualenv $(pyenv install-latest --print 3.12) --system-site-packages vv312
  # same for 'vv27' with python 2.7.x
  pyenv virtualenv $(pyenv install-latest --print 2.7) --system-site-packages vv27
  ```
- Auto-activate venv using direnv when cd'ing into a folder containing an `.envrc` and `.env`:
  ```bash
  echo 'export PYENV_VERSION=vv312' >> ~/.env
  ln -s ~/git/.envrc ~/.envrc  # if it wasn't done already
  ```
- Manage envs
  ```bash
  pyenvls # alias in .bash_profile
  pyenv virtualenvs
  pyenv virtualenv --system-site-packages <venv-name>
  pyenv activate <venv-name>
  pyenv deactivate
  pyenv uninstall <venv-name>
  ```
- Add an env var like `export PYENV_VERSION=vv` to your direnv `.env` file to automatically activate and deactivate when entering and leaving directories. Works as long as you don't put a dash (`-`) in your venv name.

### Terraform

```bash
brew install tfenv tflint
tfenv install
tfenv use
```

### Git with 2FA

[Enable and set up 2FA](https://gist.github.com/ateucher/4634038875263d10fb4817e5ad3d332f). It's recommended to first delete any git configurations locally after enabling 2FA.

- Use built-in keychain and app password from above, and add a Mac specific global gitignore:
  ```bash
  git config --global user.name "ddelange"
  git config --global user.email "14880945+ddelange@users.noreply.github.com"  # fetch this from https://github.com/settings/emails
  git config --global credential.helper osxkeychain

  # EITHER
  curl -sLw "\n" "http://gitignore.io/api/macos,python,django,sublimetext" >> ~/.gitignore  # for all possibilities see http://gitignore.io/api/list
  # OR
  cp .gitignore.global ~/.gitignore  # can no longer be a symlink on git version 2.32+

  git config --global core.excludesfile "~/.gitignore"
  ```
- Note: it's advised to add [commit signature verification](https://help.github.com/en/articles/managing-commit-signature-verification) to Git.
- EITHER get the existing `~/.gnupg/` from your old machine
- OR [Generate a GPG key](https://help.github.com/en/articles/generating-a-new-gpg-key#generating-a-gpg-key) and tell Git to use it:
  ```bash
  brew install gpg
  gpg --full-generate-key  # recommended settings: enter, ed25519, enter
  gpg --list-secret-keys --keyid-format LONG  # copy the signing key after 'sec  ed25519/'
  gpg --armor --export <key-here>  # paste this key at github.com/settings/keys
  git config --global user.signingkey <key-here>
  git config --global commit.gpgsign true
  git config --global gpg.program "$(which gpg)"
  # sign tags using git tag -s
  ```
- To [enable password caching](https://stackoverflow.com/a/38422272/5511061) for 1 week:
  ```bash
  echo "default-cache-ttl 604800" >> ~/.gnupg/gpg-agent.conf
  echo "max-cache-ttl 604800" >> ~/.gnupg/gpg-agent.conf
  echo "log-file /var/log/gpg-agent.log" >> ~/.gnupg/gpg-agent.conf
  ```


##### Mac OSX specifics

```bash
git config --global pull.rebase false
git config --global core.trustctime false  # http://www.git-tower.com/blog/make-git-rebase-safe-on-osx
git config --global core.precomposeunicode false  # http://michael-kuehnel.de/git/2014/11/21/git-mac-osx-and-german-umlaute.html
git config --global core.untrackedCache true  # https://git-scm.com/docs/git-update-index#_untracked_cache
git config --global merge.log true  # Include summaries of merged commits in newly created merge commit messages
git config --global push.default "simple" # https://git-scm.com/docs/git-config#Documentation/git-config.txt-pushdefault
git config --global push.followTags true # https://git-scm.com/docs/git-config#Documentation/git-config.txt-pushfollowTags
git config --global init.defaultBranch master
```


##### Aliases

Some of these aliases depend on one another, in which case it's noted in the comments.

###### Shorthands
```bash
git config --global alias.br "branch"
git config --global alias.ca "commit -am"
git config --global alias.cm "commit"
git config --global alias.co "checkout"
git config --global alias.mt "mergetool"
git config --global alias.st "status"
# split diff - needs icdiff (see below) - use `git icdiff` to keep output in terminal after less quits
git config --global alias.df '! f() { diff=$(git difft "$@") && test "$diff" && echo "$diff" | less -eR; }; f'
# who needs the default verbose git log? - also try `git lg --all`
git config --global alias.lg "log --graph --oneline"
# tested with GitHub remote - ref https://stackoverflow.com/questions/28666357#comment101797372_50056710
git config --global alias.defaultbranch '! f() { echo $(git remote show origin | grep "HEAD branch" | cut -d ":" -f 2 | xargs); }; f'
# summary of all configured aliases
git config --global alias.alias "! git config --get-regexp '^alias\.' | sed -e s/^alias\.// | grep -v ^'alias ' | sed 's/ /#/' | column -ts#"
# "commit all & push" - needs ca,pr - usage `git cap 'Fix bug'` - runs autoformatting pre-commit hooks, commits all modified tracked files with message, and push
git config --global alias.cap '! f() { git ca "$@" && git pr; }; f'
# "pull request" - push new or existing branch skipping the usual --set-upstream error - alias will be overwritten when git-extras is installed
git config --global alias.pr '! git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)"'
```

###### Cleaning
```bash
# "delete merged" - delete all local branches (-D) that have been deleted (merged) on remote
git config --global alias.dm '! git fetch -p && for branch in `git branch -vv | grep '"': gone] ' | awk '"'{print $1}'"'"'`; do git branch -D $branch; done'
# "fetch purge" - before fetching, remove any remote-tracking references that no longer exist on the remote
git config --global alias.fp "fetch -p --all"
# "rinse & repeat" - needs defaultbranch,dm - usage `git gg [develop]` - return to default branch (or specified branch), delete merged and pull
git config --global alias.gg '! f() { git checkout "${1:-$(git defaultbranch)}" && git dm && git pull; }; f'
# "pull all" - pull all local branches and return to original branch
git config --global alias.pall '! f() { \
START=$(git branch | grep "\*" | sed "s/^.//"); \
for i in $(git branch | sed "s/^.//"); do \
  git checkout $i; \
  git pull || break; \
done; \
git checkout $START; \
}; f'
```

###### Rewriting history
```bash
# "commit all amend" last commit, adding all modified tracked files to the it without editing the commit message
git config --global alias.amend "commit --amend --reset-author --no-edit -a"
# "commit all amend with message" - add all modified tracked files to the last commit with a new commit message
git config --global alias.camend "commit --amend --reset-author -am"
# "squash last" X commits - allowing to edit a pre-generated commit message before committing - known caveat: when trying to squash into an initial commit, the reset fails
git config --global alias.squashlast '!f(){ TEMP_MSG="$(mktemp)" && git log --format=%B HEAD...HEAD~${1} > "${TEMP_MSG}" && git reset --soft HEAD~${1} && git commit -n --edit --file "${TEMP_MSG}"; rm "${TEMP_MSG}"; }; f'
# "undo" whatever you did last, for instance an erroneous squashlast - ref https://megakemp.com/2016/08/25/git-undo/
git config --global alias.undo '! f() { git reset --hard $(git rev-parse --abbrev-ref HEAD)@{${1-1}}; }; f'
```


##### Split diff

- `git df` (above) uses less that keeps a clean terminal
- `git icdiff` and `git difft` (below) uses new core.pager that leaves less output in terminal after exiting

```bash
git config --global --replace-all core.pager 'less -+$LESS -eFRSX'  # with double quotes, $ will be evaluated

# with diff highlighting
pip install git+https://github.com/jeffkaufman/icdiff.git  # installs git-icdiff for `git icdiff``
git config --global icdiff.options "--highlight --line-numbers --numlines=3 --color=always"
git config --global difftool.icdiff.cmd 'icdiff --highlight --line-numbers --numlines=3 --color=always $LOCAL $REMOTE'

# with syntax & diff highlighting
brew install difftastic
git config --global difftool.difft.cmd 'difft --display=side-by-side-show-both --color=always --background=light "$LOCAL" "$REMOTE"'
git config --global alias.difft 'difftool --tool difft --no-prompt'
```


##### Mergetool

On failed automatic merge, use Sublime Merge GUI for conflict resolution using `git mergetool` or `git mt` (see above).
```bash
git config --global mergetool.smerge.cmd 'smerge mergetool "$BASE" "$LOCAL" "$REMOTE" -o "$MERGED"'
git config --global mergetool.smerge.trustExitCode true
git config --global mergetool.keepBackup false
git config --global merge.tool smerge
```


### Cleanup ([different options](https://github.com/Homebrew/brew/issues/3784#issuecomment-364675767))

```bash
brew cleanup --prune=0  # delete cache older than 0 days
```


## Keyboard Shortcuts

- Sublime
  - `s`, `smerge`
  - line selctors: <kbd>⌘L</kbd>, <kbd>⌘⇧L</kbd>
  - swap lines: <kbd>⌃⌘↑/↓</kbd>
  - swap selection shortcut TODO
- forward delete (<kbd>⌦</kbd>): <kbd>fn⌫</kbd> or <kbd>^D</kbd>
- cutpaste files: <kbd>⌘⌥V</kbd>
- lock machine: <kbd>⌘⇧Q</kbd>
- spotlight: <kbd>⌘␣</kbd>
- screenshots: <kbd>⌘⇧3/4/5</kbd> and one window: <kbd>⌘⇧4</kbd>, then <kbd>␣</kbd>
- restore tab: <kbd>⌘⇧T</kbd>
- <kbd>^↑/↓</kbd>
- <kbd>⌘~</kbd> or <kbd>⌘\`</kbd> to switch windows
- `~.` to stop ssh
- emoji chooser: <kbd>⌘^␣</kbd>
- the shortcut-changing prefpane

<details><summary><b>Full Keyboard Symbol List</b></summary><p>

- ⌘ is <kbd>command </kbd>
- ⌥ is <kbd>option </kbd>
- ⌃ is <kbd>control </kbd>
- ⇧ is <kbd>shift </kbd>
- ⇪ is <kbd>caps lock </kbd>
- ← is <kbd>left arrow </kbd>
- → is <kbd>right arrow </kbd>
- ↑ is <kbd>up arrow </kbd>
- ↓ is <kbd>down arrow </kbd>
- ⇥ is <kbd>tab </kbd>
- ⇤ is <kbd>backtab </kbd>
- ↩ is <kbd>return </kbd>
- ⌤ is <kbd>enter </kbd>
- ⌫ is <kbd>delete /backspace</kbd>
- ⌦ is <kbd>forward delete </kbd>
- ⇞ is <kbd>page up </kbd>
- ⇟ is <kbd>page down </kbd>
- ↖ is <kbd>home </kbd>
- ↘ is <kbd>end </kbd>
- ⌧ is <kbd>clear </kbd>
- ␣ is <kbd>space </kbd>
- ⎋ is <kbd>escape </kbd>
- ⏏ is <kbd>eject</kbd>

</p></details>


## Misc

- To revert to the classic iTunes playlist view from before v12.6:
  - Open your iTunes library
  - Open and run [`Restore old iTunes playlists view.scpt`](/Restore%20old%20iTunes%20playlists%20view.scpt).
- Scroll horizontally using <kbd>⇧</kbd>, then mouse wheel


### Kubernetes CLI ([kubectl](https://kubernetes.io/docs/reference/kubectl/))

Kubectl is a command line interface for running commands against Kubernetes clusters (like viewing logs or executing commands on pods).
See [`kubebash kubelogs kubebranch`](https://gist.github.com/ddelange/24575a702a10c2cb6348c4c7f342e0eb) for plug & play kubectl extensions (they are already in [`~/.bash_profile`](/.bash_profile)).


### [Fancy Dropbox screen shot sharing](https://github.com/ddelange/mac-smart-bitly-shortcut)

AppleScript to shorten links using the bitly API in a smart way directly with a keyboard shortcut


### [Gigabit USB Driver OS X 10.9+](https://www.asix.com.tw/products.php?op=pItemdetail&PItemID=131;71;112)

**Not needed for 10.15, it is now built-in.**

For almost any [Gigabit Ethernet USB hub](https://www.ebay.com/itm/3-Ports-USB-3-0-Hub-Gigabit-Ethernet-Lan-RJ45-Network-Adapter-Hub-Hot-Lot-YT/183586523117)
- Unzip [`AX88179_178A_macintosh_Driver_Installer_v2.13.0.zip`](/AX88179_178A_macintosh_Driver_Installer_v2.13.0.zip)
- Install driver `pkg` from `AX88179_178A.dmg`
- Restart


## TODO

- Automate this repo with [zero.sh](https://github.com/zero-sh/zero.sh), e.g. https://github.com/msanders/setup
- Add low battery warning plist
- Add LaTeX scripts
- Add Dougs applescripts like [Show in Playlists](http://dougscripts.com/itunes/scripts/ss.php?sp=showinplaylists)
