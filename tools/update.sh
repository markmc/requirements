#!/bin/bash

GIT_DIR=~/git/openstack
PROJECTS="nova glance keystone cinder quantum"

concat() {
    path=$1; shift

    for p in $PROJECTS; do
        cd $GIT_DIR/$p
        git fetch gerrit
        git cat-file -p gerrit/master:$path
    done | tr A-Z a-z| sed 's/#.*$//; s/ *$//; /^ *$/d' | sort | uniq
}

file_to_regexp() {
    file=$1; shift

    echo -n "\("
    xargs -i echo -n "^{}$\|" < $file
    echo -n "^$\)"
}

concat tools/pip-requires > $GIT_DIR/requirements/tools/pip-requires

exclude=$(file_to_regexp $GIT_DIR/requirements/tools/pip-requires)
concat tools/test-requires | grep -v "$exclude" > $GIT_DIR/requirements/tools/test-requires