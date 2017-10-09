#!/bin/bash
set -o nounset -o errexit -o pipefail

# poc script to recreate a naust file structure in $PWD

# type <type>
repotype() {
  mkdir -p naust/mirror/$1
  mkdir -p naust/snap/$1
}

# repo <type> <reponame>
repo() {
  mkdir -p naust/mirror/$1/$2
  mkdir -p naust/snap/$1/$2
}

# content <type> <reponame> ... per case
content() {
  repotype=$1
  reponame=$2

  case $repotype in
    file)
      filename=$3
      url=$4
      sha256um=$5
      transform=$6
      filepath=naust/mirror/$repotype/$reponame/$filename
      [[ ! -s $filepath ]] && {
        echo naust: content: downloading $url
        curl -# -L "$url" | sha256sum -c <(echo $sha256sum -) |

        echo naust: content: verifying $sha25
        sha256sum -c <(echo $sha256sum $filepath) || {
          echo naust: content: verification failed, removing file
          rm -v $filepath
        } && {
          echo naust: content: verification OK, applying transform
          case $transform in
            xzgz)
              

        }
      }
  esac
}

# process <type> <reponame> ... per case
process() {
  repotype=$1
  reponame=$2
  plugin=$3

  case $repotype in
    file)
      case $plugin in
        xzgz-symlink)
          dirpattern=$4
          filename=$5
  esac

}

# create repo types
repotype file
repotype yum

# create repositories
repo file centos-cloud

# add content
content file centos-cloud CentOS-7-x86_64-GenericCloud-1708.qcow2.gz http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1708.qcow2.xz 0df197d7d41e83afd676867ca97ac7f9d96d42d338eff67ec18d75f932850f3b xzgz


