(require-package 'evil)
(evil-mode t) ; Evil mode by default

(require-package 'powerline-evil) (powerline-center-evil-theme)

(require-package 'evil-visualstar) ; Let vim's * command work with visual selections
(global-evil-visualstar-mode)

(require-package 'evil-leader) ; <leader> key as in vim
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
 "w" 'save-buffer
 "q" 'save-buffers-kill-terminal)

(require-package 'evil-paredit)
(add-hook 'emacs-lisp-mode-hook 'evil-paredit-mode)

(require-package 'key-chord)  ; Allow key chords (Notably 'jk' to exit insert)
;; Note that this can make the cursor appear sluggish.
(key-chord-mode 1)
(key-chord-define-global "jk" 'evil-normal-state)

(provide 'amfl-evil)
