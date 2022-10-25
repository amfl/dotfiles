(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
; (custom-set-variables
;  ;; custom-set-variables was added by Custom.
;  ;; If you edit it by hand, you could mess it up, so be careful.
;  ;; Your init file should contain only one such instance.
;  ;; If there is more than one, they won't work right.
;  '(package-selected-packages '(evil-collection evil)))
; (custom-set-faces
;  ;; custom-set-faces was added by Custom.
;  ;; If you edit it by hand, you could mess it up, so be careful.
;  ;; Your init file should contain only one such instance.
;  ;; If there is more than one, they won't work right.
;  )

;; C-u does something different in emacs
;; https://github.com/bling/emacs-evil-bootstrap/issues/3
; (setq evil-want-C-u-scroll t)
; (require 'evil)
; (evil-mode 1)

(setq evil-want-integration t) ;; This is optional since it's already set to t by default.
(setq evil-want-C-u-scroll t)
(setq evil-want-keybinding nil) ; Required for evil-collection
(evil-mode 1)

; Astonishingly, evil doesn't just... work. It's half broken for several emacs
; modes (Eg, "Enter" doesn't work to follow links when viewing the manual).
; This fixes a bunch of stuff.
(when (require 'evil-collection nil t)
  (evil-collection-init))
