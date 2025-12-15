#!/usr/bin/env bash

case "$OS_BASE" in
"debian")
  sudo apt-get update
  sudo apt-get install -y git
  ;;
*)
  echo "Unsupported package manager for OS: $OS, $OS_BASE, please install git manually."
  ;;
esac
