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
set_group tpope
# package https://github.com/tpope/vim-dispatch.git &
# package https://github.com/tpope/vim-jdaddy.git &
package https://github.com/tpope/vim-fugitive.git &
package https://github.com/tpope/vim-surround.git &
# package https://github.com/tpope/vim-ragtag.git &
# package https://github.com/tpope/vim-abolish.git &
package https://github.com/tpope/vim-repeat.git &
# package https://github.com/tpope/vim-commentary.git &
# package https://github.com/tpope/vim-projectionist.git &
# package https://github.com/tpope/vim-markdown.git &
# package https://github.com/tpope/vim-vinegar.git &
wait
) &

(
set_group language
package https://github.com/vim-syntastic/syntastic &
package https://github.com/scrooloose/nerdcommenter &

package https://github.com/plasticboy/vim-markdown &

package https://github.com/pangloss/vim-javascript &
package https://github.com/elzr/vim-json &

package https://github.com/rust-lang/rust.vim &
package https://github.com/racer-rust/racer &

https://github.com/lervag/vimtex
wait
) &

(
set_group completion
package https://github.com/valloric/youcompleteme &
package https://github.com/honza/vim-snippets &
package https://github.com/ervandew/supertab &

package https://github.com/eagletmt/neco-ghc &
wait
) &

(
set_group codedisplay
package https://github.com/altercation/vim-colors-solarized &
package https://github.com/godlygeek/tabular &
wait
) &

(
set_group interface
package https://github.com/scrooloose/nerdtree &
package https://github.com/ctrlpvim/ctrlp.vim &
package https://github.com/vim-airline/vim-airline &
package https://github.com/majutsushi/tagbar &
package https://github.com/airblade/vim-gitgutter &
package https://github.com/thaerkh/vim-workspace &
wait
) &

(
set_group commands
package https://github.com/easymotion/vim-easymotion &
package https://github.com/shougo/vimproc.vim &
wait
) &

(
set_group tmux
package https://github.com/christoomey/vim-tmux-navigator.git &
package https://github.com/tmux-plugins/vim-tmux.git &
wait
) &

(
set_group syntax
package https://github.com/salomvary/vim-eslint-compiler.git &
package https://github.com/hashivim/vim-terraform.git &
wait
) &

wait

# echo "Plugins that havn't been updated by this script:"
find */*/*/.git -prune -mtime 0.01
