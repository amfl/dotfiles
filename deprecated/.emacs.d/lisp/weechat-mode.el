;; Syntax highlighting for my weechat logs.
;; Taken from http://ergoemacs.org/emacs/elisp_syntax_coloring.html
;; TODO:
;;   Read from weechat's `irc.look.nick_color_force`
;;   Assign colors to nicks via hash of name

(setq my-highlights
      '(
        ("^[0-9\-]+ [0-9:]+" . font-lock-comment-face) ;; Timestamps
        ("\\*\t\\([^ ]+\\)" 1 font-lock-function-name-face) ;; Nicks after an action
        ("^[0-9\-]+ [0-9:]+\t\\([^\t*]+\\)\t" 1 font-lock-function-name-face) ;; Nicks in normal speech
        ("\t \\*" . font-lock-keyword-face) ;; * action indictators
        ("\t>+ [^\t]+$" . font-lock-keyword-face) ;; > Implications
        ("\"[^\"\n]*[\"\n]" . font-lock-string-face) ;; "strings"
        ("((.*?))" . font-lock-comment-face) ;; (( OOC ))
        ("──.?\t\\(.*\\)$" 1 font-lock-comment-face) ;; Network events
        ))

;; ;; Stolen from http://stackoverflow.com/questions/24169418/adding-a-created-color-code-to-font-lock
;; ;; See also: https://www.emacswiki.org/emacs/mon-css-color.el
;; (defvar rgb-color-keywords
;;   '(("rgb([0-9]+, *[0-9]+, *[0-9]+)"
;;      (0
;;       (put-text-property
;;        (match-beginning 0)
;;        (match-end 0)
;;        'face (list :background
;; 		   (let ((color-channels (split-string (substring (match-string-no-properties 0) 4 -1) ",")))
;; 		     (format "#%02X%02X%02X"
;; 			     (string-to-number (nth 0 color-channels))
;; 			     (string-to-number (nth 1 color-channels))
;; 			                                  (string-to-number (nth 2 color-channels))))))))))

(define-derived-mode weechat-mode fundamental-mode
  (setq font-lock-defaults '(my-highlights 1))
  ;; (font-lock-add-keywords nil rgb-color-keywords)
  (setq mode-name "weechat")
  (setq adaptive-wrap-extra-indent 28)
  (adaptive-wrap-prefix-mode)
  (visual-line-mode)
  )

(add-to-list 'auto-mode-alist '("\\.weechatlog\\'" . weechat-mode))

(provide 'weechat-mode)
