#!/bin/sh

DOTPATH=~/dotfiles

# ディレクトリが存在しなければ先にDL
if [ ! -e "${$HOME}/dotfiles" ]; then
  echo "fetching dotfiles repository..."

  # git が使えるなら git
  if has "git"; then
    git clone --recursive "https://github.com/kurupeku/dotfiles.git" "$DOTPATH"

  # 使えない場合は curl か wget を使用する
  elif has "curl" || has "wget"; then
    tarball="https://github.com/kurupeku/dotfiles/archive/master.tar.gz"

    # どっちかでダウンロードして，tar に流す
    if has "curl"; then
      curl -L $tarball
    elif has "wget"; then
      wget -O - $tarball
    fi | tar zxv

    mv -f dotfiles-master "$DOTPATH"
  else
    die "curl or wget required"
  fi

  cd ~/.dotfiles
  if [ $? -ne 0 ]; then
    die "not found: $DOTPATH"
  fi

  echo "fetched my dotfiles"
fi

# dotfileのシンボリックリンクを作成
for f in .??*; do
  [ "$f" = ".git" ] && continue
  [ "$f" = ".gitignore" ] && continue
  [ "$f" = ".DS_Store" ] && continue
  [ "$f" = ".config" ] && continue

  ln -snf $DOTPATH/"$f" $HOME/"$f"
done

mkdir -p "${DOTPATH}/.config/nvim"
ln -snfv "${DOTPATH}/.vimrc" "${HOME}/.config/nvim/init.vim"

# OSの判定
. $DOTPATH/modules/scripts/define_os.sh

# OS個別のインストール作業
if [ $OS = "Mac" ]; then
  brew install vim 
  brew install nvim
  brew cleanup
elif [ $OS = "CentOS" ]; then
  yun install -y vim nvim
elif [ $OS = "Ubuntu" ]; then
  apt install -y vim nvim
fi
