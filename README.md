# A clean setup of Mac OS X 10.14+ for Python development and more

For personal & professional use.

#### Notes

- Want to copy a big dir from an old Mac? Below is `brew install rsync`! It's much faster than Finder's copying util.
  ```
  # boot old Mac while holding `T` to go in Target Disk Mode
  # password prompt should pop up
  rsync -au --progress=info2 <drag src folder> ~/backup
  ```
- Don't forget to take with your whole `.gnupg` folder, `.gitconfig`, `.envrc` etc!
- Chrome settings/bookmarks are not backed up and are assumed to come from its builtin Sync.


### Preferences


#### General Mac stuff

```bash
# Do you understand zsh internals? I don't.
chsh -s /bin/bash && reset
# show hidden files (finder restart needed)
defaults write com.apple.finder AppleShowAllFiles YES
# disable google chrome dark mode when Mojave dark mode is enabled
defaults write com.google.Chrome NSRequiresAquaSystemAppearance -bool yes
```

- `System Preferences/General/`
  - `Show scroll bars:` Always
  - `Click in the scroll bar to:` Jump to the spot that's clicked
  - `Recent items:` 50
- `System Preferences/Keyboard/`
  - Slide `Key Repeat` to `Fast`
  - Slide `Delay Until Repeat` to tick one before `Short`
  - Under `Text`, untick/remove everything
  - Under `Shortcuts`, tick `Use keyboard navigation to move focus between controls` on the bottom
  - Under `Input Sources`, set keyboard layout to U.S. (remove U.S. International)
  - Under `Touch Bar shows`, choose `Expanded Control Strip`
- `System Preferences/Security & Privacy/`
  - Under `FileVault`, turn on FileVault
- `System Preferences/Accessibility/`
  - Under `Zoom`, tick `Use scroll gesture with modifier keys to zoom:`
  - Under `Display`, untick `Shake mouse pointer to locate`
  - Under `Mouse & Trackpad/Trackpad Options...`, tick `Enable dragging/three finger drag`
- `System Preferences/Software Update/`
  - Under `Advanced...`, untick `Download new updates when available`
- `System Preferences/Dock/`
  - Untick `Show recent applications in Dock`
  - Tick `Turn Hiding On`
- Finder preferences
  - `General`
    - `New Finder windows show:` home
  - `Advanced`
    - Tick `Show all filename extensions`
    - `When performing a search:` Search the Current Folder
- Finder View Options (Go home ⌘-⇧-H, then ⌘-J)
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
- Screenshot `Options`
  - Untick  `Show Floating Thumbnail`


#### Terminal stuff

Homebrew and it's essentials

```bash
# install homebrew (which installs command-line tools)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew tap homebrew/cask
brew tap buo/cask-upgrade  # `brew cu -a docker` - https://github.com/buo/homebrew-cask-upgrade#usage
# check wether all is good
brew doctor

# and some essentials
# - ruby, gcc-8 are linked in `.bash_profile`
# - node installs npm
brew install \
  git git-lfs bash-completion rsync curl openssl readline automake xz zlib \
  osxfuse sshfs htop ncdu direnv pwgen \
  gcc@8 rust ruby node@12 sqlite3
# check out caveats from command above!
# npm installs yarn
PATH="/usr/local/opt/node@12/bin:$PATH" npm install -g yarn
```


#### iTerm [nerd font](https://github.com/ryanoasis/nerd-fonts/blob/master/readme.md)

```bash
brew install --cask iterm2
brew install --cask homebrew/cask-fonts/font-inconsolata-lgc-nerd-font
cargo install ripgrep  # rg (search for regex occurrences in directory)
cargo install zoxide  # z (cd with auto-complete) - echo 'eval "$(zoxide init bash)"' > ~.bash_profile
cargo install --git https://github.com/ogham/exa.git
# use exa with icons and git status instead of builtin ls
# this is in .bash_profile already
alias ls="exa --all --group-directories-first --icons --level=2"  # default level for --tree
alias ll="ls --long --sort=age --git --time=modified --time-style=iso"
```


#### Casks

```bash
# Docker CE - docker.com/community-edition
brew install --cask docker
brew install docker-compose
# PostgresApp - postgresapp.com
brew install --cask postgres
# Sublime Text - sublimetext.com
brew install --cask sublime-text
# Sublime Merge - sublimemerge.com
brew install --cask sublime-merge
# Google Chrome - google.com/chrome
brew install --cask google-chrome
# PIA VPN - privateinternetaccess.com - Requires manual install from ~/Library/Caches/Homebrew/downloads
brew install --cask private-internet-access
# Tunnelblick OpenVPN - tunnelblick.net
brew install --cask tunnelblick
# The Unarchiver - theunarchiver.com
brew install --cask the-unarchiver
# f.lux - justgetflux.com
brew install --cask flux
# VLC - videolan.org/vlc
brew install --cask vlc
# Slack - slack.com
brew install --cask slack
# Zoom.us - zoom.us
brew install --cask zoom
# Whatsapp - whatsapp.com
# brew install --cask whatsapp
# Dropbox - dropbox.com
# brew install --cask dropbox
# Authy - authy.com - Set Master Password in preferences after init
brew install --cask authy
```


#### Mac App Store (MAS)

When launching apps for the first time, you might have to accept the dev under `System Preferences/Security & Privacy/General`

Note: mas will not allow you to install (or even purchase) an app for the first time: it must already be in the Purchased tab of the App Store.

```bash
brew install mas
```

```bash
# iStat Menus - bjango.com/mac/istatmenus
mas install 1319778037
# Magnet - magnet.crowdcafe.com
mas install 441258766
# DaisyDisk - daisydiskapp.com
# give full disk access under sysprefs security tab
mas install 411643860
# Amphetamine - roaringapps.com/app/amphetamine
mas install 937984704
# Telegram - macos.telegram.org
mas install 747648890
# Copyclip - fiplab.com/apps/copyclip-for-mac
mas install 595191960
```


### Backups

Note: first open Chrome for the first time

- Clone (a fork of) this repo and set things up
  ```bash
  mkdir ~/git
  git clone https://github.com/ddelange/new-mac-setup.git ~/git/new-mac-setup
  ln -s ~/git/new-mac-setup/.bash_profile ~/.bash_profile && source ~/.bash_profile
  mkdir -p ~/.config/htop && ln -s ~/git/new-mac-setup/htoprc ~/.config/htop/htoprc
  direnv edit ~  # add `export SECRET=42` to load global env vars

  # Sublime Text 3 backup
  # restore

  # create
  cp -r "${HOME}/Library/Application Support/Sublime Text 3/Packages/User/" "${HOME}/git/new-mac-setup/sublime_text_user_settings/"

  # Chrome search engines backup
  # restore
  sqlite3 "${HOME}/Library/Application Support/Google/Chrome/Default/Web Data" < ./search-engine-export.sql
  # create
  (printf 'begin transaction;\n'; sqlite3 "${HOME}/Library/Application Support/Google/Chrome/Default/Web Data" 'select short_name,keyword,url,favicon_url from keywords' | awk -F\| '{ printf "REPLACE INTO keywords (short_name, keyword, url, favicon_url) values ('"'"%s"'"', '"'"%s"'"', '"'"%s"'"', '"'"%s"'"');\n", $1, $2, $3, $4 }'; printf 'end transaction;\n') > ./search-engine-export.sql
  ```
- iTerm2 preferences: under `General/Preferences`, tick `Load preferences from a custom folder or URL` and paste `~/git/new-mac-setup`. Quit iTerm
- iStat Menus preferences: `File/Import Settings...`, select `iStat Menus Settings.ismp`. Drag & drop menu bar items with ⌘+drag
- Quickly download audio & video with [`yt`](https://github.com/ddelange/yt)
  ```bash
  brew install ddelange/brewformulae/yt
  ```


### [pyenv](https://github.com/pyenv/pyenv/blob/master/COMMANDS.md#command-reference) and [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv#usage)

- Note: pyvenv-virtualenv needs to be initialised in [`~/.bash_profile`](/.bash_profile), or in `~/.bashrc` if both files are [maintained separately](https://github.com/pyenv/pyenv-virtualenv/issues/36#issuecomment-48387008):
  ```bash
  eval "$(pyenv init -)"
  if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
  ```
- Set up latest Python versions
  ```bash
  brew install pyenv pyenv-virtualenv
  # get your favourite python versions - github.com/momo-lab/pyenv-install-latest
  git clone https://github.com/momo-lab/pyenv-install-latest.git "$(pyenv root)"/plugins/pyenv-install-latest
  git clone git://github.com/concordusapps/pyenv-implict.git "$(pyenv root)"/plugins/pyenv-implict
  # list all available python versions
  pyenv install -l | grep '^\s*[0-9]'
  pyenv install-latest 2.7
  pyenv install-latest 3.7
  pyenv install-latest 3.8
  pyenv global $(pyenv install-latest --print 3.7) $(pyenv install-latest --print 2.7)  # set default versions: prefer py3 over py2
  source ~/.bash_profile  # make them visible
  pip2.7 install --upgrade pip setuptools wheel Cython
  pip3.7 install --upgrade pip setuptools wheel Cython
  pip3.8 install --upgrade pip setuptools wheel Cython
  # install virtualenv 'vv' based latest pyenv Python version 3.7, inheriting installed packages
  pyenv virtualenv $(pyenv install-latest --print 3.7) --system-site-packages vv
  pyenv virtualenv $(pyenv install-latest --print 2.7) --system-site-packages vv27
  pyenv virtualenv $(pyenv install-latest --print 3.8) --system-site-packages vv38
  ```
- Manage envs
  ```bash
  pyenv virtualenvs
  pyenv virtualenv --system-site-packages <venv-name>
  pyenv activate <venv-name>
  pyenv deactivate
  pyenv uninstall <venv-name>
  ```


### Git with 2FA

[Enable and set up 2FA](https://gist.github.com/ateucher/4634038875263d10fb4817e5ad3d332f). It's recommended to first delete any git configurations locally after enabling 2FA.

- Use built-in keychain and app password from above, and add a Mac specific global gitignore:
  ```bash
  git config --global user.name "ddelange"
  git config --global user.email "14880945+ddelange@users.noreply.github.com"  # https://github.com/settings/emails
  git config --global credential.helper osxkeychain

  curl -sLw "\n" "http://gitignore.io/api/macos,python,django,sublimetext" >> ~/.gitignore  # for all possibilities see http://gitignore.io/api/list
  git config --global core.excludesfile "~/.gitignore"
  ```
- Note: it's advised to add [commit signature verification](https://help.github.com/en/articles/managing-commit-signature-verification) to Git.
- [Generate a GPG key](https://help.github.com/en/articles/generating-a-new-gpg-key#generating-a-gpg-key) and tell Git to use it:
  ```bash
  brew install gpg
  gpg --full-generate-key  # recommended settings: enter, 4096, enter
  gpg --list-secret-keys --keyid-format LONG  # copy the key after 'sec  4096R/'
  gpg --armor --export <key-here>  # paste this key at github.com/settings/keys
  git config --global user.signingkey <key-here>
  git config --global commit.gpgsign true
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
```


##### Split diff

```bash
pip install git+https://github.com/jeffkaufman/icdiff.git  # usage: 'git df' using 'less' or 'git icdiff' without 'less'
git config --global --replace-all core.pager 'less -+$LESS -eFRSX'  # with double quotes, $ will be evaluated
git config --global icdiff.options "--highlight --line-numbers --numlines=3"
git config --global difftool.icdiff.cmd 'icdiff --highlight --line-numbers --numlines=3 $LOCAL $REMOTE'
```

##### Mergetool

On failed automatic merge, use Sublime Merge GUI for conflict resolution using `git mergetool` or `git mt` (see below).
```bash
git config --global mergetool.smerge.cmd 'smerge mergetool "$BASE" "$LOCAL" "$REMOTE" -o "$MERGED"'
git config --global mergetool.smerge.trustExitCode true
git config --global mergetool.keepBackup false
git config --global merge.tool smerge
```


##### Aliases

```bash
git config --global alias.st "status"
git config --global alias.cm "commit"
git config --global alias.ca "commit -am"
git config --global alias.cap '! f() { git commit -am "$@" && git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)"; }; f'
git config --global alias.camend "commit --amend -am"
git config --global alias.amend "commit --amend --no-edit -a"
git config --global alias.br "branch"
git config --global alias.co "checkout"
git config --global alias.mt "mergetool"
git config --global alias.lg "log --graph --decorate --pretty=oneline --abbrev-commit"
git config --global alias.fp "fetch -p --all"  # purge and fetch all remotes
git config --global alias.defaultbranch '! f() { echo $(git remote show origin | grep "HEAD branch" | cut -d ":" -f 2 | xargs); }; f'  # https://stackoverflow.com/questions/28666357#comment101797372_50056710
git config --global alias.df '! f() { git icdiff --color=always "$@" | less -eR; }; f'  # no FX (keep output in terminal)
git config --global alias.pr '! git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)"'  # push a new branch. will be overwritten if git-extras is installed
git config --global alias.dm '! git fetch -p && for branch in `git branch -vv | grep '"': gone] ' | awk '"'{print $1}'"'"'`; do git branch -D $branch; done'  # 'delete merged' - local branches that have been deleted on remote
git config --global alias.gg '! f() { git checkout "${1:-$(git defaultbranch)}" && git dm && git pull; }; f'  # git gg develop -- no arg: defaultbranch. Return to default branch (or specified branch), delete merged, pull branch
git config --global alias.pall '! f() {     START=$(git branch | grep "\*" | sed "s/^.//");     for i in $(git branch | sed "s/^.//"); do         git checkout $i;         git pull || break;     done;     git checkout $START; }; f'  # 'pull all' - pull local branches that have been updated on remote
git config --global alias.undo '! f() { git reset --hard $(git rev-parse --abbrev-ref HEAD)@{${1-1}}; }; f'  # https://megakemp.com/2016/08/25/git-undo/
git config --global alias.squashlast '"!f(){ git reset --soft HEAD~${1} && git commit --edit -m\"$(git log --format=%B --reverse HEAD..HEAD@{1})\"; };f"' # Squash the last x commits; will prompt you with auto-squashed commit messages
git config --global alias.alias "! git config --get-regexp '^alias\.' | sed -e s/^alias\.// | grep -v ^'alias ' | sed 's/ /#/' | column -ts#"
```


### Kubernetes CLI ([kubectl](https://kubernetes.io/docs/reference/kubectl/))

Kubectl is a command line interface for running commands against Kubernetes clusters (like viewing logs or executing commands on pods).
See this [Kubectl Cheatsheet](https://gist.github.com/ddelange/24575a702a10c2cb6348c4c7f342e0eb) for plug & play bash functions (they are already in [`~/.bash_profile`](/.bash_profile)).


### Cleanup ([different options](https://github.com/Homebrew/brew/issues/3784#issuecomment-364675767))

```bash
brew cleanup --prune=0  # delete cache older than 0 days
```


### [Fancy Dropbox screen shot sharing](https://github.com/ddelange/mac-smart-bitly-shortcut)

AppleScript to shorten links using the bitly API in a smart way directly with a keyboard shortcut


### [Gigabit USB Driver OS X 10.9+](https://www.asix.com.tw/products.php?op=pItemdetail&PItemID=131;71;112)

Not needed for recent machines, it is now built-in.

For almost any [Gigabit Ethernet USB hub](https://www.ebay.com/itm/3-Ports-USB-3-0-Hub-Gigabit-Ethernet-Lan-RJ45-Network-Adapter-Hub-Hot-Lot-YT/183586523117)
- Unzip [`AX88179_178A_macintosh_Driver_Installer_v2.13.0.zip`](/AX88179_178A_macintosh_Driver_Installer_v2.13.0.zip)
- Install driver `pkg` from `AX88179_178A.dmg`
- Restart


### Misc

- To revert to the classic iTunes playlist view from before v12.6:
  - Open your iTunes library
  - Open and run [`Restore old iTunes playlists view.scpt`](/Restore%20old%20iTunes%20playlists%20view.scpt).
- Scroll horizontally using shift + mouse wheel


### TODO

- LaTeX opruimen, Dougs applescripts, [Show in Playlists](http://dougscripts.com/itunes/scripts/ss.php?sp=showinplaylists)
- SHORTCUTS.md: cmd L, fn+backspace, ⌘-⌥-V, lock, cmd space, screenshots, shortcut changing, cmd shift T, control up/down, cmd ~ or \` to switch windows, ~. to stop ssh, ⌘-^-space for emoji chooser
- add low battery warning plist
- automate this repo with zero.sh, e.g. https://github.com/msanders/setup
