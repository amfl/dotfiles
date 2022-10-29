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
;(use-package srcery-theme
;  :config
;  (load-theme 'srcery t))

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

(use-package evil
  :init
  (setq evil-want-integration t)  ;; Integrate evil with other modules
  (setq evil-want-C-u-scroll t)   ;; Override emacs keybind: universal-argument
  (setq evil-want-keybinding nil) ;; Required for evil-collection
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line))

;; Evil is good, but it doesn't set up keybinds for several other modes
;; (Eg, "Enter" doesn't work to follow links when viewing the manual).
;; Evil-collection enables consistent vim binds across many modes.
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))
