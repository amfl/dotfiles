;; Notes ------------------------------------------------------------------ {{{1

;; M-x describe-function  Function -> Key
;; M-x describe-key       Key -> Function
;; M-x describe-bindings  Shows all bound keys

;; Interesting resources
;;   https://github.com/purcell/emacs.d

;; Prelude ---------------------------------------------------------------- {{{1

(add-to-list 'load-path "~/.emacs.d")

;; Define a minor mode to contain all my custom keymaps.
;; This mode can simply be disabled to remove the customization.
(defvar amfl-keys-minor-mode-map (make-keymap) "amfl-keys-minor-mode keymap.")

;; Remaps, General Config ------------------------------------------------- {{{1

;; Menu bar off by default, toggled with F9
(menu-bar-mode -1)
(global-set-key [f9] 'toggle-menu-bar-mode-from-frame)

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

;;; Newline behaviour
(global-set-key (kbd "RET") 'newline-and-indent)

;; Local Package Config --------------------------------------------------- {{{1
;; This section is for files bundled with my dotfiles.

;; Load up the package manager. This is a set of convenience methods for
;; interacting with the package manager built-in to emacs.
;; Primary, it gives us access to `require-package`.
(require 'amfl-package-manager)

(require 'colorful-points)  ; For collaborative editing.

(require 'evennia-mode)     ; Mode for writing scripts for the mu* framework, evennia.

;; Third-Party Package Config --------------------------------------------- {{{1

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

;; (require-package 'vimish-fold)

(require-package 'gruvbox-theme)       ; Color scheme --------------------- {{{2
(load-theme 'gruvbox t)

(require-package 'rainbow-delimiters)  ; Color parens based on nesting ---- {{{2
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(require-package 'nlinum)              ; Show line numbers on the side ---- {{{2
(setq nlinum-format "%d ")  ; Show space between line numbers and text
(global-nlinum-mode t)      ; Always show line numbers

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

;; Use ag for fast searching
(ensure-package-installed 'ag)
(ensure-package-installed 'helm-ag)

(ensure-package-installed 'helm-projectile)
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

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
    "cc" 'evilnc-copy-and-comment-lines
    "cp" 'evilnc-comment-or-uncomment-paragraphs
    "cr" 'comment-or-uncomment-region
    "cv" 'evilnc-toggle-invert-comment-line-by-line
    "\\" 'evilnc-comment-operator ; if you prefer backslash key
))

(require-package 'yasnippet)           ; Snippets ------------------------- {{{2
(yas-global-mode 1)
; (yas-load-directory "~/.emacs.d/snippets")  ; Custom directory
(add-hook 'term-mode-hook (lambda ()
    (setq yas-dont-activate t)))

;; (require-package 'magit)              ; Git integration ------------------ {{{2
;; (when (require 'evil-leader nil 'noerror)
;;   (evil-leader/set-key
;;     "g" 'magit-status))

(require-package 'expand-region)       ; Expand regions by semantic units - {{{2
;; <leader>x to begin, x to expand, z to contract
(eval-after-load "evil" '(setq expand-region-contract-fast-key "z"))
(evil-leader/set-key "xx" 'er/expand-region)
(global-set-key (kbd "C-=") 'er/expand-region) ; Clashes with evil-mode, not sure why.

;; Postlude --------------------------------------------------------------- {{{1
;; TODO This section is a mess...
;; Info from:
;;   https://bitbucket.org/lyro/evil/issues/511/let-certain-minor-modes-key-bindings
;;   http://stackoverflow.com/questions/683425/globally-override-key-binding-in-emacs

(define-minor-mode amfl-keys-minor-mode
  "A minor mode so my key settings override annoying major modes."
  t " amfl" 'amfl-keys-minor-mode-map)

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
