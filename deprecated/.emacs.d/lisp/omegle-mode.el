;; Syntax highlighting for Omegle logs.
;; Unfinished

(setq my-highlights
      '(
        ("^Stranger:" . font-lock-keyword-face)
        ("^You:" . font-lock-function-name-face)

        ("^You're now chatting with a random stranger. Say hi!" . font-lock-comment-face)
        ("^\\(Question to discuss:\\)\n\\([^\n]*\\)\n" . font-lock-keyword-face)
        ("^\\(You have\\|Stranger has\\) disconnected.$" . font-lock-comment-face)

        ("^\\(You\\|Stranger\\): >+ [^\n]+$" . font-lock-keyword-face) ;; > Implications
        ))

(define-derived-mode omegle-mode fundamental-mode
  (setq font-lock-defaults '(my-highlights 1))
  (setq mode-name "omegle")
  (setq adaptive-wrap-extra-indent 6)
  (adaptive-wrap-prefix-mode)
  (visual-line-mode)
  )

(add-to-list 'auto-mode-alist '("\\.omegle\\'" . omegle-mode))

(provide 'omegle-mode)
