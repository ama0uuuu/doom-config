;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")
(setq user-full-name "Sunao Kaneko"
      user-mail-address "sunao.kaneko@protonmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font (font-spec :family "DejaVu Sans Mono" :size (if (eq window-system 'mac) 14.0 12.5) :weight 'light))
(after! unicode-fonts
  (dolist (unicode-block '("Hiragana"
                           "Katakana"
                           "Halfwidth and Fullwidth Forms"
                           "CJK Unified Ideographs"
                           "CJK Symbols and Punctuation"))
    (push (if (eq window-system 'mac) "Hiragino Sans" "Noto Sans CJK JP")
          (cadr (assoc unicode-block unicode-fonts-block-font-mapping))))
  (dolist (unicode-block '("Mathematical Alphanumeric Symbols"
                           "Mathematical Operators"
                           "Miscellaneous Mathematical Symbols-A"
                           "Miscellaneous Mathematical Symbols-B"
                           "Miscellaneous Symbols"
                           "Miscellaneous Symbols and Arrows"
                           "Miscellaneous Symbols and Pictographs"))
    (push "DejaVu Math TeX Gyre"
          (cadr (assoc unicode-block unicode-fonts-block-font-mapping)))))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tokyo-night)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(set-language-environment "Japanese")
(setq! default-input-method "japanese-skk")
(map! :after evil :map evil-insert-state-map "C-j" nil)
(map! :after evil-org :map evil-org-mode-map :ie "C-j" nil)
;; (after! ddskk
;;   (defun skk-C-j-key (arg)
;;     (interactive "P")
;;     (cond
;;      ((and (null (skk-in-minibuffer-p))
;;            (null skk-henkan-mode))
;;       (skk-emulate-original-map arg))
;;      (t
;;       (skk-kakutei arg))))

;;   (add-to-list 'skk-rom-kana-rule-list
;;                '(skk-kakutei-key nil skk-C-j-key)))

(add-to-list 'default-frame-alist '(width . 120))
(add-to-list 'default-frame-alist '(height . 60))

(after! org-roam
  (setq! org-preview-latex-default-process 'dvisvgm
        org-format-latex-options (plist-put org-format-latex-options :scale (if (eq window-system 'mac) 1.2 0.8))
        org-roam-capture-templates
        '(("m" "main" plain "%?"
           :if-new (file+head "main/%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("r" "reference" plain "%?"
           :if-new (file+head "reference/${title}.org"
                              "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("a" "article" plain "%?"
           :if-new (file+head "articles/${title}.org"
                              "#+title: ${title}\n#+filetags: :article:\n")
           :immediate-finish t
           :unnarrowed t)
          ("s" "Slipbox" entry
           "* %?\n"
           :target (file "inbox.org")))
        org-roam-node-display-template
        (format "%s ${doom-hierarchy:*} %s"
                (propertize "${doom-type:12}" 'face 'font-lock-keyword-face)
                (propertize "${doom-tags:20}" 'face '(:inherit org-tag :box nil)))))

(use-package! citar-org-roam
  :after (citar org-roam)
  :config (citar-org-roam-mode))

(setq! citar-bibliography '("~/org/roam/biblio.bib"))

;; (defun my/org-roam-node-from-cite (keys-entries)
;;   (interactive (list (citar-select-ref :multiple nil :rebuild-cache t)))
;;   (let ((title (citar--format-entry-no-widths (cdr keys-entries)
;;                                               "${author editor} :: ${title}")))
;;     (org-roam-capture- :templates
;;                        '(("r" "reference" plain "%?" :if-new
;;                           (file+head "reference/${citekey}.org"
;;                                      ":PROPERTIES:
;; :ROAM_REFS: [cite:@${citekey}]
;; :END:
;; #+title: ${title}\n")
;;                           :immediate-finish t
;;                           :unnarrowed t))
;;                        :info (list :citekey (car keys-entries))
;;                        :node (org-roam-node-create :title title)
;;                        :props '(:finalize find-file))))

(setq! citar-org-roam-subdir "reference")
(after! org-roam-capture
  (defun my/tag-new-node-as-draft ()
    (org-roam-tag-add '("draft")))
  (add-hook 'org-roam-capture-new-node-hook #'my/tag-new-node-as-draft))

(after! ox-latex
  (setq! org-latex-compiler "lualatex")
  (setq! org-latex-default-class "jlreq")
  (setq! org-latex-pdf-process '("latexmk -output-directory=%o %f"))
  (setq! org-latex-packages-alist '(("" "tikz" t)))
  (add-to-list 'org-latex-classes
               '("jlreq"
                 "
\\documentclass[11pt,paper=a4]{jlreq}
"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(when (eq window-system 'pgtk)
  (map! "s-x" 'execute-extended-command))
