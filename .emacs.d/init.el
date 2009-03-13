;;; init.el
;;; $Id: init.el,v 1.20 2008-04-10 14:45:57 hamano Exp $
;;;

(setq load-path (cons "~/.emacs.d/site-lisp" load-path))

;; Language configuration
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(cond
 ((equal (getenv "LANG") "ja_JP.eucJP")
  (set-default-coding-systems 'euc-japan)
  (set-terminal-coding-system 'euc-japan)
  (set-buffer-file-coding-system 'euc-japan)
  (set-keyboard-coding-system 'euc-japan)
  )
 )

;; Define key bind
(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\M-g" 'goto-line)

;;
(display-time)
(line-number-mode t)
(column-number-mode t)
(menu-bar-mode t)
(winner-mode t)

(cond
 ((= emacs-major-version 21)
  ;(require 'jisx0213)
  (iswitchb-default-keybindings)
  (resize-minibuffer-mode t)
  (tool-bar-mode nil))
 ((= emacs-major-version 22)
  (iswitchb-mode 1)
  ))

;;
(setq inhibit-startup-message nil)
(setq visible-bell t)
(setq frame-title-format "%b (%f)")
(setq-default indicate-empty-lines t)
(setq case-fold-search t)
;(global-highlight-changes 'active)
(show-paren-mode 1)
(set-face-background 'show-paren-match-face "blue")
(set-face-foreground 'show-paren-match-face "black")

;; Face
(set-cursor-color "blue")
(set-face-foreground 'default "black")
(set-face-background 'default "white")
(setq transient-mark-mode t)
(set-face-foreground 'region "black")
(set-face-background 'region "green")

(set-face-foreground 'mode-line "white")
(set-face-background 'mode-line "black")
(set-face-foreground 'mode-line-inactive "white")
(set-face-background 'mode-line-inactive "brightblack")

;; East Asian Width Problem
(utf-translate-cjk-set-unicode-range
 '(
;   (#x00a2 . #x00a3)                    ; ¢, £
   (#x00a7 . #x00a8)                    ; §, ¨
   (#x00b0 . #x00b1)                    ; °, ±
   (#x00b4 . #x00b4)                    ; ´
   (#x00b6 . #x00b6)                    ; ¶
   (#x00d7 . #x00d7)                    ; ×
   (#X00f7 . #x00f7)                    ; ÷
   (#X00fc . #x00fc)                    ; ü
   (#x0370 . #x03ff)                    ; Greek and Coptic
   (#x0400 . #x04FF)                    ; Cyrillic
   (#x2000 . #x206F)                    ; General Punctuation
   (#x20AC . #x20AC)                    ; €
   (#x2100 . #x214F)                    ; Letterlike Symbols
   (#x2190 . #x21FF)                    ; Arrows
   (#x2200 . #x22FF)                    ; Mathematical Operators
   (#x2300 . #x23FF)                    ; Miscellaneous Technical
   (#x2500 . #x257F)                    ; Box Drawing
   (#x25A0 . #x25FF)                    ; Geometric Shapes
   (#x2600 . #x26FF)                    ; Miscellaneous Symbols
   (#x2e80 . #xd7a3) (#xff00 . #xffef)))

;; X settings
(if window-system
    (progn
      (tool-bar-mode nil)
      (mwheel-install)
      (set-default-font "-shinonome-gothic-medium-r-normal--12-*-*-*-*-*-*-*")
      (set-face-font 'default
                     "-shinonome-gothic-medium-r-normal--12-*-*-*-*-*-*-*")
      (set-face-font 'bold
                     "-shinonome-gothic-bold-r-normal--12-*-*-*-*-*-*-*")
      (set-face-font 'italic
                     "-shinonome-gothic-medium-i-normal--12-*-*-*-*-*-*-*")
      (set-face-font 'bold-italic
                     "-shinonome-gothic-bold-i-normal--12-*-*-*-*-*-*-*")
      ))

;; font-lock-mode
(global-font-lock-mode t)

;; fast-lock-mode
;(setq font-lock-support-mode 'fast-lock-mode)
;(setq fast-lock-cache-directories '("~/.emacs.d/flc"))
;(setq temporary-file-directory "~/.emacs.d/tmp")

;; hl-line
(require 'hl-line)
(global-hl-line-mode)
(set-face-background 'hl-line "cyan")
;(setq hl-line-face 'underline)

;; mode-hook
(add-hook 'text-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (outline-minor-mode 1)
            ))

(add-hook 'change-log-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)
            ))

;; ?
(add-hook 'shell-mode-hook
          (lambda ()
            (define-key shell-mode-map "\C-p" 'comint-previous-input)
            (define-key shell-mode-map "\C-n" 'comint-next-input)
            ))

(add-hook 'sh-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            ))

(add-hook 'asm-mode-hook
          (lambda ()
            (local-unset-key ";")
            (setq tab-width 4)
            (setq tab-stop-list
                  '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76))
            ))

(add-hook 'c-mode-common-hook
          (lambda ()
            (c-set-style "k&r")
            (setq c-basic-offset 4)
            (setq indent-tabs-mode nil)
            (setq compilation-ask-about-save nil)
            (setq compilation-window-height 6)
            (setq compilation-scroll-output t)
            (c-toggle-auto-state -1)
            (c-toggle-hungry-state -1)
            (define-key c-mode-map "\C-c\C-m" 'manual-entry)
            (define-key c-mode-map "\C-c\C-c" 'compile)
            (define-key c-mode-map "\C-c\C-n" 'next-error)
            (define-key c-mode-map "\C-c\C-f" 'ff-find-other-file)
            (flymake-mode t)
            ))

(add-hook 'c++-mode-hook
          (lambda ()
            (setq compilation-window-height 6)
            (setq compilation-scroll-output t)
            (define-key c++-mode-map "\C-c\C-m" 'manual-entry)
            (define-key c++-mode-map "\C-c\C-c" 'compile)
            (define-key c++-mode-map "\C-c\C-n" 'next-error)
            (define-key c++-mode-map "\C-c\C-f" 'ff-find-other-file)
            (flymake-mode t)
            ))

(add-hook 'java-mode-hook
          (lambda ()
            (setq compilation-window-height 6)
            (setq compilation-scroll-output t)
            (define-key java-mode-map "\C-c\C-c" 'compile)
            (define-key java-mode-map "\C-c\C-n" 'next-error)))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (define-key emacs-lisp-mode-map "\C-c\C-d" 'checkdoc)
            ))

(add-hook 'lisp-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            ))

(add-hook 'scheme-mode-hook
          (lambda ()
            (define-key scheme-mode-map "\C-c\C-r" 'scheme-other-window)
            ))

(add-hook 'perl-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            ))

(add-hook 'erlang-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            ))

;; auto-mode
(setq auto-mode-alist
      (append '(
                ("^Makefile" . makefile-mode)
                ("^Changes" . change-log-mode)
                ("\\.xsl$" . sgml-mode)
                ("\\.css$" . sh-mode)
                ("\\.fo$"  . sgml-mode)
                ("\\.cs$" . java-mode)
                ("\\.xs$" . c-mode)
                ("\\.tt$" . html-mode)
                ("\\.t$" . perl-mode)
                ) auto-mode-alist))

;; flymake
(when (>= emacs-major-version 22)
  (require 'flymake)
  (defun flymake-c-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "gcc" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))
  (push '("\\.c$" flymake-c-init) flymake-allowed-file-name-masks)
  (defun flymake-cc-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))
  (push '("\\.cc$" flymake-cc-init) flymake-allowed-file-name-masks)
  (push '("\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)
  )


;; auto-insert
(add-hook 'find-file-hooks 'auto-insert)
(setq auto-insert-query t)
(setq auto-insert-directory "~/.emacs.d/tmpl/")
(setq auto-insert-alist
      (append '(
                (c-mode . "gpl.c")
                (cc-mode . "gpl.c")
                (sh-mode . "templ.sh")
                (makefile-mode . "templ.mk")
                (make-mode . "templ.mk")
                (html-mode . "strict.html")
                )))

;; w3m settings
(when (file-directory-p "~/.emacs.d/site-lisp/emacs-w3m")
  (progn
    (add-to-list 'load-path "~/.emacs.d/site-lisp/emacs-w3m")
    (require 'w3m-load)
    (require 'mime-w3m)))

;; lookup settings
(when (file-directory-p "~/.emacs.d/site-lisp/lookup/lisp")
  (progn
    (add-to-list 'load-path "~/.emacs.d/site-lisp/lookup/lisp")
    (autoload 'lookup "lookup" nil t)
    (autoload 'lookup-region "lookup" nil t)
    (autoload 'lookup-pattern "lookup" nil t)
    (setq lookup-search-agents '((ndtp "dict") (ndspell)))))

;; slime settings
(when (file-directory-p "~/.emacs.d/site-lisp/slime")
  (progn
    (add-to-list 'load-path "~/.emacs.d/site-lisp/slime")
    (require 'slime)
    (setq inferior-lisp-program "sbcl")
    (setq slime-net-coding-system 'utf-8-unix)
    (add-hook 'lisp-mode-hook
              (lambda ()
                (slime-mode t)
                (show-paren-mode)))))

;; gosh settings
(setq scheme-program-name "gosh")
(defun scheme-other-window ()
  "Run scheme on other window"
  (interactive)
  (switch-to-buffer-other-window
   (get-buffer-create "*scheme*"))
  (run-scheme scheme-program-name))

;; erlang settings
(when (file-directory-p "~/.emacs.d/site-lisp/erlang")
  (progn
    (add-to-list 'load-path "~/.emacs.d/site-lisp/erlang")
    (require 'erlang-start)))

;; php-mode settings
(when (file-directory-p "~/.emacs.d/site-lisp/php-mode")
  (progn
    (add-to-list 'load-path "~/.emacs.d/site-lisp/php-mode")
    (require 'php-mode)))

;; text-translator settings
(when (file-directory-p "~/.emacs.d/site-lisp/text-translator")
  (progn
    (setq load-path (cons "~/.emacs.d/site-lisp/text-translator" load-path))
    (require 'text-translator)
    (global-set-key "\C-x\M-t" 'text-translator)
    (global-set-key "\C-x\M-T" 'text-translator-translate-last-string)))

;; navi2ch settings
(when (file-directory-p "~/.emacs.d/site-lisp/navi2ch")
  (progn
    (setq load-path (cons "~/.emacs.d/site-lisp/navi2ch" load-path))
    (autoload 'navi2ch "navi2ch" "Navigator for 2ch for Emacs" t)
    (setq navi2ch-list-bbstable-url "http://menu.2ch.net/bbsmenu.html")
    ;(eval-after-load "navi2ch" '(global-hl-line-mode))
    (setq navi2ch-article-auto-range nil)
    (setq navi2ch-message-mail-address "sage")))
