#!/bin/bash

BASE_VERSION=$1
INDEX=0
for f in `ls -1 *.sql`; do
  INDEX=$(($INDEX+1))  
  RF=`printf "%s_%03d__%s" ${BASE_VERSION} $INDEX $f`
  mv $f $RF
done
