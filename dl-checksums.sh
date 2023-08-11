#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/stakater/Reloader/releases/download

# https://github.com/stakater/Reloader/releases/download/v0.0.126/Reloader_v0.0.126_linux_amd64.tar.gz

dl() {
    local ver=$1
    local app=$2
    local lchecksums=$3
    local os=$4
    local arch=$5
    local archive_type=${6:-tar.gz}
    local platform="${os}_${arch}"
    local file="${app}_v${ver}_${platform}.${archive_type}"
    local url="$MIRROR/v$ver/$file"
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    local app=$2
    # https://github.com/stakater/Reloader/releases/download/v0.0.126/Reloader_0.0.126_checksums.txt
    local url="$MIRROR/v$ver/${app}_${ver}_checksums.txt"
    local lchecksums="$DIR/${app}_${ver}_checksums.txt"
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $app $lchecksums darwin arm64
    dl $ver $app $lchecksums darwin amd64
    dl $ver $app $lchecksums linux 386
    dl $ver $app $lchecksums linux amd64
    dl $ver $app $lchecksums linux arm64
    dl $ver $app $lchecksums linux armv6
    dl $ver $app $lchecksums windows 386
    dl $ver $app $lchecksums windows amd64
    dl $ver $app $lchecksums windows arm64
}

dl_ver ${1:-1.0.36} Reloader
