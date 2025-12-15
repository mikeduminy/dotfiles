#!/usr/bin/env bash

# unrequire sha256 verification for Bartender cask

# snapshot require_sha setting
lOCAL_HOMEBREW_CASK_OPTS_REQUIRE_SHA="$HOMEBREW_CASK_OPTS_REQUIRE_SHA"

# unset it for this installation
unset HOMEBREW_CASK_OPTS_REQUIRE_SHA

# install colemak-dh
brew install --cask colemak-dh

# restore require_sha setting
export HOMEBREW_CASK_OPTS_REQUIRE_SHA="$lOCAL_HOMEBREW_CASK_OPTS_REQUIRE_SHA"
