#!/bin/bash

GIT_DIR=${GIT_DIR-~/git/openstack}
REMOTE_BRANCH=${REMOTE_BRANCH-gerrit/master}
PROJECTS=${PROJECTS-"nova glance keystone cinder quantum"}

for p in $PROJECTS; do
    cd $GIT_DIR/$p
    (git cat-file -p $REMOTE_BRANCH:tools/pip-requires; \
     git cat-file -p $REMOTE_BRANCH:tools/test-requires ) | \
        while read line; do echo "$p: $line"; done | grep $@
done
