;; ========== BASICS ==========
;; Remove GUI elements
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Set font
(set-face-attribute 'default nil
		    :font "JetBrains Mono"
		    :height 160
		    :weight 'regular)

;; Set theme
;; (load-theme 'wombat t)

;; Remove bell sound and introduce a flash instead
(setq visible-bell t)

;; Enable relative line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

;; Enable electric-pair-mode for auto-closing pairs
(electric-pair-mode 1)

;; Autosave files to a seperate directory
;; Move auto-save files to a dedicated directory
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/auto-saves/" t)))

;; Create the directory if it doesn't exist
(unless (file-exists-p "~/.emacs.d/auto-saves/")
  (make-directory "~/.emacs.d/auto-saves/" t))

;; Backup in secondary directory
(setq backup-directory-alist
      `(("." . "~/.emacs.d/backups")))
(setq make-backup-files t)

;; Create the directory if it doesn't exist
(unless (file-exists-p "~/.emacs.d/backups")
  (make-directory "~/.emacs.d/backups" t))

;; For EMACS installed via snap to access .local
(setenv "PATH"
	(concat (getenv "PATH") ":/home/ajsarmah/.local/bin"))
(add-to-list 'exec-path "/home/ajsarmah/.local/bin")
(let ((nvm-bin (expand-file-name "~/.nvm/versions/node/*/bin")))
  (dolist (dir (file-expand-wildcards nvm-bin))
    (when (file-directory-p dir)
      (setenv "PATH" (concat dir ":" (getenv "PATH")))
      (add-to-list 'exec-path dir))))





;; ========== PACKAGES SETUP  ==========
;; Set up package repositories
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Refresh package contents on first run
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t) ; Auto-install packages




;; ========== PACKAGES ==========
;; Install and configure Ivy
(use-package ivy
	     :config
	     (ivy-mode 1)
	     (setq ivy-use-virtual-buffers t)
	     (setq enable-recursive-minibuffers t))

;; Install and configure rainbow-delimiters
(use-package rainbow-delimiters
	     :hook (prog-mode . rainbow-delimiters-mode))

;; Install and configure which-key
(use-package which-key
	     :config
	     (which-key-mode)
	     (setq which-key-idle-delay 0.3))  ; Show popup after 0.3 seconds

;; Doom Mode line
(use-package nerd-icons)
;; after installing run M-x nerd-icons-install-fonts

;; Improve font rendering performance on Linux
(setq inhibit-compacting-font-caches t)

(use-package doom-modeline
	     :init
	     ;; Enable doom-modeline as early as possible
	     (doom-modeline-mode 1)

	     :custom
	     ;; Modeline size & style
	     (doom-modeline-height 24)
	     (doom-modeline-bar-width 2)
	     (doom-modeline-hud nil)

	     ;; Icons
	     (doom-modeline-icon t)
	     (doom-modeline-major-mode-icon t)

	     ;; Clean up noise
	     (doom-modeline-minor-modes nil)
	     (doom-modeline-buffer-encoding nil)
	     (doom-modeline-indent-info nil)

	     ;; Diagnostics (less aggressive)
	     (doom-modeline-checker-simple-format t)

	     ;; Buffer name style
	     (doom-modeline-buffer-file-name-style 'relative-from-project))

;; THEMES
;;(use-package doom-themes
;;	     :config
;;	     (load-theme 'doom-one t))
(use-package catppuccin-theme
  :config
  (setq catppuccin-flavor 'mocha)  ; Options: 'latte, 'frappe, 'macchiato, 'mocha
  (load-theme 'catppuccin t))

;; TREE SITTER
;; Enable Tree-sitter when available
;; Upon first install manually install the tree sitter files via M-x treesit-install-language-grammer
(setq treesit-font-lock-level 4)

(setq treesit-language-source-alist
      '((javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
	(typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
	(python "https://github.com/tree-sitter/tree-sitter-python")
	(css "https://github.com/tree-sitter/tree-sitter-css")
	(c "https://github.com/tree-sitter/tree-sitter-c")
	(cpp "https://github.com/tree-sitter/tree-sitter-cpp")
	(json "https://github.com/tree-sitter/tree-sitter-json")))

;; Use Tree-sitter modes automatically
(setq major-mode-remap-alist
      '((python-mode . python-ts-mode)
	(c-mode      . c-ts-mode)
	(c++-mode    . c++-ts-mode)
	(js-mode     . js-ts-mode)
	(javascript-mode . js-ts-mode)
	(typescript-mode . typescript-ts-mode)
	(json-mode   . json-ts-mode)
	(css-mode    . css-ts-mode)))

(setq treesit-extra-load-path nil)


;; ========== EVIL ==========
;; Install and configure Evil mode
(use-package evil
	     :init
	     (setq evil-want-integration t)
	     (setq evil-want-keybinding nil)
	     (setq evil-undo-system 'undo-redo)
	     :config
	     (evil-mode 1)
	     (evil-define-key 'normal 'global-map
			      (kbd "gd") #'xref-find-definitions  ; Go to def (already M-, but gd is Vim-like)
			      (kbd "gr") #'xref-find-references
			      (kbd "K") #'eldoc-doc-buffer  ; Hover docs
			      (kbd "SPC c a") #'eglot-code-actions  ; Leader = , or SPC
			      (kbd "SPC r n") #'eglot-rename)

	     ;; Use Emacs state (normal Emacs keybindings) in these modes
	     (setq evil-emacs-state-modes
		   '(dired-mode
		      eshell-mode
		      term-mode
		      ansi-term-mode
		      shell-mode
		      help-mode
		      Info-mode
		      package-menu-mode
		      compilation-mode
		      grep-mode
		      occur-mode
		      ibuffer-mode
		      flycheck-error-list-mode
		      git-rebase-mode))


	     ;; Keep window/frame management in Emacs keybindings globally
	     (define-key evil-normal-state-map (kbd "C-x") nil)  ; Free up C-x prefix
	     (define-key evil-insert-state-map (kbd "C-x") nil)
	     (define-key evil-visual-state-map (kbd "C-x") nil)

	     (define-key evil-normal-state-map (kbd "C-c") nil)  ; Free up C-c prefix
	     (define-key evil-insert-state-map (kbd "C-c") nil)
	     (define-key evil-visual-state-map (kbd "C-c") nil)

	     (define-key evil-normal-state-map (kbd "C-h") nil)  ; Free up C-h for help
	     (define-key evil-insert-state-map (kbd "C-h") nil)
	     (define-key evil-visual-state-map (kbd "C-h") nil))



;; ========== KEYBINDINGS ==========
(global-set-key (kbd "C-x C-b") 'ivy-switch-buffer)




;; ========== LSP ==========
(use-package eglot
	     :ensure nil ;; built-in
	     :hook
	     ((c-ts-mode
		c++-ts-mode
		python-ts-mode
		js-ts-mode
		typescript-ts-mode) . eglot-ensure)
	     :config
	     ;; Prefer performance & simplicity
	     (setq eglot-autoshutdown t)
	     (setq eglot-sync-connect 0)
	     (setq eglot-events-buffer-size 0))

;; --------- SET IF NOT SET IN EVIL -----------
;; Go to definition
;; (global-set-key (kbd "M-,") #'xref-find-definitions)

;; Find references
;; (global-set-key (kbd "M-?") #'xref-find-references)

;; Rename symbol
;; (global-set-key (kbd "C-c r") #'eglot-rename)

;; Code actions
;; (global-set-key (kbd "C-c a") #'eglot-code-actions)

;; Display Docs
(setq eldoc-echo-area-use-multiline-p t)

;; For Flatpak
;; (with-eval-after-load 'eglot
;;		      (add-to-list 'eglot-server-programs
;;				   '((c-ts-mode c++-ts-mode)
;;				     "flatpak-spawn" "--host" "clangd"))
;;		      (add-to-list 'eglot-server-programs
;;				   '(python-ts-mode
;;				      "flatpak-spawn" "--host"
;;				      "/home/ajsarmah/.local/bin/pylsp"))
                      ;; Jsavasceipt / Typescript is prone to bugs because of symlinks (IT IS RECOMMENDED TO NOT USE FLATPAK)
;;		      (add-to-list 'eglot-server-programs
;;				   '((js-ts-mode typescript-ts-mode tsx-ts-mode)
;;				     . ("flatpak-spawn" "--host"
;;					"/home/ajsarmah/.nvm/versions/node/v24.11.1/bin/node"
;;					"/home/ajsarmah/.nvm/versions/node/v24.11.1/lib/node_modules/typescript-language-server/lib/cli.mjs"
;;					"--stdio")))
;;		      )




;; Completion UI
(use-package corfu
	     :ensure t
	     :init
	     (global-corfu-mode)
	     :config
	     ;; Minimal behavior
	     (setq corfu-auto t        ;; popup automatically
		   corfu-cycle t       ;; cycle candidates
		   corfu-preview-current nil))




;; ========== EMACS ==========
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(doom-modeline-check-simple-format t nil nil "Customized with use-package doom-modeline")
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
