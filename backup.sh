#!/bin/sh

USER="${USER:-backup}"
EMAIL="${EMAIL:-backup@example.com}"

DATA="${DATA:-/data}"
CONFIG="${CONFIG:-/config}"
MAP="$CONFIG/map.txt"

backup_repo() {
    repo="$1"
    url="$2"
    dst="$HOME/$repo"
    src="$DATA/$repo"
    
    mkdir -p "$dst"
    cd $dst

    if [ ! -d .git ]; then
        git init
    fi

    if ! git remote get-url origin &>/dev/null; then
        git remote add origin "$url"
    fi

    git pull origin master

    rsync -avzh $src/ $dst/

    git add -A
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    git commit -m "Updated $timestamp"
    git push origin master
}


git config --global user.name "$USER"
git config --global user.email "$EMAIL"

while read repo url; do
  echo "backup \"$repo\" to \"$url\""
  backup_repo "$repo" "$url"
done < $MAP
