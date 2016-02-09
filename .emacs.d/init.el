;; Notes ------------------------------------------------------------------ {{{1

;; M-x describe-function  Function -> Key
;; M-x describe-key       Key -> Function
;; M-x describe-bindings  Shows all bound keys

;; Interesting resources
;;   https://github.com/purcell/emacs.d
;;   http://juanjoalvarez.net/es/detail/2014/sep/19/vim-emacsevil-chaotic-migration-guide/

;; TODO:
;; https://github.com/abo-abo/hydra
;; Map - key to something like dired
;; What is the relationship between autocomplete and company?
;; Flycheck for on the fly code checking
;; Change font size in gui
;; GNUglobal? Like ctags?
;; https://github.com/Malabarba/rich-minority to replace diminish
;; https://github.com/tom-tan/hlinum-mode
;; Spelling

;; Prelude ---------------------------------------------------------------- {{{1

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp")

;; Define a minor mode to contain all my custom keymaps.
;; This mode can simply be disabled to remove the customization.
(defvar amfl-keys-minor-mode-map (make-keymap) "amfl-keys-minor-mode keymap.")

;; Remaps, General Config ------------------------------------------------- {{{1

;; http://emacsredux.com/blog/2013/04/28/switch-to-previous-buffer/
(defun switch-to-previous-buffer ()
    "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
    (interactive)
    (switch-to-buffer (other-buffer (current-buffer) 1)))

;; GUI cruft off by default
(if (display-graphic-p)
  (progn
    (tool-bar-mode -1)
    (scroll-bar-mode -1)))
;; Menu bar off by default, toggled with F9
(menu-bar-mode -1)
(global-set-key [f9] 'toggle-menu-bar-mode-from-frame)

;; Show matching parens
(show-paren-mode t)

;; Simplified from http://stackoverflow.com/questions/6462167/emacsclient-does-not-respond-to-mouse-clicks
(defun amfl-terminal-config (&optional frame)
    "Establish settings for the current terminal."
    ;; Always allow the mouse
    (xterm-mouse-mode 1))
;; Evaluate both now (for non-daemon emacs) and upon frame creation
;; (for new terminals via emacsclient).
(amfl-terminal-config)
(add-hook 'after-make-frame-functions 'amfl-terminal-config)

;; Bind some scroll wheel commands
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key (kbd "<mouse-4>") 'down-slightly)
(global-set-key (kbd "<mouse-5>") 'up-slightly)
(global-set-key (kbd "<C-mouse-4>") 'text-scale-decrease)
(global-set-key (kbd "<C-mouse-5>") 'text-scale-increase)

;; Newline behaviour
(global-set-key (kbd "RET") 'newline-and-indent)

;; Don't need backups or autosaves
;; TODO They should really be enabled, but restricted to their own directrory...
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Local Package Config --------------------------------------------------- {{{1
;; This section is for files bundled with my dotfiles.

;; Load up the package manager. This is a set of convenience methods for
;; interacting with the package manager built-in to emacs.
;; Primary, it gives us access to `require-package`.
(require 'amfl-package-manager)

(require 'colorful-points)  ; For collaborative editing.

(require 'evennia-mode)     ; Mode for writing scripts for the mu* framework, evennia.

;; Third-Party Package Config --------------------------------------------- {{{1

(require-package 'diminish)            ; Don't spam the modeline ---------- {{{2
; (eval-after-load "undo-tree" (diminish 'undo-tree-mode))
;; (eval-after-load 'auto-complete (diminish 'auto-complete-mode))
; (eval-after-load 'projectile (diminish 'projectile-mode))
; (eval-after-load 'yasnippet (diminish 'yas-minor-mode))
; (eval-after-load 'helm-mode (diminish 'helm-mode))
; ;; (eval-after-load 'smartparens (diminish 'smartparens-mode))
; ;; (eval-after-load 'company (diminish 'company-mode))
; (eval-after-load 'magit (diminish 'magit-auto-revert-mode))
; ;; (eval-after-load 'hs-minor-mode (diminish 'hs-minor-mode))
; ;; (eval-after-load 'color-identifiers-mode (diminish 'color-identifiers-mode))

(require 'amfl-evil)                   ; Enable evil stuff ---------------- {{{2
;; Evil stuff is configured in a seperate file

(require-package 'paredit)             ; Crazy lispy editing! ------------- {{{2
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'clojure-mode-hook          #'enable-paredit-mode)

;; (require-package 'rudel)              ; Collaborative editing ------------ {{{2
;; (global-rudel-minor-mode 1)
;;
;; NOTE: This freaks out with evil-mode!
;;       If your collaborator enters insert mode, so will you!

(require-package 'vimish-fold)

;; (require-package 'gruvbox-theme)       ; Theme ---------------------------- {{{2
;; (load-theme 'gruvbox t)

;; https://www.reddit.com/r/emacs/comments/308ibs/2015_emacs_theme_thread/

;; (require-package 'cyberpunk-theme)
;; ;; (color-theme-cyberpunk)
;; (load-theme 'cyberpunk t)

(require-package 'moe-theme)
(powerline-moe-theme)
(moe-dark)

(defun moe-theme-set-color-custom ()
    (set-face-attribute 'mode-line-buffer-id nil :background nil :foreground "#4b4b4b")
    (set-face-attribute 'minibuffer-prompt nil :foreground "#ff0000" :background "#080808")

    (set-face-attribute 'mode-line-inactive nil :background "#4e4e4e" :foreground "#9e9e9e")
    (set-face-attribute 'powerline-active2 nil :background "#3a3a3a" :foreground "#ffffff")
    (set-face-attribute 'powerline-inactive1 nil :background "#626262" :foreground "#eeeeee")
    (set-face-attribute 'powerline-inactive2 nil :background "#767676" :foreground "#e4e4e4")

    (set-face-attribute 'mode-line nil :background "#080808" :foreground "#ffffff")
    (set-face-attribute 'powerline-active1 nil :background "#4e4e4e" :foreground "#bbbbbb"))
(moe-theme-set-color-custom)
;; Update powerline based on evil state
(add-hook 'evil-normal-state-entry-hook (lambda () (moe-theme-set-color 'w/b)))
(add-hook 'evil-insert-state-entry-hook (lambda () (moe-theme-set-color 'red)))
(add-hook 'evil-visual-state-entry-hook (lambda () (moe-theme-set-color 'green)))
(add-hook 'evil-replace-state-entry-hook (lambda () (moe-theme-set-color 'red)))
(add-hook 'evil-operator-state-entry-hook (lambda () (moe-theme-set-color 'yellow)))
(add-hook 'evil-motion-state-entry-hook (lambda () (moe-theme-set-color 'yellow)))

;; (defun my-evil-modeline-change (default-color)
;;  "changes the modeline color when the evil mode changes"
;;  (let ((color (cond ((evil-insert-state-p) 'red)
;; 		      ((evil-visual-state-p) 'green)
;; 		      ((evil-normal-state-p) 'w/b)
;; 		      (t default-color))))
;;    (moe-theme-set-color color)))

;; ;; (lexical-let ((default-color (cons (face-background 'mode-line)
;; ;;                                   (face-foreground 'mode-line))))
;; ;;     (add-hook 'post-command-hook (lambda () (my-evil-modeline-change default-color))))
;; (add-hook 'post-command-hook (lambda () (my-evil-modeline-change 'yellow)))

;; (defadvice evil-insert-state (before emacs-state-instead-of-insert-state activate)
;;     (moe-theme-set-color 'red))
;; (defadvice evil-normal-state (before emacs-state-instead-of-normal-state activate)
;;     (moe-theme-set-color 'green))

(require-package 'rainbow-delimiters)  ; Color parens based on nesting ---- {{{2
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; (require-package 'nlinum)              ; Show line numbers on the side ---- {{{2
;; (setq nlinum-format "%d ")  ; Show space between line numbers and text
;; (global-nlinum-mode t)      ; Always show line numbers
(global-linum-mode t)
(setq linum-format "%d ")
(require-package 'hlinum)
(hlinum-activate)

(require-package 'markdown-mode)       ; Edit markdown -------------------- {{{2
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(require-package 'auto-complete)       ; Autocomplete --------------------- {{{2
(ac-config-default)

(require-package 'cider)               ; Live clojure editing ------------- {{{2
(add-hook 'cider-mode-hook #'eldoc-mode)

(ensure-package-installed 'helm)       ; incremental completion and selection narrowing framework {{{2
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(helm-mode 1)
(diminish 'helm-mode)

; rebind tab to run persistent action
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)  ; GUI
(define-key helm-map (kbd "TAB") 'helm-execute-persistent-action)    ; Terminal

;; Use ag for fast searching
(ensure-package-installed 'ag)
(ensure-package-installed 'helm-ag)

(ensure-package-installed 'helm-projectile)
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)
(diminish 'projectile-mode)

(define-key amfl-keys-minor-mode-map (kbd "C-p") 'helm-projectile)

(require-package 'evil-nerd-commenter) ; Code commenting ------------------ {{{2

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
    "cy" 'evilnc-copy-and-comment-lines
    "cp" 'evilnc-comment-or-uncomment-paragraphs
    "cr" 'comment-or-uncomment-region
    "cv" 'evilnc-toggle-invert-comment-line-by-line
    "cc" 'evilnc-comment-or-uncomment-lines
    "\\" 'evilnc-comment-operator ; if you prefer backslash key
))

(require-package 'yasnippet)           ; Snippets ------------------------- {{{2
(yas-global-mode 1)
; (yas-load-directory "~/.emacs.d/snippets")  ; Custom directory
(add-hook 'term-mode-hook (lambda ()
    (setq yas-dont-activate t)))
(diminish 'yas-minor-mode)

(require-package 'magit)               ; Git integration ------------------ {{{2
(when (require 'evil-leader nil 'noerror)
  (evil-leader/set-key
    "g" 'magit-status))

(require-package 'diff-hl)             ; Highlight source control changes - {{{2
(unless (window-system)
  (setq diff-hl-side 'right)
  (diff-hl-margin-mode))
(global-diff-hl-mode 1)

(require-package 'expand-region)       ; Expand regions by semantic units - {{{2
;; <leader>x to begin, x to expand, z to contract
(eval-after-load "evil" '(setq expand-region-contract-fast-key "z"))
(evil-leader/set-key "xx" 'er/expand-region)
(global-set-key (kbd "C-=") 'er/expand-region) ; Clashes with evil-mode, not sure why.

(require-package 'saveplace)           ; Save place when opening files ---- {{{2
(setq save-place-file "~/.emacs.d/saveplace")
(setq-default save-place t)

;; Postlude --------------------------------------------------------------- {{{1
;; TODO This section is a mess...
;; Info from:
;;   https://bitbucket.org/lyro/evil/issues/511/let-certain-minor-modes-key-bindings
;;   http://stackoverflow.com/questions/683425/globally-override-key-binding-in-emacs

(define-minor-mode amfl-keys-minor-mode
  "A minor mode so my key settings override annoying major modes."
  t " amfl" 'amfl-keys-minor-mode-map)
(diminish 'amfl-keys-minor-mode)

(when(require 'evil-leader nil 'noerror)
    (evil-make-overriding-map amfl-keys-minor-mode-map 'normal) ; Make our keymaps override evil.
)

;; (defadvice load (after give-my-keybindings-priority)
;;   "Try to ensure that my keybindings always have priority."
;;   (unless (eq (caar minor-mode-map-alist) 'amfl-keys-minor-mode)
;;     (let ((mykeys (assq 'amfl-keys-minor-mode minor-mode-map-alist)))
;;       (assq-delete-all 'amfl-keys-minor-mode minor-mode-map-alist)
;;       (add-to-list 'minor-mode-map-alist mykeys))))
;; (ad-activate 'load)
