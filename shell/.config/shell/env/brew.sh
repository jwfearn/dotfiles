case ":$PATH:" in
  *":/opt/homebrew/bin:"*) ;;
  *) [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)" ;;
esac
