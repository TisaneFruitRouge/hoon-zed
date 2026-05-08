# Hoon for Zed

Local Zed language extension for the [Hoon](https://urbit.org) programming language, ported from the [hoon-vscode](https://github.com/famousj/hoon-vscode) extension.

## Features

- `.hoon` file association
- `::` line comments
- Bracket matching / autoclose for `{}`, `[]`, `()`, `""`, `''`
- Tree-sitter syntax highlighting via [`urbit-pilled/tree-sitter-hoon`](https://github.com/urbit-pilled/tree-sitter-hoon)

## Install as a dev extension

1. Open Zed.
2. Open the command palette → `zed: extensions`.
3. Click **Install Dev Extension** and select this directory.

Zed will fetch and compile the Tree-sitter grammar on first install.

## Notes on the language server

The VSCode extension shipped a `hoon-language-server` integration that talks to a running Urbit ship over HTTP (a non-stdio transport). Zed extensions launch LSPs as stdio subprocesses, so wiring it up here would require a shim. Not implemented.
