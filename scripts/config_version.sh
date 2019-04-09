#!/bin/sh
if [ -e $1/$2/.git ]
then
  cd $1/$2
  BRANCH=$(git symbolic-ref --short HEAD | head -c -1)
  COMMIT=$(git rev-parse HEAD | head -c -1)
  echo -n $BRANCH-$COMMIT
fi
