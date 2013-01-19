#!/usr/bin/env bash
set -e

STASH=~/.dotfiles_stash
WD=$(pwd)
dotfiles=(custom_ps1 vimrc gitconfig hgrc)

function regular_file {
    [[ -f $1 ]] || return 1
    [[ -h $1 ]] && return 1
    return 0
}

function deployed_file {
    [[ -h ~/.$1 && $(readlink ~/.$1) = $WD/$1 ]]
    return $?
}

function apply {
    [[ -z $STASH ]] && return 1

    if [[ -d $STASH ]]; then
        echo "Dotfiles already deployed!"
        return 1
    else
        mkdir $STASH
    fi

    for file in ${dotfiles[*]}; do
        echo -n "Deploying $file..."
        if [[ ! -e ~/.$file ]] || regular_file ~/.$file; then
            [[ -e ~/.$file ]] && mv ~/.$file $STASH/$file
            ln -s $WD/$file ~/.$file
            echo "done"
        else
            echo "skipped"
        fi
    done
}

function revert {
    [[ -z $STASH ]] && return 1

    if [[ ! -d $STASH ]]; then
        echo "Can't revert to old dotfiles!"
        return 1
    fi

    for file in ${dotfiles[*]}; do
        echo -n "Reverting $file..."
        if deployed_file $file; then
            rm ~/.$file
            [[ -f "$STASH/$file" ]] && mv $STASH/$file ~/.$file
            echo "done"
        else
            echo "skipped"
        fi
    done

    [[ -z $(ls -A $STASH) ]] && rmdir $STASH
}

function deploy_status {
    if [[ ! -z $STASH && -d $STASH ]]; then
        echo "Deployed!"
    else
        echo "Not deployed."
    fi
}

function usage {
    echo "$0 <action>"
    echo ""
    echo -e "\tapply\tapply dotfiles"
    echo -e "\trevert\trevert to old dotfiles"
    echo -e "\tstatus\tshow current deploy status"
    echo ""
}

case $1 in
    apply) apply;;
    revert) revert;;
    status) deploy_status;;
    *) usage;;
esac

