;;; .emacs
;;; $Id: init.el,v 1.20 2008-04-10 14:45:57 hamano Exp $
;;;

(setq load-path (cons "~/.emacs.d/site-lisp" load-path))

;; User information
(setq user-full-name "Tsukasa Hamano")

;; Language settings
(set-language-environment "Japanese")
(if (<= emacs-major-version 21)
    (require 'jisx0213))

(cond
 ((equal (getenv "LANG") "ja_JP.eucJP")
  (set-default-coding-systems 'euc-japan)
  (set-terminal-coding-system 'euc-japan)
  (set-buffer-file-coding-system 'euc-japan)
  (set-keyboard-coding-system 'euc-japan)
  )
 (t
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-buffer-file-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  ))

;; Define functions
(defun delete-line ()
  (interactive)
  (delete-region (point)
                 (save-excursion
                   (end-of-line)
                   (point))))

;; Keybind settings
(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\M-k" 'delete-line)
(global-set-key "\C-x\C-u" 'undo) ; for continuous undo
(global-set-key "\M-h"
                (lambda () (interactive) (kill-line 0))) ; backward kill line
(global-unset-key "\C-t") ; used by screen

;; Common settings
(display-time)
(line-number-mode t)
(column-number-mode t)
(menu-bar-mode nil)
(winner-mode t)

(setq inhibit-startup-message t)
(setq visible-bell t)
(setq frame-title-format "%b (%f)")
(setq-default indicate-empty-lines t)
(setq case-fold-search t)
;(global-highlight-changes 'active)
(show-paren-mode 1)
(set-face-background 'show-paren-match-face "blue")
(set-face-foreground 'show-paren-match-face "black")

;; Version dependent settings
(cond
 ((= emacs-major-version 21)
  (iswitchb-default-keybindings)
  (resize-minibuffer-mode t)
  (tool-bar-mode nil))
 ((>= emacs-major-version 22)
  (iswitchb-mode 1)
  ))

;; Face settings
(set-cursor-color "blue")
(set-face-foreground 'default "black")
(set-face-background 'default "white")
(setq transient-mark-mode t)
(set-face-foreground 'region "black")
(set-face-background 'region "green")

(set-face-foreground 'mode-line "white")
(set-face-background 'mode-line "black")
(when (>= emacs-major-version 22)
  (set-face-foreground 'mode-line-inactive "white")
  (set-face-background 'mode-line-inactive "brightblack"))

; highliting white space at EOL
(defface ws-face-r-1 '((t (:background "cyan"))) nil)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (defvar ws-face-r-1 'ws-face-r-1)
  (font-lock-add-keywords
   major-mode '(("[ 　\t\r]+$" 0 ws-face-r-1 append))))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;; East Asian Width Problem
(when (= emacs-major-version 22)
  (utf-translate-cjk-set-unicode-range
   '(
;     (#x00a2 . #x00a3)                    ; ¢, £
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
     (#x2e80 . #xd7a3) (#xff00 . #xffef))))

;; X settings
(if window-system
    (progn
      (tool-bar-mode nil)
      (mwheel-install)
      ;; Font settings
      (set-default-font "-shinonome-gothic-medium-r-normal--12-*-*-*-*-*-*-*")
      (set-face-font 'default
                     "-shinonome-gothic-medium-r-normal--12-*-*-*-*-*-*-*")
      (set-face-font 'bold
                     "-shinonome-gothic-bold-r-normal--12-*-*-*-*-*-*-*")
      (set-face-font 'italic
                     "-shinonome-gothic-medium-i-normal--12-*-*-*-*-*-*-*")
      (set-face-font 'bold-italic
                     "-shinonome-gothic-bold-i-normal--12-*-*-*-*-*-*-*")

      ;; Clip board settings
      (setq x-select-enable-clipboard t)
      (if (file-exists-p "/usr/bin/xsel")
          (progn
            (setq interprogram-paste-function
                  (lambda ()
                    (shell-command-to-string "xsel -o")))
            (setq interprogram-cut-function
                  (lambda (text &optional rest)
                    (let* ((process-connection-type nil)
                           (proc
                            (start-process "xsel" "*Messages*" "xsel" "-i")))
                      (process-send-string proc text)
                      (process-send-eof proc))))))
      ))

;; font-lock-mode
(global-font-lock-mode t)

;; fast-lock-mode
;(setq font-lock-support-mode 'fast-lock-mode)
;(setq fast-lock-cache-directories '("~/.emacs.d/flc"))
;(setq temporary-file-directory "~/.emacs.d/tmp")

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

(add-hook 'shell-mode-hook
          (lambda ()
            (define-key shell-mode-map "\C-p" 'comint-previous-input)
            (define-key shell-mode-map "\C-n" 'comint-next-input)
            ))

(add-hook 'sh-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)
            (setq tab-width 4)
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
            (setq indent-tabs-mode t)
            (setq tab-width 4)
            (setq c-basic-offset 4)
            (setq indent-tabs-mode t)
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
            (setq indent-tabs-mode nil)
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

(add-hook 'ruby-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq ruby-deep-indent-paren-style nil)
            ))

(add-hook 'erlang-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)
            ))

(add-hook 'javascript-mode-hook
          (lambda ()
            (setq js-indent-level 2)
            (setq indent-tabs-mode t)
            ))

(add-hook 'lua-mode-hook
          (lambda ()
            (setq lua-indent-level 2)
            (setq lua-electric-flag nil)
            (abbrev-mode 0)
            ))

(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 4)
            (setq indent-level 4)
            (setq python-indent 4)
;            (split-window-vertically)
;            (run-python nil t)
;            (save-excursion
;              (save-selected-window
;                (select-window (next-window))
;                (set-window-buffer (selected-window) python-buffer)
;                (enlarge-window (- 10 (window-height)))
;                ))
            ))

(add-hook 'nxml-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            ))

(add-hook 'css-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)
            (setq css-indent-offset 2)
            ))

;; auto-mode
(setq auto-mode-alist
      (append '(
                ("^Makefile" . makefile-mode)
                ("^Changes" . change-log-mode)
                ("\\.xsl$" . sgml-mode)
                ("\\.fo$"  . sgml-mode)
                ("\\.cs$" . java-mode)
                ("\\.xs$" . c-mode)
                ("\\.tt$" . html-mode)
                ("\\.t$" . perl-mode)
                ) auto-mode-alist))

;; hl-line
(when (>= emacs-major-version 22)
  (require 'hl-line)
  (global-hl-line-mode)
  (set-face-background 'hl-line "cyan")
  ;(setq hl-line-face 'underline)
  )

;; flymake
(when (>= emacs-major-version 22)
  (require 'flymake)
  (setenv "INCLUDE" "/mnt/usb/git/linux-2.6/include/")
  (push '("\\.java$" nil) flymake-allowed-file-name-masks)
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

;; erlang-mode settings
(when (file-directory-p "~/.emacs.d/site-lisp/erlang")
  (progn
    (add-to-list 'load-path "~/.emacs.d/site-lisp/erlang")
    (require 'erlang-start)))

;; lua-mode settings
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))

;; php-mode settings
(when (file-directory-p "~/.emacs.d/site-lisp/php-mode")
  (progn
    (add-to-list 'load-path "~/.emacs.d/site-lisp/php-mode")
    (autoload 'php-mode "php-mode" "Major mode for editing php code." t)))
;    (require 'php-mode)))

;; python-mode settings
;(autoload 'python-mode "python-mode" "Python editing mode." t)
;(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;(setq interpreter-mode-alist (cons '("python" . python-mode)
;				   interpreter-mode-alist))

;; js2 settings
(when (file-regular-p "~/.emacs.d/site-lisp/js2.el")
  (progn
    (autoload 'js2-mode "js2" nil t)
    (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
    (add-hook 'js2-mode-hook
              '(lambda ()
;             (setq c-basic-offset 4)
             (setq js2-basic-offset 4)
             (setq tab-width 4)
             (setq indent-tabs-mode t)
;             (setq js2-cleanup-whitespace nil)
             ))
    ))

;; text-translator settings
(when (file-directory-p "~/.emacs.d/site-lisp/text-translator")
  (progn
    (setq load-path (cons "~/.emacs.d/site-lisp/text-translator" load-path))
    (require 'text-translator)
    (global-set-key "\C-x\M-t" 'text-translator)
    (global-set-key "\C-x\M-T" 'text-translator-translate-last-string)))

;; gnus settings
(when (file-directory-p "~/.emacs.d/site-lisp/gnus/lisp")
  (setq load-path (cons "~/.emacs.d/site-lisp/gnus/lisp" load-path))
  (autoload 'gnus "gnus" nil t))

;; wanderlust settings
(when (file-directory-p "~/.emacs.d/site-lisp/wl")
  (setq load-path (cons "~/.emacs.d/site-lisp/apel" load-path))
  (setq load-path (cons "~/.emacs.d/site-lisp/flim" load-path))
  (setq load-path (cons "~/.emacs.d/site-lisp/semi" load-path))
  (setq load-path (cons "~/.emacs.d/site-lisp/wl/wl" load-path))
  (setq load-path (cons "~/.emacs.d/site-lisp/wl/elmo" load-path))
  (load "mime-setup")
  (autoload 'wl "wl" "Wanderlust" t)
  (autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)
  (setq wl-icon-directory "~/.emacs.d/site-lisp/wl/etc/icons")
  (setq mime-header-accept-quoted-encoded-words t)
  (setq wl-draft-buffer-style 'split)
  (setq wl-auto-select-first t)
  ; execute fetchmail
  (defun wl-fetchmail()
    (interactive)
    (message "Getting by fetchmail...")
    (call-process "fetchmail" nil nil nil)
    (message "Getting by fetchmail...done")
    (wl-folder-check-all))
  (add-hook 'wl-folder-mode-hook
            (lambda ()
              (define-key wl-folder-mode-map "\M-i" 'wl-fetchmail)))
  ; modified wl face
  (defun my-wl-set-face (face spec)
    (make-face face)
    (cond ((fboundp 'face-spec-set)
           (face-spec-set face spec))
          (t
           (wl-declare-face face spec))))
  (my-wl-set-face 'wl-highlight-message-cited-text-2
                  '((t (:foreground "darkblue"))))
  (my-wl-set-face 'wl-highlight-message-cited-text-3
                  '((t (:foreground "dodgerblue"))))
  (my-wl-set-face 'wl-highlight-message-cited-text-6
                  '((t (:foreground "darkred"))))
  (my-wl-set-face 'wl-highlight-message-cited-text-7
                  '((t (:foreground "SaddleBrown"))))
  ; encode non-ASCII atatched filename
  (eval-after-load "std11"
  '(defadvice std11-wrap-as-quoted-string
     (before encode-string activate)
     "Encode a string."
     (require 'eword-encode)
     (ad-set-arg 0 (eword-encode-string (ad-get-arg 0)))))

  (add-hook 'wl-draft-reply-hook
            (function
             (lambda ()
               (save-excursion
                 (beginning-of-buffer)
                 (re-search-forward "^Subject: " (point-max) t)
                 (while (re-search-forward
                         "\\*\\*\\*\\(SPAM\\|UNCHECKED\\)\\*\\*\\* *"
                         (save-excursion (end-of-line) (point)) t)
                   (replace-match ""))
                 ))))
  )

;; mu-cite settings
(when (file-directory-p "~/.emacs.d/site-lisp/mu-cite")
  (setq load-path (cons "~/.emacs.d/site-lisp/mu-cite" load-path))
  (autoload 'mu-cite-original "mu-cite" nil t)
  (add-hook 'mail-citation-hook (function mu-cite-original))
  (setq mu-cite-prefix-format '("> "))
  (setq mu-cite-cited-prefix-regexp "\\(^[^ \t\n<>]+>+[ \t]*\\)")
  (setq mu-cite-top-format
        '(
          "\nAt " date ",\n"
          from " wrote:\n"
          "> \n")))

;; navi2ch settings
(when (file-directory-p "~/.emacs.d/site-lisp/navi2ch")
  (progn
    (setq load-path (cons "~/.emacs.d/site-lisp/navi2ch" load-path))
    (autoload 'navi2ch "navi2ch" "Navigator for 2ch for Emacs" t)
    (setq navi2ch-list-bbstable-url "http://menu.2ch.net/bbsmenu.html")
    ;(eval-after-load "navi2ch" '(global-hl-line-mode))
    (setq navi2ch-article-auto-range nil)
    (setq navi2ch-message-mail-address "sage")))

;; Load custom settings
(condition-case nil
    (load (expand-file-name "~/.emacs.d/custom"))
  (error nil))
