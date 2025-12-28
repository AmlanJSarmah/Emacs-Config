# Emacs Configuration

This is a minimal, performant, Vim-inspired Emacs configuration built around Evil mode, Tree-sitter, Eglot (built-in LSP), and a clean modern UI inspired by Doom Emacs themes and modeline.

## Features

- **Vim keybindings** via Evil mode with undo-redo system
- **Modern UI**:
  - No toolbar, menu bar, or scroll bars
  - Doom-one theme
  - Doom modeline with icons (via nerd-icons)
  - JetBrains Mono font (height 120)
- **Enhanced editing**:
  - Relative line numbers
  - Rainbow delimiters in programming modes
  - Electric pair mode (auto-closing brackets/quotes)
  - Which-key for discovering keybindings
  - Ivy for completion and buffer switching
- **Advanced syntax highlighting** via Tree-sitter (for C/C++, Python, JavaScript/TypeScript, CSS, JSON)
- **LSP support** via built-in Eglot with:
  - Auto-start in supported programming modes
  - Auto-format on save
  - Code actions, rename, go-to-definition, find references
- **Completion** via Corfu (minimal popup completion)
- **Safe file handling**:
  - Autosaves → `~/.emacs.d/auto-saves/`
  - Backups → `~/.emacs.d/backups/`

## Important Notes for Reproducing on a New Machine

To ensure this configuration works correctly on a fresh system, remember the following steps and requirements:

1. **Font Installation**  
   Install **JetBrains Mono** system-wide. Without it, Emacs will fall back to a default font.

2. **Nerd Icons**  
   After the first Emacs launch (once `nerd-icons` is installed):  
   Run `M-x nerd-icons-install-fonts`  
   This downloads and installs the required icon fonts for doom-modeline.

3. **Tree-sitter Language Grammars**  
   Tree-sitter modes are enabled, but grammars are not bundled.  
   After first launch, run:  
   `M-x treesit-install-language-grammar`  
   Then install the grammars you need (e.g., javascript, typescript, python, c, cpp, css, json).

4. **Language Servers (for LSP/Eglot)**  
   Ensure the following are installed and accessible in your `PATH`:
   - `clangd` (for C/C++)
   - `pylsp` or `pyright` (for Python) — preferably via `pip install python-lsp-server` or similar
   - `typescript-language-server` (for JS/TS) — via `npm install -g typescript-language-server typescript`

5. **Node.js and NVM**  
   The config automatically detects and adds Node binaries from `~/.nvm` to `PATH` and `exec-path`.  
   If you use NVM, make sure at least one Node version is installed.

6. **Directory Creation**  
   The config automatically creates:
   - `~/.emacs.d/auto-saves/`
   - `~/.emacs.d/backups/`  
   No manual action needed unless permissions prevent creation.

7. **First Launch Behavior**  
   On a completely fresh Emacs install:
   - Emacs will download packages from MELPA/GNU ELPA (requires internet)
   - It will auto-install `use-package` and all declared packages
   - Expect some delay on first startup

8. **Known Environment Assumptions**  
   - Linux environment (some tweaks like `inhibit-compacting-font-caches` are Linux-specific)
   - Emacs 29+ (required for built-in Tree-sitter and Eglot features used here)
   - Not designed for Flatpak/Snap confinement without additional tweaks (commented-out Flatpak wrappers exist but are disabled)

9. **Warning: Hard-Coded Paths**  
   This configuration contains a hard-coded user path: `/home/ajsarmah/.local/bin`.  
   On a new machine or different user account, this path will not exist or be incorrect, causing Emacs to fail to add that directory to `PATH` and `exec-path`.  
   This may prevent access to tools installed in `~/.local/bin` (e.g., custom scripts or binaries).  
   **Before using on a new system, edit the line**:
   ```elisp
   (add-to-list 'exec-path "/home/ajsarmah/.local/bin")
   ```
   and the corresponding `setenv` call to use your actual username or remove it if not needed.

Follow these steps in order, and your Emacs environment should be fully reproduced with the same look, feel, and functionality.
