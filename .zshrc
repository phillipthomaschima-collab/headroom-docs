eval "$(pyenv init --path)"

# Homebrew SQLite (keg-only) ahead of macOS system sqlite3
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
# Compiler/pkg-config flags so builds link against Homebrew SQLite (append-safe)
export LDFLAGS="-L/opt/homebrew/opt/sqlite/lib${LDFLAGS:+ $LDFLAGS}"
export CPPFLAGS="-I/opt/homebrew/opt/sqlite/include${CPPFLAGS:+ $CPPFLAGS}"
export PKG_CONFIG_PATH="/opt/homebrew/opt/sqlite/lib/pkgconfig${PKG_CONFIG_PATH:+:$PKG_CONFIG_PATH}"

. "$HOME/.local/bin/env"
