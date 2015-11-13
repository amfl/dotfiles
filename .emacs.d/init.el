;; Prelude ---------------------------------------------------------------- {{{1

(add-to-list 'load-path "~/.emacs.d")

;; Local Package Config --------------------------------------------------- {{{1
;; This section is for files bundled with my dotfiles.

;; Load up the package manager. This is a set of convenience methods for
;; interacting with the package manager built-in to emacs.
;; Primary, it gives us access to `require-package`.
(require 'amfl-package-manager)

(require 'colorful-points)  ; For collaborative editing.

(require 'evennia-mode)     ; Mode for writing scripts for the mu* framework, evennia.

;; Package Config --------------------------------------------------------- {{{1

;; (require 'amfl-evil) ;  Enable evil stuff {{{2

(require-package 'paredit) ; Crazy lispy editing! {{{2
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'clojure-mode-hook          #'enable-paredit-mode)

(require-package 'rudel) ; Collaborative editing  {{{2
(global-rudel-minor-mode 1)

;; (require 'vimish-fold)

; Color scheme
(require-package 'gruvbox-theme)
(load-theme 'gruvbox t)

(require-package 'rainbow-delimiters)  ; Color parens based on nesting {{{2
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(require-package 'nlinum)   ; Show line numbers on the side of emacs. {{{2
(setq nlinum-format "%d ")  ; Show space between line numbers and text
(global-nlinum-mode t)      ; Always show line numbers

(require-package 'markdown-mode) ; Edit markdown {{{2
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(require-package 'cider) ; Live clojure editing {{{2
(add-hook 'cider-mode-hook #'eldoc-mode)

;; Remaps ----------------------------------------------------------------- {{{1

;; Menu bar off by default, toggled with F9
(menu-bar-mode -1)
(global-set-key [f9] 'toggle-menu-bar-mode-from-frame)
