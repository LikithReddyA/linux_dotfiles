ls() {
  # Define opts as an array
  local opts=(--icons=always --group-directories-first --color=always)
  local args=()

  # If inside a git repo, add git flag
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    opts+=(--git)
  fi

  # Parse flags
  for arg in "$@"; do
    case "$arg" in
      -l) opts+=(-l) ;;
      -a) opts+=(-a) ;;
      -h) opts+=(-h) ;;
      -r) opts+=(-r) ;;
      -R) opts+=(-R) ;;
      -t) opts+=(--sort=modified) ;;
      --tree) opts+=(-T) ;;
      *) args+=("$arg") ;;  # Anything else is a file/dir
    esac
  done

  # Run eza with safely expanded arguments
  command eza "${opts[@]}" "${args[@]}"
}

# Untrack a file (keep it on disk, remove from repo)
dotfiles-untrack() {
  if [ -z "$1" ]; then
    echo "Usage: dotfiles-untrack <file>"
    return 1
  fi
  dotfiles rm --cached "$1"
  echo "$1" >> ~/.dotfiles-ignore
}
