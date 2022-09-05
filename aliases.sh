# Artisan
alias tinker='artisan tinker'
alias route='a route:list'
alias a='art'
alias artisan='art'
alias sail='bash vendor/bin/sail'
alias myip='curl ipinfo.io/ip'

serve() {
  if [ -f bin/artisan ]; then
    php bin/artisan serve;
  else
    php -S localhost:8000 -t public;
  fi
}

art() {
  if [ -f bin/artisan ]; then
    php bin/artisan "$@"
  else
    php artisan "$@"
  fi
}

al() {
  tail -f -n 450 storage/logs/laravel*.log | grep -i -E "^\[\d{4}\-\d{2}\-\d{2} \d{2}:\d{2}:\d{2}\]|Next [\w\W]+?\:" --color
}

off() {
  sudo service apache2 stop;
  sudo service postgresql stop;
  sudo service mysql stop;
  sudo service mongodb stop;
  sudo systemctl stop redis;
}

# Docker
alias dcup='docker-compose up -d'
alias dcec='docker-compose exec'
alias dcdo='docker-compose down'

unit() {
  if [ -f vendor/bin/phpunit ]; then
    ./vendor/bin/phpunit $@
  else
    phpunit $@
  fi
}

# Funcionais

alias last-line='wc -l'
alias line='last-line'
alias c='code .'
alias ..='cd ..'
alias source-aliases='source ~/.zshrc'
alias sc='source-aliases'
alias ea='code -a ~/aliases.sh'
alias fpath='tl 1 | grep -i' # Find Path

cswap() {
  sudo su -c "echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a && printf '\n%s\n' 'Ram-cache and Swap Cleared'" ;
}

# Find in file
ff() {
  cat $1 | grep -i $2;
}

tl() {
  if [ $# -eq 0 ]; then
    nested=1;
  else
    nested=$1;
  fi

  tree -dsLhDC $nested;
}

# Git

alias branch='git branch | grep \* | cut -d " " -f2'
alias bt='git branch | grep \* | cut -d "_" -f2'
alias gpush='git push'
alias gpull='git pull'
alias last-commit="git log -1 | grep commit | cut -d ' ' -f 2"
alias cp-lst-commit="last-commit | xclip -selection clipboard"
alias clone='git clone'
alias commit='git commit -am '
alias reset='git reset'
alias status='git status'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glc="gl --grep="
alias nah="git reset --hard && git clean -df"
alias gpu="gpull"
alias gps="gpush"
alias gb="git branch"
alias gcf="checkoutf"
alias gcb="checkoutb"
alias gc="checkout"
alias gs='status'
alias gde="git branch -D"
alias wip='git add . && git commit -m "Wip"'
alias checkoutb="checkout -b "
alias stash='git stash'
alias gsa='stash -u "Wip"'

gtag() {
  tag=$1;
  branch=$(branch);

  git add .;
  stash save "WIP $tag" -u;
  gc master;
  gpu origin master;
  git tag $tag;
  git push origin --tags;
  gc $branch;
  stash apply stash@{0};
}

gpsu(){
  branch=$(branch);

  gps -u origin $branch;
}

ggt(){
  git log --grep=$1 --reverse | grep -i commit | cut -d ' ' -f 2
}

flow-feature() {
  git flow config | grep -i "feature branch prefix" | cut -d " " -f 4;
}

flow-next() {
  git flow config | grep -i "release\" development:" | cut -d " " -f 7;
}

cc() {
  branch=($1);
  commit=$(last-commit);

  checkout $branch;
  nah;
  gpu;
  cherry $commit;
}

ccb() {
  branch=($1);
  ticket=$(bt);
  commits=$(ggt $ticket);

  checkout $branch;
  nah;
  gpu;

  actives=$(ggt $ticket);

  for commit in $commits; do
    exist=$(contains $commit $actives);
    echo $actives;
    if [ "$exist" = "0" ]; then
      cherry $commit;
    fi;
  done
}

grenew() {
  branch=($1);

  git branch -D $branch;
  git checkout $branch;
  git pull origin $branch;
}

gffs() {
  name=($1);
  feature=$(flow-next);

  git checkout $feature;
  git pull origin $feature;
  git flow feature start $name;
}

gffp() {
  gfred;
  git flow feature publish;
}

gfred() {
  active=$(branch);
  feature=$(flow-next);

  git checkout $feature;
  git pull origin $feature;
  git checkout $active;
  git rebase $feature;
}

gfrem() {
  active=$(branch);

  git checkout master;
  git pull origin master;
  git checkout $active;
  git rebase master;
}

gfreb() {
  b=($1);
  active=$(branch);

  git checkout $b;
  git pull origin $b;
  git checkout $active;
  git rebase $b;
}

cherry() {
  code=($1);

  # gpull;
  git cherry-pick --keep-redundant-commits $code;
}

checkout() {
  git checkout $@;
}

checkoutf() {
  feature=$(flow-feature);

  git checkout $feature$1;
}

contains() {
    [[ $2 =~ (^|[[:space:]])$1($|[[:space:]]) ]] && echo 1 || echo 0
}