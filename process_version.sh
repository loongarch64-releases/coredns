#!/bin/bash
set -exuo pipefail

VERSION="$1"

ORG='coredns'
PROJ='coredns'
ARCH='loongarch64'
WORKSPACE="/workspace"
SRCS="$WORKSPACE/srcs"
DISTS="$WORKSPACE/dists"
PATCHES="$WORKSPACE/patches"

mkdir -p "$SRCS" "$DISTS/$VERSION"

SRC="$PROJ-$VERSION"

prepare()
{
    pushd $SRCS

    local TAR_FILE="$VERSION.tar.gz"

    if [ ! -f $TAR_FILE ]; then
        wget -O $TAR_FILE --quiet --show-progress "https://github.com/$ORG/$PROJ/archive/refs/tags/v$VERSION.tar.gz"
    fi

    if [ -d $SRC ]; then rm -rf $SRC; fi
    mkdir -p $SRC
    tar -xzf $TAR_FILE -C $SRC --strip-components=1 --no-same-owner --no-same-permissions || true
    popd
}

process()
{
    # patch
    "$PATCHES/patch.sh" $VERSION
   
    pushd "$SRCS/$SRC"
    make
    cp coredns "$DISTS/$VERSION/coredns"
    popd
}


main()
{
    prepare
    process
}

main "$@"
