;; Enable evil, do some basic key remaps

(require-package 'evil)
(evil-mode t) ; Evil mode by default
(diminish 'visual-line-mode)
(diminish 'undo-tree-mode)

;; Change the colors of the cursors in different modes
(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))

;; Use C-j and C-k to scroll up/down (Because C-u is busted in evil)
(define-key evil-normal-state-map (kbd "C-k") (lambda ()
						(interactive)
						(evil-scroll-up nil)))
(define-key evil-normal-state-map (kbd "C-j") (lambda ()
						(interactive)
						(evil-scroll-down nil)))

;; Don't move the cursor back when exiting insert mode
(setq evil-move-cursor-back nil)

;; ------------------------------------------------------

(require-package 'powerline-evil)
(powerline-center-evil-theme)

;; Org mode keybinding changes for evil
(require-package 'evil-org)

;; Let vim's * command work with visual selections
(require-package 'evil-visualstar)
(global-evil-visualstar-mode)

;; <leader> key as in vim
(require-package 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
 "w" 'evil-write
 "q" 'evil-quit)

;; Allows key chords to ditch out of almost any menu
;; https://github.com/syl20bnr/evil-escape
(require-package 'evil-escape)
(evil-escape-mode 1)
(setq evil-escape-unordered-key-sequence 1)
(setq-default evil-escape-key-sequence "jk")
(diminish 'evil-escape-mode)

;; Cool lispy editing modes
(require-package 'evil-smartparens)
;; (require-package 'evil-paredit)
;; (add-hook 'emacs-lisp-mode-hook 'evil-paredit-mode)
(add-hook 'emacs-lisp-mode-hook #'evil-smartparens-mode)
(add-hook 'clojure-mode-hook #'evil-smartparens-mode)
(add-hook 'smartparens-enabled-hook #'evil-smartparens-mode)
(require 'smartparens-config)

;; Deprecated - Replaced by evil-escape
;; Left here because chords to trigger functions is cool!
;; (require-package 'key-chord)  ; Allow key chords (Notably 'jk' to exit insert)
;; ;; Note that this can make the cursor appear sluggish.
;; (key-chord-mode 1)
;; (key-chord-define-global "jk" 'evil-normal-state)

(provide 'amfl-evil)
