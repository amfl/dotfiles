;; Inspiration: https://github.com/daviwil/emacs-from-scratch/blob/master/Emacs.org
;; Design Principles
;; - Use third party packages
;; - Try to avoid excessive custom config to reduce maintenance burden
;; TODO
;; - Helpful
;; - ivy-rich
;; - Swiper for searching

;; PACKAGE SYSTEM

;; `package` is an emacs built-in.
(require 'package)
;; Define our package sources.
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless package-archive-contents  ;; Populate package cache if it's empty.
  (package-refresh-contents))     ;; (Will this work with a proxy?)

;; Confusingly, we use a third-party package called "use-package" to do
;; our package management, rather than the emacs built-in "package".
;; ...Let's fetch "use-package" by using "package"!
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)  ;; Fetch packages dynamically if required

;; Hotkey prompts
;; Useful when still learning editor
(use-package which-key
    :init     (which-key-mode)
    :diminish which-key-mode
    :config   (setq which-key-idle-mode-delay 1))

;; Fuzzy find through everything
;; See also: helm
(use-package ivy
    :bind (:map ivy-minibuffer-map
           ("C-j" . ivy-next-line)
           ("C-k" . ivy-previous-line)
           :map ivy-switch-buffer-map
           ("C-j" . ivy-next-line)
           ("C-k" . ivy-previous-line))
    :init (ivy-mode 1))

;; Rainbow parens
(use-package rainbow-delimiters
  ;; Turn on for any programming mode
  :hook (prog-mode . rainbow-delimiters-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; (load-theme 'wombat)
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t))

;; mouse
;; enable mouse reporting for terminal emulators
;; NOTE: Nobody seems to know how to use the mouse for the menus, lol.
;; https://emacs.stackexchange.com/questions/32490/how-to-use-menu-bar-at-the-top-via-mouse
(unless window-system
  (xterm-mouse-mode 1)
  (global-set-key [mouse-4] (lambda ()
                  (interactive)
		  (scroll-down 3)))
  (global-set-key [mouse-5] (lambda ()
                  (interactive)
                  (scroll-up 3))))

(column-number-mode t)
(global-display-line-numbers-mode t)
;; Can turn off line numbers in particular modes like shell mode...
;; But let's add that if we need it

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

; ; Astonishingly, evil doesn't just... work. It's half broken for several emacs
; ; modes (Eg, "Enter" doesn't work to follow links when viewing the manual).
; ; This fixes a bunch of stuff.
; (when (require 'evil-collection nil t)
;   (evil-collection-init))
