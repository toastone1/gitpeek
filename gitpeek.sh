#!/bin/bash

# gitpeek - Zeigt Git-Status für alle Repos im aktuellen Verzeichnis (und Unterverzeichnissen) an


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

show_git_status() {
    local dir=$1
    cd "$dir" || return

    if [ -d .git ]; then
        echo -e "${YELLOW}Repo: ${dir}${NC}"


        local branch=$(git branch --show-current 2>/dev/null)
        if [ -z "$branch" ]; then
            branch="Kein Branch (Detached HEAD)"
        fi
        echo -e "  Branch: ${branch}"


        local status=$(git status --porcelain 2>/dev/null)
        if [ -z "$status" ]; then
            echo -e "  Status: ${GREEN}Working tree clean${NC}"
        else
            echo -e "  Status: ${RED}Uncommitted changes${NC}"
            echo "$status" | sed 's/^/    /'
        fi


        local last_commit=$(git log --oneline -1 2>/dev/null)
        if [ -n "$last_commit" ]; then
            echo -e "  Letzter Commit: ${last_commit}${NC}"
        fi

        echo ""
    fi
}


export -f show_git_status

find . -type d -name .git -prune -execdir bash -c 'show_git_status "$PWD"' \;
