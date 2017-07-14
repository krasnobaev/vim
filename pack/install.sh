#!/usr/bin/env bash

# Create new folder in ~/.vim/pack that contains a start folder and cd into it.
#
# Arguments:
#   package_group, a string folder name to create and change into.
#
# Examples:
#   set_group syntax-highlighting
#
function set_group () {
  package_group=$1
  path="$HOME/.vim/pack/$package_group/start"
  mkdir -p "$path"
  cd "$path" || exit
}

# Clone or update a git repo in the current directory.
#
# Arguments:
#   repo_url, a URL to the git repo.
#
# Examples:
#   package https://github.com/tpope/vim-endwise.git
#
function package () {
  repo_url=$1
  expected_repo=$(basename "$repo_url" .git)
  if [ -d "$expected_repo" ]; then
    cd "$expected_repo" || exit
    result=$(git pull --force)
    echo "$expected_repo: $result"
  else
    echo "$expected_repo: Installing..."
    git clone -q "$repo_url"
  fi
}

(
set_group staging
package https://github.com/fatih/vim-go.git &
package https://github.com/tpope/vim-rhubarb.git &
package https://github.com/dhruvasagar/vim-table-mode.git &
wait
) &

(
set_group tpope
# package https://github.com/tpope/vim-dispatch.git &
# package https://github.com/tpope/vim-jdaddy.git &
package https://github.com/tpope/vim-fugitive.git &
package https://github.com/tpope/vim-surround.git &
package https://github.com/tpope/vim-ragtag.git &
package https://github.com/tpope/vim-abolish.git &
package https://github.com/tpope/vim-repeat.git &
package https://github.com/tpope/vim-commentary.git &
package https://github.com/tpope/vim-projectionist.git &
# package https://github.com/tpope/vim-vinegar.git &
wait
) &

(
set_group ruby
package https://github.com/tpope/vim-rails.git &
package https://github.com/tpope/vim-rake.git &
package https://github.com/tpope/vim-bundler.git &
package https://github.com/tpope/vim-endwise.git &
wait
) &

(
set_group snippets
# Vim-snipmate and dependencies - VimL but buggy
package https://github.com/MarcWeber/vim-addon-mw-utils.git &
package https://github.com/tomtom/tlib_vim.git &
package https://github.com/garbas/vim-snipmate.git &
# Ultisnips is python but more functional
# package https://github.com/SirVer/ultisnips.git &
wait
) &

(
set_group tmux
package https://github.com/christoomey/vim-tmux-navigator.git &
wait
) &

(
set_group syntax
package https://github.com/kchmck/vim-coffee-script.git &
package https://github.com/tpope/vim-markdown.git &
package https://github.com/ap/vim-css-color.git &
package https://github.com/pearofducks/ansible-vim.git &
package https://github.com/vim-scripts/applescript.vim.git &
package https://github.com/tmux-plugins/vim-tmux.git &
package https://github.com/Matt-Deacalion/vim-systemd-syntax.git &
package https://github.com/salomvary/vim-eslint-compiler.git &
package https://github.com/hashivim/vim-terraform.git &
wait
) &


# (
# set_group colorschemes
# package https://github.com/altercation/vim-colors-solarized.git &
# wait
# ) &

wait

# echo "Plugins that havn't been updated by this script:"
find */*/*/.git -prune -mtime 0.01
