;; Package Management ----------------------------------------------------- {{{1

;; Built-in package manager
(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

;; Make sure to have downloaded archive description.
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; Activate installed packages
(package-initialize)

;; http://stackoverflow.com/questions/10092322/how-to-automatically-install-emacs-packages-by-specifying-a-list-of-package-name
(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.

Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; List of packages
(ensure-package-installed
 'evil                ; Make emacs behave like vim
 'powerline-evil      ; Powerline
 'evil-visualstar     ; Let vim's * command work with visual selections
 'evil-leader         ; <leader> key as in vim
;; 'vimish-fold         ; Folding as in vim
 'key-chord           ; Allow key chords (Notably 'jk' to exit insert)
 'gruvbox-theme       ; Theme
 'rainbow-delimiters  ; Color parens based on nesting
 'markdown-mode       ; Edit markdown
 'nlinum              ; Line numbers
 'rudel               ; Collaborative editing
 'cider               ; Interactive clojure package
)

(setq package-enable-at-startup nil)

(add-to-list 'load-path "~/.emacs.d")

;; Package Config --------------------------------------------------------- {{{1

;; Custom stuff
;; These are for files bundled with my dotfiles.

(require 'cl)               ; Common lisp (?) A requirement for colorful-points.
(require 'colorful-points)  ; For collaborative editing.

(require 'evennia-mode)

;; Package manager stuff

(require 'evil)
(evil-mode t) ; Evil mode by default

(require 'powerline-evil)
(powerline-center-evil-theme)

(require 'evil-visualstar)
(global-evil-visualstar-mode)

(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-leader/set-key
 "w" 'save-buffer
 "q" 'save-buffers-kill-terminal)

(require 'rudel)
(global-rudel-minor-mode 1)

;; (require 'vimish-fold)

(require 'key-chord)
;; Note that this can make the cursor appear sluggish.
(key-chord-mode 1)
(key-chord-define-global "jk" 'evil-normal-state)

(require 'gruvbox-theme)
(load-theme 'gruvbox t)

(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(require 'nlinum)
(setq nlinum-format "%d ")  ; Show space between line numbers and text
(global-nlinum-mode t)      ; Always show line numbers

(require 'markdown-mode)
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

(require 'cider)
(add-hook 'cider-mode-hook #'eldoc-mode)

;; Remaps ----------------------------------------------------------------- {{{1

;; Menu bar off by default, toggled with F9
(menu-bar-mode -1)
(global-set-key [f9] 'toggle-menu-bar-mode-from-frame)
