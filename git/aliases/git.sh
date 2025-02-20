# Git related aliases

# Environnement variables used to replace the user-dependent "core"
# settings from .gitconfig
export GIT_AUTHOR_NAME="$DOTFILES_USER_DISPLAY_NAME"
export GIT_AUTHOR_EMAIL="$DOTFILES_USER_MAIL"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"


# Make sure that all remote branches have some local equivalent one
# and set each of them to track its remote associated origin.
git_fetch_remotes() {
  # Fetch remote branches and prune (delete) obsolete local branches 
  git fetch origin -p

  # Create new local branches accordingly
  local_branches="$(git branch -l | sed 's:\s*\(\*\)\?\s*::')"
  git branch -r | grep -Ev 'master$' | while read -r remote_b; do 
    local_b=${remote_b#origin/}
    if ! ( echo "$local_branches" | grep -Eq "^${local_b}$" ); then
      git branch "${local_b}" "${remote_b}"
    fi
  done
}

# Display git branch state (branch name or tag or commit ID)
git_branch_state() {
  # N.B. As git command can be aliased by this script (see around line 100),
  # each call to "git" shall be surrounded by parenthesis to force handling
  # the whole "git" command (including other statements aliased behind "git")
  # as a sole subshell. This way, we can avoid messing up with pipes return
  # statuses.
  git symbolic-ref HEAD --short 2>/dev/null || \
    ( git show -s --pretty='%D' 2>/dev/null | grep -Po 'tag: [^\s,]+' | head -n 1;
      return_pipestatus 1; ) || \
    ( git show -s --pretty='detached: %h' 2>/dev/null )
}

# Run a diff-like git command and ignore any difference that is white-space related
git_no_white() {
  git -c "core.whitespace=-trailing-space,-indent-with-non-tab,-tab-in-indent" "$1" \
    -U0 --word-diff-regex='[^[:space:]]' "${@:2}"
}

# Completely erase some file(s) from git history
git_erase_from_history() {
  (
    set -eo pipefail
    git filter-branch  --prune-empty \
      --index-filter "git rm -rf --cached --ignore-unmatch $*" \
      --tag-name-filter cat -- --all
    git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
    git reflog expire --expire=now --all
    git gc --aggressive --prune=now
  )
}

# List most sizeable files within the current git repository
# shellcheck disable=SC2046,SC2089,SC2090
#   No need to use arrays to handle quoting, since *_cmd variables are passed to the "eval" command
git_ls_big_files() {
  for arg in "$@"; do
    if [[ "$arg" =~ ^--min-size= ]]; then
      min_size="${arg#*=}"
      size_filter_cmd="awk '\$2 >= $min_size*2^20'"
    elif [ "$arg" = --ignore-current-tree ]; then
      tree_filter_cmd="grep -vF --file=<(git ls-tree -r HEAD | awk '{print \$3}')"
    else
      echo "Usage: git_ls_big_files [--min-size=<size_in_MiB>] [--ignore-current-tree]"
      return 1
    fi
  done

  git rev-list --objects --all | \
    git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | \
    sed -n 's/^blob //p' | \
    eval $(if [ -v tree_filter_cmd ]; then echo "$tree_filter_cmd"; else echo cat; fi) | \
    eval $(if [ -v size_filter_cmd ]; then echo "$size_filter_cmd"; else echo cat; fi) | \
    sort --numeric-sort --key=2 | \
    cut -c 1-12,41- | \
    $(command -v gnumfmt || echo numfmt) --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest

  unset tree_filter_cmd size_filter_cmd
}

# Grep files within a git repository, without looking into the .git directory (which may take some time...)
alias g=git
alias git_ls='find $(git ls-files) $(git ls-files --others --exclude-standard) -not -type l'
alias gl=git_ls
alias gg="git_ls | xargs grep --color -n"

# If a bash prompt is defined by a theme external to dotfiles (e.g. Bash-It's Powerline),
# then what's left of this alias script is to be ignored (since it focuses on adding git status
# info to the prompt)
if [ "$DOTFILES_ENABLE_EXTERNAL_PROMPT" = true ]; then
  return
fi

# Using this function forces to reset the DOTFILES_LAST_PWD var
# before each time git gets called. Otherwise, when switching branch
# without changing cwd (which happens quite often), git prompt would
# not be updated...
alias git="unset DOTFILES_LAST_PWD; git"

# Trigger this function on each new prompt entry to re-calculate
# Git branch state for the current working directory
git_prompt_command() {
  # shellcheck disable=SC2155 
  # Return code isn't used here
  local new_pwd="$(pwd)"
  if [ "$new_pwd" != "$DOTFILES_LAST_PWD" ]; then
    if git rev-parse --is-inside-work-tree 2>/dev/null 1>&2; then
      # shellcheck disable=SC2034 
      # Variable DOTFILES_GIT_BRANCH_STATE is used in EXTRA_PS1
      DOTFILES_GIT_BRANCH_STATE="$(git_branch_state 2>/dev/null | sed 's/\(.\+\)/\(\1\)/')"
    else
      unset DOTFILES_GIT_BRANCH_STATE
    fi
  fi
  DOTFILES_LAST_PWD="$new_pwd"
}

PROMPT_COMMAND="git_prompt_command; $PROMPT_COMMAND"

# Set EXTRA_PS1 variable (used by dotfiles's bash_prompt.sh script)
# to display the current git branch state (branch name or tag or commit ID)
# shellcheck disable=SC2016 disable=SC2034
# (EXTRA_PS1 is a contribution to PS1, used by another script)
EXTRA_PS1='$(command -v git > /dev/null && echo "$DOTFILES_GIT_BRANCH_STATE" )'

