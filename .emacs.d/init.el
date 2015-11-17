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

(require 'amfl-evil) ;  Enable evil stuff {{{2

(require-package 'paredit) ; Crazy lispy editing! {{{2
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'clojure-mode-hook          #'enable-paredit-mode)

;; (require-package 'rudel) ; Collaborative editing  {{{2
;; (global-rudel-minor-mode 1)

;; (require-package 'vimish-fold)

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

(ensure-package-installed 'helm) ; incremental completion and selection narrowing framework {{{2
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(helm-mode 1)

; Not perfect, but will do for now...
; See also: https://github.com/bbatsov/projectile
(global-set-key (kbd "C-p") 'helm-buffers-list)

(require-package 'evil-nerd-commenter) ;; Comment code - Can be used without evil mode {{{2

;; Emacs key bindings
(global-set-key (kbd "M-;") 'evilnc-comment-or-uncomment-lines)
(global-set-key (kbd "C-c l") 'evilnc-quick-comment-or-uncomment-to-the-line)
(global-set-key (kbd "C-c c") 'evilnc-copy-and-comment-lines)
(global-set-key (kbd "C-c p") 'evilnc-comment-or-uncomment-paragraphs)

;; Vim key bindings - Only active if evil-leader is present
(when (require 'evil-leader nil 'noerror)
    (evil-leader/set-key
    "ci" 'evilnc-comment-or-uncomment-lines
    "cl" 'evilnc-quick-comment-or-uncomment-to-the-line
    "ll" 'evilnc-quick-comment-or-uncomment-to-the-line
    "cc" 'evilnc-copy-and-comment-lines
    "cp" 'evilnc-comment-or-uncomment-paragraphs
    "cr" 'comment-or-uncomment-region
    "cv" 'evilnc-toggle-invert-comment-line-by-line
    "\\" 'evilnc-comment-operator ; if you prefer backslash key
))

(require-package 'yasnippet) ; Snippets  {{{2
(yas-global-mode 1)
; (yas-load-directory "~/.emacs.d/snippets")  ; Custom directory
(add-hook 'term-mode-hook (lambda ()
    (setq yas-dont-activate t)))

;; (require-package 'magit) ; Git integration {{{2
;; (when (require 'evil-leader nil 'noerror)
;;   (evil-leader/set-key
;;     "g" 'magit-status))

;; Remaps, General Config ------------------------------------------------- {{{1

;; Menu bar off by default, toggled with F9
(menu-bar-mode -1)
(global-set-key [f9] 'toggle-menu-bar-mode-from-frame)

;; Always allow the mouse
(xterm-mouse-mode 1)
;; Bind some scroll wheel commands
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key (kbd "<mouse-4>") 'down-slightly)
(global-set-key (kbd "<mouse-5>") 'up-slightly)
(global-set-key (kbd "<C-mouse-4>") 'text-scale-decrease)
(global-set-key (kbd "<C-mouse-5>") 'text-scale-increase)
