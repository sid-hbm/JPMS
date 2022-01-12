#!/usr/bin/env bash

green=`tput setaf 2`
reset=`tput sgr0`
red=`tput setaf 1`
yellow=`tput setaf 3`
magenta=`tput setaf 5`
cyan=`tput setaf 6`

trap 'echo ${red}========= the script has been killed ${reset}; exit' INT

function build() {
    export DOCKER_SCAN_SUGGEST=false
    version=$1
    rootDir=$PWD

    if [ -z "$version" ]; then
        echo "${green}====================================================================================="
        echo "${magenta}            Building docker images for all versions ..."
        echo "${green}====================================================================================="
        for d in */ ; do
            cd $rootDir
            [ -L "${d%/}" ] && continue
            if [ "$d" != "gradle/" ] && [ "$d" != "wrapper/" ]; then
                version=${d::-1}
                echo "${yellow}     ============================="
                echo "${magenta}           version $version"
                echo "${yellow}     ============================="
                cd $rootDir/$version
                for t in */; do
                    cd $rootDir/$version
                    [[ -L "${t%/}" || "$tag" == "jdk" ]] && continue
                    tag=${t::-1}
                    dockerfile=$rootDir/$version/$tag/Dockerfile
                    if test -f "$dockerfile"; then
                        cd $tag
                        echo -e "${cyan}\n  ** Building ${magenta}jpms:$version-$tag ${cyan} (directory: $rootDir/$version/$tag)"
                        echo "${cyan}    *** about to run command: docker build -t jpms:$version-$tag ."
                        echo -e "${cyan}    *** and tag the image as docker.io/sidhm/jpms:$version-$tag ${reset}\n"
                        docker build --quiet -t jpms:$version-$tag .
                        docker tag jpms:$version-$tag docker.io/sidhm/jpms:$version-$tag
                    fi
                done
            fi
        done
    else
        cd $rootDir/$version
        echo "${magenta}====================================================================================="
        echo "${magenta}               Building docker images for version $version ..."
        echo "${magenta}====================================================================================="
        for t in */ ; do
            cd $rootDir/$version
            [[ -L "${t%/}" || "$tag" == "jdk" ]] && continue
            tag=${t::-1}
            dockerfile=$rootDir/$version/$tag/Dockerfile
            if test -f "$dockerfile"; then
                cd $tag
                echo -e "${cyan}\n  ** Building ${magenta}jpms:$version-$tag ${cyan} (directory $rootDir/$version/$tag)"
                echo "${cyan}    *** about to run command: docker build -t jpms:$version-$tag ."
                echo -e "${cyan}    *** and tag the image as docker.io/sidhm/jpms:$version-$tag ${reset}\n"
                docker build --quiet -t jpms:$version-$tag .
                docker tag jpms:$version-$tag docker.io/sidhm/jpms:$version-$tag
            fi
        done
    fi
}

function push() {
    export DOCKER_SCAN_SUGGEST=false
    version=$1
    rootDir=$PWD

    if [ -z "$version" ]; then
        echo "${green}====================================================================================="
        echo "${magenta}              Pushing docker images for all versions ..."
        echo "${green}====================================================================================="
        for d in */ ; do
            cd $rootDir
            [ -L "${d%/}" ] && continue
            if [ "$d" != "gradle/" ] && [ "$d" != "wrapper/" ]; then
                version=${d::-1}
                echo "${yellow}     ============================="
                echo "${magenta}           version $version"
                echo "${yellow}     ============================="
                cd $rootDir/$version
                for t in */; do
                    cd $rootDir/$version
                    [[ -L "${t%/}" || "$tag" == "jdk" ]] && continue
                    tag=${t::-1}
                    dockerfile=$rootDir/$version/$tag/Dockerfile
                    if test -f "$dockerfile"; then
                        cd $tag
                        echo -e "${cyan}\n  ** Pushing ${magenta}docker.io/sidhm/jpms:$version-$tag ${cyan}"
                        docker push docker.io/sidhm/jpms:$version-$tag
                    fi
                done
            fi
        done
    else
        cd $rootDir/$version
        echo "${magenta}====================================================================================="
        echo "${magenta}               Pushing docker images for version $version ..."
        echo "${magenta}====================================================================================="
        for t in */ ; do
            cd $rootDir/$version
            [[ -L "${t%/}" || "$tag" == "jdk" ]] && continue
            tag=${t::-1}
            dockerfile=$rootDir/$version/$tag/Dockerfile
            if test -f "$dockerfile"; then
                cd $tag
                echo -e "${cyan}\n  ** Pushing ${magenta}docker.io/sidhm/jpms:$version-$tag ${cyan}"
                docker push docker.io/sidhm/jpms:$version-$tag
            fi
        done
    fi
}

case "$1" in
  build)
    build $2
    ;;
  push)
    push $2
    ;;
  *)
    build $2
    push $2
    ;;
esac