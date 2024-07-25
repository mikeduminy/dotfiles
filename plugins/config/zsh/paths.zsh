if [ -d "/Applications/Android Studio.app" ]; then
  # add android 'studio' to path if android studio is installed
  export PATH="/Applications/Android Studio.app/Contents/MacOS:$PATH"
fi

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

