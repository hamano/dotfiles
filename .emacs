;;; .emacs
;;; $Id: init.el,v 1.20 2008-04-10 14:45:57 hamano Exp $
;;;

(setq load-path (cons "~/.emacs.d/site-lisp" load-path))

;; User information
(setq user-full-name "HAMANO Tsukasa")

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

(defun insert-date ()
  (interactive)
  (let ((system-time-locale "C"))
    (insert (format-time-string "%a %_d %b %Y"))))

(defun insert-time ()
  (interactive)
  (let ((system-time-locale "C"))
    (insert (format-time-string "%a %_d %b %Y %H:%M:%S %z"))))

;; Keybind settings
(global-unset-key "\C-t") ; used by screen

(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-x\C-u" 'undo) ; for continuous undo
;(global-set-key "\M-h" 'delete-trailing-whitespace)
(global-set-key "\M-k" 'delete-horizontal-space)
(global-set-key "\M-h"
                (lambda () (interactive) (kill-line 0))) ; backward kill line

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
(cond
 ((= emacs-major-version 22)
  (defface ws-face-r-1 '((t (:background "cyan"))) nil)
  (defadvice font-lock-mode (before my-font-lock-mode ())
    (defvar ws-face-r-1 'ws-face-r-1)
    (font-lock-add-keywords
     major-mode '(("[ 　\t\r]+$" 0 ws-face-r-1 append))))
  (ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
  (ad-activate 'font-lock-mode))
 ((>= emacs-major-version 23)
  (when (boundp 'show-trailing-whitespace)
    (setq-default show-trailing-whitespace t)
    (set-face-background 'trailing-whitespace "gray"))))

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
            (setq indent-tabs-mode nil)
            (setq tab-width 4)
            ))

(add-hook 'asm-mode-hook
          (lambda ()
            (local-unset-key ";")
            (setq tab-width 8)
;            (setq tab-stop-list
;                  '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76))
            ))

(add-hook 'c-mode-common-hook
          (lambda ()
            (c-set-style "k&r")
            (c-toggle-auto-state -1)
            (c-toggle-hungry-state 1)
            (setq indent-tabs-mode nil)
            (setq tab-width 4)
            (setq c-basic-offset 4)
            (setq compilation-ask-about-save nil)
            (setq compilation-window-height 6)
            (setq compilation-scroll-output t)
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

(add-hook 'js-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)
            (setq tab-width 4)
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
            (define-key python-mode-map (kbd "C-c C-c")
              (lambda () (interactive) (python-shell-send-buffer t)))

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

(add-hook 'dns-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)
            ))

;; auto-mode
(setq auto-mode-alist
      (append '(
                ("^Makefile" . makefile-mode)
                ("^Changes" . change-log-mode)
                ("\\.xsl$" . sgml-mode)
                ("\\.fo$"  . sgml-mode)
                ("\\.xs$" . c-mode)
                ("\\.tt$" . html-mode)
                ("\\.cst$" . html-mode)
                ("\\.mak$" . html-mode)
                ("\\.jinja2$" . html-mode)
                ("\\.t$" . perl-mode)
                ("\\.json$" . js-mode)
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
  (defun flymake-php-init () nil) ; disable flymake-php
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

;; go settings
(when (file-directory-p "~/.emacs.d/site-lisp/go")
  (progn
    (add-to-list 'load-path "~/.emacs.d/site-lisp/go")
    (require 'go-mode-load)
    (setq default-tab-width 4)
    ))

;; lua-mode settings
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))

;; php-mode settings
(when (file-directory-p "~/.emacs.d/site-lisp/php-mode")
  (progn
    (add-to-list 'load-path "~/.emacs.d/site-lisp/php-mode")
    (autoload 'php-mode "php-mode" "Major mode for editing php code." t)
    (add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
    ))

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


;; jdee settings
(when (file-directory-p "~/.emacs.d/site-lisp/jdee/lisp")
  (progn
    (add-to-list 'load-path "~/.emacs.d/site-lisp/cedet/common")
    (add-to-list 'load-path "~/.emacs.d/site-lisp/cedet/contrib")
    (require 'cedet)
    (setq load-path (cons "~/.emacs.d/site-lisp/jdee/lisp" load-path))
    (autoload 'jde-mode "jde" "Java Development Environment for Emacs." t)
    (setq jde-web-browser "firefox")
    ;(setq jde-doc-dir "c:/jdk1.1/docs/")
    ;(jde-db-set-source-paths "c:/jdk1.1/src/;c:/myjava/src/")
;    (jde-mode)
    ;(jde-set-variables (jde-global-classpath
    ;("/usr/local/android-sdk/platforms/android-4/android.jar")))

    (defun jde-import-hoge()
      (jde-import-all)
      (jde-import-kill-extra-imports)
      )
    (add-hook 'jde-mode
              (lambda ()
                (local-set-key "\M-q" 'jde-import-hoge)))
    ))

;; markdown settings
(when (locate-library "markdown-mode")
  (progn
    (autoload 'markdown-mode "markdown-mode"
      "Major mode for editing Markdown files" t)
    (add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
    (add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))
    ))

;; w3m-search settings
(when (locate-library "w3m-search")
  (progn
    (require 'w3m-search)
    (add-to-list 'w3m-search-engine-alist
                 '("alc"
                   "http://eow.alc.co.jp/%s/UTF-8/"
                   utf-8))
    (add-to-list 'w3m-uri-replace-alist
                 '("\`alc:" w3m-search-uri-replace "alc"))))

;; text-translator settings
(when (file-directory-p "~/.emacs.d/site-lisp/text-translator")
  (progn
    (setq load-path (cons "~/.emacs.d/site-lisp/text-translator" load-path))
    (require 'text-translator)
    (global-set-key "\C-x\M-t" 'text-translator)
    (global-set-key "\C-x\M-T" 'text-translator-translate-last-string)))

;; google-translate settings
(when (locate-library "google-translate")
  (require 'google-translate)
  (global-set-key [(C x) (C x)] 'google-translate-at-point)
  (custom-set-variables
   '(google-translate-default-source-language "en")
   '(google-translate-default-target-language "ja")))

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

  (setq-default mime-charset-for-write 'utf-8)
  (setq-default mime-transfer-level 8)
  (setq charsets-mime-charset-alist
        '(((ascii) . us-ascii)
          ((unicode) . utf-8)
          ))

  (add-hook 'wl-folder-mode-hook
            (lambda ()
              (define-key wl-folder-mode-map "\M-i" 'wl-fetchmail)
              (define-key wl-folder-mode-map "\M-t" nil)
              (define-key wl-summary-mode-map "\M-t" nil)))

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
     (ad-set-arg 0 (or (eword-encode-string (ad-get-arg 0)) "" ))))

  (add-hook 'wl-draft-reply-hook
            (lambda ()
              (save-excursion
                (beginning-of-buffer)
                (re-search-forward "^Subject: " (point-max) t)
                (while (re-search-forward
                        "\\*\\*\\*\\(SPAM\\|UNCHECKED\\)\\*\\*\\* *"
                        (save-excursion (end-of-line) (point)) t)
                  (replace-match ""))
                )))

  (add-hook 'mime-view-mode-hook
            (lambda ()
              (when (boundp 'show-trailing-whitespace)
                (setq-default show-trailing-whitespace nil))))

  (add-hook 'mime-edit-mode-hook
            (lambda ()
              (when (boundp 'show-trailing-whitespace)
                (setq-default show-trailing-whitespace nil))))
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

;; Set East Asian Ambiguous Charactor Width
(setq east-asian-ambiguous
      '(
        #x00A1 ; INVERTED EXCLAMATION MARK
        #x00A4 ; CURRENCY SIGN
        #x00A7 ; SECTION SIGN
        #x00A8 ; DIAERESIS
        #x00AA ; FEMININE ORDINAL INDICATOR
        #x00AD ; SOFT HYPHEN
        #x00AE ; REGISTERED SIGN
        #x00B0 ; DEGREE SIGN
        #x00B1 ; PLUS-MINUS SIGN
        #x00B2 ; SUPERSCRIPT TWO
        #x00B3 ; SUPERSCRIPT THREE
        #x00B4 ; ACUTE ACCENT
        #x00B6 ; PILCROW SIGN
        #x00B7 ; MIDDLE DOT
        #x00B8 ; CEDILLA
        #x00B9 ; SUPERSCRIPT ONE
        #x00BA ; MASCULINE ORDINAL INDICATOR
        #x00BC ; VULGAR FRACTION ONE QUARTER
        #x00BD ; VULGAR FRACTION ONE HALF
        #x00BE ; VULGAR FRACTION THREE QUARTERS
        #x00BF ; INVERTED QUESTION MARK
        #x00C6 ; LATIN CAPITAL LETTER AE
        #x00D0 ; LATIN CAPITAL LETTER ETH
        #x00D7 ; MULTIPLICATION SIGN
        #x00D8 ; LATIN CAPITAL LETTER O WITH STROKE
        #x00DE ; LATIN CAPITAL LETTER THORN
        #x00DF ; LATIN SMALL LETTER SHARP S
        #x00E0 ; LATIN SMALL LETTER A WITH GRAVE
        #x00E1 ; LATIN SMALL LETTER A WITH ACUTE
        #x00E6 ; LATIN SMALL LETTER AE
        #x00E8 ; LATIN SMALL LETTER E WITH GRAVE
        #x00E9 ; LATIN SMALL LETTER E WITH ACUTE
        #x00EA ; LATIN SMALL LETTER E WITH CIRCUMFLEX
        #x00EC ; LATIN SMALL LETTER I WITH GRAVE
        #x00ED ; LATIN SMALL LETTER I WITH ACUTE
        #x00F0 ; LATIN SMALL LETTER ETH
        #x00F2 ; LATIN SMALL LETTER O WITH GRAVE
        #x00F3 ; LATIN SMALL LETTER O WITH ACUTE
        #x00F7 ; DIVISION SIGN
        #x00F8 ; LATIN SMALL LETTER O WITH STROKE
        #x00F9 ; LATIN SMALL LETTER U WITH GRAVE
        #x00FA ; LATIN SMALL LETTER U WITH ACUTE
        #x00FC ; LATIN SMALL LETTER U WITH DIAERESIS
        #x00FE ; LATIN SMALL LETTER THORN
        #x0101 ; LATIN SMALL LETTER A WITH MACRON
        #x0111 ; LATIN SMALL LETTER D WITH STROKE
        #x0113 ; LATIN SMALL LETTER E WITH MACRON
        #x011B ; LATIN SMALL LETTER E WITH CARON
        #x0126 ; LATIN CAPITAL LETTER H WITH STROKE
        #x0127 ; LATIN SMALL LETTER H WITH STROKE
        #x012B ; LATIN SMALL LETTER I WITH MACRON
        #x0131 ; LATIN SMALL LETTER DOTLESS I
        #x0132 ; LATIN CAPITAL LIGATURE IJ
        #x0133 ; LATIN SMALL LIGATURE IJ
        #x0138 ; LATIN SMALL LETTER KRA
        #x013F ; LATIN CAPITAL LETTER L WITH MIDDLE DOT
        #x0140 ; LATIN SMALL LETTER L WITH MIDDLE DOT
        #x0141 ; LATIN CAPITAL LETTER L WITH STROKE
        #x0142 ; LATIN SMALL LETTER L WITH STROKE
        #x0144 ; LATIN SMALL LETTER N WITH ACUTE
        #x0148 ; LATIN SMALL LETTER N WITH CARON
        #x0149 ; LATIN SMALL LETTER N PRECEDED BY APOSTROPHE
        #x014A ; LATIN CAPITAL LETTER ENG
        #x014B ; LATIN SMALL LETTER ENG
        #x014D ; LATIN SMALL LETTER O WITH MACRON
        #x0152 ; LATIN CAPITAL LIGATURE OE
        #x0153 ; LATIN SMALL LIGATURE OE
        #x0166 ; LATIN CAPITAL LETTER T WITH STROKE
        #x0167 ; LATIN SMALL LETTER T WITH STROKE
        #x016B ; LATIN SMALL LETTER U WITH MACRON
        #x01CE ; LATIN SMALL LETTER A WITH CARON
        #x01D0 ; LATIN SMALL LETTER I WITH CARON
        #x01D2 ; LATIN SMALL LETTER O WITH CARON
        #x01D4 ; LATIN SMALL LETTER U WITH CARON
        #x01D6 ; LATIN SMALL LETTER U WITH DIAERESIS AND MACRON
        #x01D8 ; LATIN SMALL LETTER U WITH DIAERESIS AND ACUTE
        #x01DA ; LATIN SMALL LETTER U WITH DIAERESIS AND CARON
        #x01DC ; LATIN SMALL LETTER U WITH DIAERESIS AND GRAVE
        #x0251 ; LATIN SMALL LETTER ALPHA
        #x0261 ; LATIN SMALL LETTER SCRIPT G
        #x02C4 ; MODIFIER LETTER UP ARROWHEAD
        #x02C7 ; CARON
        (#x02C9 . #x02D0) ; MODIFIER LETTER
        #x02D8 ; BREVE
        #x02D9 ; DOT ABOVE
        #x02DA ; RING ABOVE
        #x02DB ; OGONEK
        #x02DD ; DOUBLE ACUTE ACCENT
        #x02DF ; MODIFIER LETTER CROSS ACCENT
        (#x0300 . #x036F) ; COMBINING
        (#x0391 . #x03A9) ; GREEK CAPITAL LETTER
        (#x03B1 . #x03C9) ; GREEK SMALL LETTER
        #x0401 ; CYRILLIC CAPITAL LETTER IO
        #x0410 ; CYRILLIC CAPITAL LETTER A
        #x0411 ; CYRILLIC CAPITAL LETTER BE
        #x0412 ; CYRILLIC CAPITAL LETTER VE
        #x0413 ; CYRILLIC CAPITAL LETTER GHE
        #x0414 ; CYRILLIC CAPITAL LETTER DE
        #x0415 ; CYRILLIC CAPITAL LETTER IE
        #x0416 ; CYRILLIC CAPITAL LETTER ZHE
        #x0417 ; CYRILLIC CAPITAL LETTER ZE
        #x0418 ; CYRILLIC CAPITAL LETTER I
        #x0419 ; CYRILLIC CAPITAL LETTER SHORT I
        #x041A ; CYRILLIC CAPITAL LETTER KA
        #x041B ; CYRILLIC CAPITAL LETTER EL
        #x041C ; CYRILLIC CAPITAL LETTER EM
        #x041D ; CYRILLIC CAPITAL LETTER EN
        #x041E ; CYRILLIC CAPITAL LETTER O
        #x041F ; CYRILLIC CAPITAL LETTER PE
        #x0420 ; CYRILLIC CAPITAL LETTER ER
        #x0421 ; CYRILLIC CAPITAL LETTER ES
        #x0422 ; CYRILLIC CAPITAL LETTER TE
        #x0423 ; CYRILLIC CAPITAL LETTER U
        #x0424 ; CYRILLIC CAPITAL LETTER EF
        #x0425 ; CYRILLIC CAPITAL LETTER HA
        #x0426 ; CYRILLIC CAPITAL LETTER TSE
        #x0427 ; CYRILLIC CAPITAL LETTER CHE
        #x0428 ; CYRILLIC CAPITAL LETTER SHA
        #x0429 ; CYRILLIC CAPITAL LETTER SHCHA
        #x042A ; CYRILLIC CAPITAL LETTER HARD SIGN
        #x042B ; CYRILLIC CAPITAL LETTER YERU
        #x042C ; CYRILLIC CAPITAL LETTER SOFT SIGN
        #x042D ; CYRILLIC CAPITAL LETTER E
        #x042E ; CYRILLIC CAPITAL LETTER YU
        #x042F ; CYRILLIC CAPITAL LETTER YA
        #x0430 ; CYRILLIC SMALL LETTER A
        #x0431 ; CYRILLIC SMALL LETTER BE
        #x0432 ; CYRILLIC SMALL LETTER VE
        #x0433 ; CYRILLIC SMALL LETTER GHE
        #x0434 ; CYRILLIC SMALL LETTER DE
        #x0435 ; CYRILLIC SMALL LETTER IE
        #x0436 ; CYRILLIC SMALL LETTER ZHE
        #x0437 ; CYRILLIC SMALL LETTER ZE
        #x0438 ; CYRILLIC SMALL LETTER I
        #x0439 ; CYRILLIC SMALL LETTER SHORT I
        #x043A ; CYRILLIC SMALL LETTER KA
        #x043B ; CYRILLIC SMALL LETTER EL
        #x043C ; CYRILLIC SMALL LETTER EM
        #x043D ; CYRILLIC SMALL LETTER EN
        #x043E ; CYRILLIC SMALL LETTER O
        #x043F ; CYRILLIC SMALL LETTER PE
        #x0440 ; CYRILLIC SMALL LETTER ER
        #x0441 ; CYRILLIC SMALL LETTER ES
        #x0442 ; CYRILLIC SMALL LETTER TE
        #x0443 ; CYRILLIC SMALL LETTER U
        #x0444 ; CYRILLIC SMALL LETTER EF
        #x0445 ; CYRILLIC SMALL LETTER HA
        #x0446 ; CYRILLIC SMALL LETTER TSE
        #x0447 ; CYRILLIC SMALL LETTER CHE
        #x0448 ; CYRILLIC SMALL LETTER SHA
        #x0449 ; CYRILLIC SMALL LETTER SHCHA
        #x044A ; CYRILLIC SMALL LETTER HARD SIGN
        #x044B ; CYRILLIC SMALL LETTER YERU
        #x044C ; CYRILLIC SMALL LETTER SOFT SIGN
        #x044D ; CYRILLIC SMALL LETTER E
        #x044E ; CYRILLIC SMALL LETTER YU
        #x044F ; CYRILLIC SMALL LETTER YA
        #x0451 ; CYRILLIC SMALL LETTER IO
        #x2010 ; HYPHEN
        #x2013 ; EN DASH
        #x2014 ; EM DASH
        #x2015 ; HORIZONTAL BAR
        #x2016 ; DOUBLE VERTICAL LINE
        #x2018 ; LEFT SINGLE QUOTATION MARK
        #x2019 ; RIGHT SINGLE QUOTATION MARK
        #x201C ; LEFT DOUBLE QUOTATION MARK
        #x201D ; RIGHT DOUBLE QUOTATION MARK
        #x2020 ; DAGGER
        #x2021 ; DOUBLE DAGGER
        #x2022 ; BULLET
        #x2024 ; ONE DOT LEADER
        #x2025 ; TWO DOT LEADER
        #x2026 ; HORIZONTAL ELLIPSIS
        #x2027 ; HYPHENATION POINT
        #x2030 ; PER MILLE SIGN
        #x2032 ; PRIME
        #x2033 ; DOUBLE PRIME
        #x2035 ; REVERSED PRIME
        #x203B ; REFERENCE MARK
        #x203E ; OVERLINE
        #x2074 ; SUPERSCRIPT FOUR
        #x207F ; SUPERSCRIPT LATIN SMALL LETTER N
        #x2081 ; SUBSCRIPT ONE
        #x2082 ; SUBSCRIPT TWO
        #x2083 ; SUBSCRIPT THREE
        #x2084 ; SUBSCRIPT FOUR
        #x20AC ; EURO SIGN
        #x2103 ; DEGREE CELSIUS
        #x2105 ; CARE OF
        #x2109 ; DEGREE FAHRENHEIT
        #x2113 ; SCRIPT SMALL L
        #x2116 ; NUMERO SIGN
        #x2121 ; TELEPHONE SIGN
        #x2122 ; TRADE MARK SIGN
        #x2126 ; OHM SIGN
        #x212B ; ANGSTROM SIGN
        #x2153 ; VULGAR FRACTION ONE THIRD
        #x2154 ; VULGAR FRACTION TWO THIRDS
        #x215B ; VULGAR FRACTION ONE EIGHTH
        #x215C ; VULGAR FRACTION THREE EIGHTHS
        #x215D ; VULGAR FRACTION FIVE EIGHTHS
        #x215E ; VULGAR FRACTION SEVEN EIGHTHS
        #x2160 ; ROMAN NUMERAL ONE
        #x2161 ; ROMAN NUMERAL TWO
        #x2162 ; ROMAN NUMERAL THREE
        #x2163 ; ROMAN NUMERAL FOUR
        #x2164 ; ROMAN NUMERAL FIVE
        #x2165 ; ROMAN NUMERAL SIX
        #x2166 ; ROMAN NUMERAL SEVEN
        #x2167 ; ROMAN NUMERAL EIGHT
        #x2168 ; ROMAN NUMERAL NINE
        #x2169 ; ROMAN NUMERAL TEN
        #x216A ; ROMAN NUMERAL ELEVEN
        #x216B ; ROMAN NUMERAL TWELVE
        #x2170 ; SMALL ROMAN NUMERAL ONE
        #x2171 ; SMALL ROMAN NUMERAL TWO
        #x2172 ; SMALL ROMAN NUMERAL THREE
        #x2173 ; SMALL ROMAN NUMERAL FOUR
        #x2174 ; SMALL ROMAN NUMERAL FIVE
        #x2175 ; SMALL ROMAN NUMERAL SIX
        #x2176 ; SMALL ROMAN NUMERAL SEVEN
        #x2177 ; SMALL ROMAN NUMERAL EIGHT
        #x2178 ; SMALL ROMAN NUMERAL NINE
        #x2179 ; SMALL ROMAN NUMERAL TEN
        #x2189 ; VULGAR FRACTION ZERO THIRDS
        #x2190 ; LEFTWARDS ARROW
        #x2191 ; UPWARDS ARROW
        #x2192 ; RIGHTWARDS ARROW
        #x2193 ; DOWNWARDS ARROW
        #x2194 ; LEFT RIGHT ARROW
        #x2195 ; UP DOWN ARROW
        #x2196 ; NORTH WEST ARROW
        #x2197 ; NORTH EAST ARROW
        #x2198 ; SOUTH EAST ARROW
        #x2199 ; SOUTH WEST ARROW
        #x21B8 ; NORTH WEST ARROW TO LONG BAR
        #x21B9 ; LEFTWARDS ARROW TO BAR OVER RIGHTWARDS ARROW TO BAR
        #x21D2 ; RIGHTWARDS DOUBLE ARROW
        #x21D4 ; LEFT RIGHT DOUBLE ARROW
        #x21E7 ; UPWARDS WHITE ARROW
        #x2200 ; FOR ALL
        #x2202 ; PARTIAL DIFFERENTIAL
        #x2203 ; THERE EXISTS
        #x2207 ; NABLA
        #x2208 ; ELEMENT OF
        #x220B ; CONTAINS AS MEMBER
        #x220F ; N-ARY PRODUCT
        #x2211 ; N-ARY SUMMATION
        #x2215 ; DIVISION SLASH
        #x221A ; SQUARE ROOT
        #x221D ; PROPORTIONAL TO
        #x221E ; INFINITY
        #x221F ; RIGHT ANGLE
        #x2220 ; ANGLE
        #x2223 ; DIVIDES
        #x2225 ; PARALLEL TO
        #x2227 ; LOGICAL AND
        #x2228 ; LOGICAL OR
        #x2229 ; INTERSECTION
        #x222A ; UNION
        #x222B ; INTEGRAL
        #x222C ; DOUBLE INTEGRAL
        #x222E ; CONTOUR INTEGRAL
        #x2234 ; THEREFORE
        #x2235 ; BECAUSE
        #x2236 ; RATIO
        #x2237 ; PROPORTION
        #x223C ; TILDE OPERATOR
        #x223D ; REVERSED TILDE
        #x2248 ; ALMOST EQUAL TO
        #x224C ; ALL EQUAL TO
        #x2252 ; APPROXIMATELY EQUAL TO OR THE IMAGE OF
        #x2260 ; NOT EQUAL TO
        #x2261 ; IDENTICAL TO
        #x2264 ; LESS-THAN OR EQUAL TO
        #x2265 ; GREATER-THAN OR EQUAL TO
        #x2266 ; LESS-THAN OVER EQUAL TO
        #x2267 ; GREATER-THAN OVER EQUAL TO
        #x226A ; MUCH LESS-THAN
        #x226B ; MUCH GREATER-THAN
        #x226E ; NOT LESS-THAN
        #x226F ; NOT GREATER-THAN
        #x2282 ; SUBSET OF
        #x2283 ; SUPERSET OF
        #x2286 ; SUBSET OF OR EQUAL TO
        #x2287 ; SUPERSET OF OR EQUAL TO
        #x2295 ; CIRCLED PLUS
        #x2299 ; CIRCLED DOT OPERATOR
        #x22A5 ; UP TACK
        #x22BF ; RIGHT TRIANGLE
        #x2312 ; ARC
        #x2460 ; CIRCLED DIGIT ONE
        #x2461 ; CIRCLED DIGIT TWO
        #x2462 ; CIRCLED DIGIT THREE
        #x2463 ; CIRCLED DIGIT FOUR
        #x2464 ; CIRCLED DIGIT FIVE
        #x2465 ; CIRCLED DIGIT SIX
        #x2466 ; CIRCLED DIGIT SEVEN
        #x2467 ; CIRCLED DIGIT EIGHT
        #x2468 ; CIRCLED DIGIT NINE
        #x2469 ; CIRCLED NUMBER TEN
        #x246A ; CIRCLED NUMBER ELEVEN
        #x246B ; CIRCLED NUMBER TWELVE
        #x246C ; CIRCLED NUMBER THIRTEEN
        #x246D ; CIRCLED NUMBER FOURTEEN
        #x246E ; CIRCLED NUMBER FIFTEEN
        #x246F ; CIRCLED NUMBER SIXTEEN
        #x2470 ; CIRCLED NUMBER SEVENTEEN
        #x2471 ; CIRCLED NUMBER EIGHTEEN
        #x2472 ; CIRCLED NUMBER NINETEEN
        #x2473 ; CIRCLED NUMBER TWENTY
        #x2474 ; PARENTHESIZED DIGIT ONE
        #x2475 ; PARENTHESIZED DIGIT TWO
        #x2476 ; PARENTHESIZED DIGIT THREE
        #x2477 ; PARENTHESIZED DIGIT FOUR
        #x2478 ; PARENTHESIZED DIGIT FIVE
        #x2479 ; PARENTHESIZED DIGIT SIX
        #x247A ; PARENTHESIZED DIGIT SEVEN
        #x247B ; PARENTHESIZED DIGIT EIGHT
        #x247C ; PARENTHESIZED DIGIT NINE
        #x247D ; PARENTHESIZED NUMBER TEN
        #x247E ; PARENTHESIZED NUMBER ELEVEN
        #x247F ; PARENTHESIZED NUMBER TWELVE
        #x2480 ; PARENTHESIZED NUMBER THIRTEEN
        #x2481 ; PARENTHESIZED NUMBER FOURTEEN
        #x2482 ; PARENTHESIZED NUMBER FIFTEEN
        #x2483 ; PARENTHESIZED NUMBER SIXTEEN
        #x2484 ; PARENTHESIZED NUMBER SEVENTEEN
        #x2485 ; PARENTHESIZED NUMBER EIGHTEEN
        #x2486 ; PARENTHESIZED NUMBER NINETEEN
        #x2487 ; PARENTHESIZED NUMBER TWENTY
        #x2488 ; DIGIT ONE FULL STOP
        #x2489 ; DIGIT TWO FULL STOP
        #x248A ; DIGIT THREE FULL STOP
        #x248B ; DIGIT FOUR FULL STOP
        #x248C ; DIGIT FIVE FULL STOP
        #x248D ; DIGIT SIX FULL STOP
        #x248E ; DIGIT SEVEN FULL STOP
        #x248F ; DIGIT EIGHT FULL STOP
        #x2490 ; DIGIT NINE FULL STOP
        #x2491 ; NUMBER TEN FULL STOP
        #x2492 ; NUMBER ELEVEN FULL STOP
        #x2493 ; NUMBER TWELVE FULL STOP
        #x2494 ; NUMBER THIRTEEN FULL STOP
        #x2495 ; NUMBER FOURTEEN FULL STOP
        #x2496 ; NUMBER FIFTEEN FULL STOP
        #x2497 ; NUMBER SIXTEEN FULL STOP
        #x2498 ; NUMBER SEVENTEEN FULL STOP
        #x2499 ; NUMBER EIGHTEEN FULL STOP
        #x249A ; NUMBER NINETEEN FULL STOP
        #x249B ; NUMBER TWENTY FULL STOP
        #x249C ; PARENTHESIZED LATIN SMALL LETTER A
        #x249D ; PARENTHESIZED LATIN SMALL LETTER B
        #x249E ; PARENTHESIZED LATIN SMALL LETTER C
        #x249F ; PARENTHESIZED LATIN SMALL LETTER D
        #x24A0 ; PARENTHESIZED LATIN SMALL LETTER E
        #x24A1 ; PARENTHESIZED LATIN SMALL LETTER F
        #x24A2 ; PARENTHESIZED LATIN SMALL LETTER G
        #x24A3 ; PARENTHESIZED LATIN SMALL LETTER H
        #x24A4 ; PARENTHESIZED LATIN SMALL LETTER I
        #x24A5 ; PARENTHESIZED LATIN SMALL LETTER J
        #x24A6 ; PARENTHESIZED LATIN SMALL LETTER K
        #x24A7 ; PARENTHESIZED LATIN SMALL LETTER L
        #x24A8 ; PARENTHESIZED LATIN SMALL LETTER M
        #x24A9 ; PARENTHESIZED LATIN SMALL LETTER N
        #x24AA ; PARENTHESIZED LATIN SMALL LETTER O
        #x24AB ; PARENTHESIZED LATIN SMALL LETTER P
        #x24AC ; PARENTHESIZED LATIN SMALL LETTER Q
        #x24AD ; PARENTHESIZED LATIN SMALL LETTER R
        #x24AE ; PARENTHESIZED LATIN SMALL LETTER S
        #x24AF ; PARENTHESIZED LATIN SMALL LETTER T
        #x24B0 ; PARENTHESIZED LATIN SMALL LETTER U
        #x24B1 ; PARENTHESIZED LATIN SMALL LETTER V
        #x24B2 ; PARENTHESIZED LATIN SMALL LETTER W
        #x24B3 ; PARENTHESIZED LATIN SMALL LETTER X
        #x24B4 ; PARENTHESIZED LATIN SMALL LETTER Y
        #x24B5 ; PARENTHESIZED LATIN SMALL LETTER Z
        #x24B6 ; CIRCLED LATIN CAPITAL LETTER A
        #x24B7 ; CIRCLED LATIN CAPITAL LETTER B
        #x24B8 ; CIRCLED LATIN CAPITAL LETTER C
        #x24B9 ; CIRCLED LATIN CAPITAL LETTER D
        #x24BA ; CIRCLED LATIN CAPITAL LETTER E
        #x24BB ; CIRCLED LATIN CAPITAL LETTER F
        #x24BC ; CIRCLED LATIN CAPITAL LETTER G
        #x24BD ; CIRCLED LATIN CAPITAL LETTER H
        #x24BE ; CIRCLED LATIN CAPITAL LETTER I
        #x24BF ; CIRCLED LATIN CAPITAL LETTER J
        #x24C0 ; CIRCLED LATIN CAPITAL LETTER K
        #x24C1 ; CIRCLED LATIN CAPITAL LETTER L
        #x24C2 ; CIRCLED LATIN CAPITAL LETTER M
        #x24C3 ; CIRCLED LATIN CAPITAL LETTER N
        #x24C4 ; CIRCLED LATIN CAPITAL LETTER O
        #x24C5 ; CIRCLED LATIN CAPITAL LETTER P
        #x24C6 ; CIRCLED LATIN CAPITAL LETTER Q
        #x24C7 ; CIRCLED LATIN CAPITAL LETTER R
        #x24C8 ; CIRCLED LATIN CAPITAL LETTER S
        #x24C9 ; CIRCLED LATIN CAPITAL LETTER T
        #x24CA ; CIRCLED LATIN CAPITAL LETTER U
        #x24CB ; CIRCLED LATIN CAPITAL LETTER V
        #x24CC ; CIRCLED LATIN CAPITAL LETTER W
        #x24CD ; CIRCLED LATIN CAPITAL LETTER X
        #x24CE ; CIRCLED LATIN CAPITAL LETTER Y
        #x24CF ; CIRCLED LATIN CAPITAL LETTER Z
        #x24D0 ; CIRCLED LATIN SMALL LETTER A
        #x24D1 ; CIRCLED LATIN SMALL LETTER B
        #x24D2 ; CIRCLED LATIN SMALL LETTER C
        #x24D3 ; CIRCLED LATIN SMALL LETTER D
        #x24D4 ; CIRCLED LATIN SMALL LETTER E
        #x24D5 ; CIRCLED LATIN SMALL LETTER F
        #x24D6 ; CIRCLED LATIN SMALL LETTER G
        #x24D7 ; CIRCLED LATIN SMALL LETTER H
        #x24D8 ; CIRCLED LATIN SMALL LETTER I
        #x24D9 ; CIRCLED LATIN SMALL LETTER J
        #x24DA ; CIRCLED LATIN SMALL LETTER K
        #x24DB ; CIRCLED LATIN SMALL LETTER L
        #x24DC ; CIRCLED LATIN SMALL LETTER M
        #x24DD ; CIRCLED LATIN SMALL LETTER N
        #x24DE ; CIRCLED LATIN SMALL LETTER O
        #x24DF ; CIRCLED LATIN SMALL LETTER P
        #x24E0 ; CIRCLED LATIN SMALL LETTER Q
        #x24E1 ; CIRCLED LATIN SMALL LETTER R
        #x24E2 ; CIRCLED LATIN SMALL LETTER S
        #x24E3 ; CIRCLED LATIN SMALL LETTER T
        #x24E4 ; CIRCLED LATIN SMALL LETTER U
        #x24E5 ; CIRCLED LATIN SMALL LETTER V
        #x24E6 ; CIRCLED LATIN SMALL LETTER W
        #x24E7 ; CIRCLED LATIN SMALL LETTER X
        #x24E8 ; CIRCLED LATIN SMALL LETTER Y
        #x24E9 ; CIRCLED LATIN SMALL LETTER Z
        #x24EB ; NEGATIVE CIRCLED NUMBER ELEVEN
        #x24EC ; NEGATIVE CIRCLED NUMBER TWELVE
        #x24ED ; NEGATIVE CIRCLED NUMBER THIRTEEN
        #x24EE ; NEGATIVE CIRCLED NUMBER FOURTEEN
        #x24EF ; NEGATIVE CIRCLED NUMBER FIFTEEN
        #x24F0 ; NEGATIVE CIRCLED NUMBER SIXTEEN
        #x24F1 ; NEGATIVE CIRCLED NUMBER SEVENTEEN
        #x24F2 ; NEGATIVE CIRCLED NUMBER EIGHTEEN
        #x24F3 ; NEGATIVE CIRCLED NUMBER NINETEEN
        #x24F4 ; NEGATIVE CIRCLED NUMBER TWENTY
        #x24F5 ; DOUBLE CIRCLED DIGIT ONE
        #x24F6 ; DOUBLE CIRCLED DIGIT TWO
        #x24F7 ; DOUBLE CIRCLED DIGIT THREE
        #x24F8 ; DOUBLE CIRCLED DIGIT FOUR
        #x24F9 ; DOUBLE CIRCLED DIGIT FIVE
        #x24FA ; DOUBLE CIRCLED DIGIT SIX
        #x24FB ; DOUBLE CIRCLED DIGIT SEVEN
        #x24FC ; DOUBLE CIRCLED DIGIT EIGHT
        #x24FD ; DOUBLE CIRCLED DIGIT NINE
        #x24FE ; DOUBLE CIRCLED NUMBER TEN
        #x24FF ; NEGATIVE CIRCLED DIGIT ZERO
        (#x2500 . #x254B) ; BOX DRAWINGS
        (#x2550 . #x2573) ; BOX DRAWINGS
        #x2580 ; UPPER HALF BLOCK
        #x2581 ; LOWER ONE EIGHTH BLOCK
        #x2582 ; LOWER ONE QUARTER BLOCK
        #x2583 ; LOWER THREE EIGHTHS BLOCK
        #x2584 ; LOWER HALF BLOCK
        #x2585 ; LOWER FIVE EIGHTHS BLOCK
        #x2586 ; LOWER THREE QUARTERS BLOCK
        #x2587 ; LOWER SEVEN EIGHTHS BLOCK
        #x2588 ; FULL BLOCK
        #x2589 ; LEFT SEVEN EIGHTHS BLOCK
        #x258A ; LEFT THREE QUARTERS BLOCK
        #x258B ; LEFT FIVE EIGHTHS BLOCK
        #x258C ; LEFT HALF BLOCK
        #x258D ; LEFT THREE EIGHTHS BLOCK
        #x258E ; LEFT ONE QUARTER BLOCK
        #x258F ; LEFT ONE EIGHTH BLOCK
        #x2592 ; MEDIUM SHADE
        #x2593 ; DARK SHADE
        #x2594 ; UPPER ONE EIGHTH BLOCK
        #x2595 ; RIGHT ONE EIGHTH BLOCK
        #x25A0 ; BLACK SQUARE
        #x25A1 ; WHITE SQUARE
        #x25A3 ; WHITE SQUARE CONTAINING BLACK SMALL SQUARE
        #x25A4 ; SQUARE WITH HORIZONTAL FILL
        #x25A5 ; SQUARE WITH VERTICAL FILL
        #x25A6 ; SQUARE WITH ORTHOGONAL CROSSHATCH FILL
        #x25A7 ; SQUARE WITH UPPER LEFT TO LOWER RIGHT FILL
        #x25A8 ; SQUARE WITH UPPER RIGHT TO LOWER LEFT FILL
        #x25A9 ; SQUARE WITH DIAGONAL CROSSHATCH FILL
        #x25B2 ; BLACK UP-POINTING TRIANGLE
        #x25B3 ; WHITE UP-POINTING TRIANGLE
        #x25B6 ; BLACK RIGHT-POINTING TRIANGLE
        #x25B7 ; WHITE RIGHT-POINTING TRIANGLE
        #x25BC ; BLACK DOWN-POINTING TRIANGLE
        #x25BD ; WHITE DOWN-POINTING TRIANGLE
        #x25C0 ; BLACK LEFT-POINTING TRIANGLE
        #x25C1 ; WHITE LEFT-POINTING TRIANGLE
        #x25C6 ; BLACK DIAMOND
        #x25C7 ; WHITE DIAMOND
        #x25C8 ; WHITE DIAMOND CONTAINING BLACK SMALL DIAMOND
        #x25CB ; WHITE CIRCLE
        #x25CE ; BULLSEYE
        #x25CF ; BLACK CIRCLE
        #x25D0 ; CIRCLE WITH LEFT HALF BLACK
        #x25D1 ; CIRCLE WITH RIGHT HALF BLACK
        #x25E2 ; BLACK LOWER RIGHT TRIANGLE
        #x25E3 ; BLACK LOWER LEFT TRIANGLE
        #x25E4 ; BLACK UPPER LEFT TRIANGLE
        #x25E5 ; BLACK UPPER RIGHT TRIANGLE
        #x25EF ; LARGE CIRCLE
        #x2605 ; BLACK STAR
        #x2606 ; WHITE STAR
        #x2609 ; SUN
        #x260E ; BLACK TELEPHONE
        #x260F ; WHITE TELEPHONE
        #x2614 ; UMBRELLA WITH RAIN DROPS
        #x2615 ; HOT BEVERAGE
        #x261C ; WHITE LEFT POINTING INDEX
        #x261E ; WHITE RIGHT POINTING INDEX
        #x2640 ; FEMALE SIGN
        #x2642 ; MALE SIGN
        #x2660 ; BLACK SPADE SUIT
        #x2661 ; WHITE HEART SUIT
        #x2663 ; BLACK CLUB SUIT
        #x2664 ; WHITE SPADE SUIT
        #x2665 ; BLACK HEART SUIT
        #x2667 ; WHITE CLUB SUIT
        #x2668 ; HOT SPRINGS
        #x2669 ; QUARTER NOTE
        #x266A ; EIGHTH NOTE
        #x266C ; BEAMED SIXTEENTH NOTES
        #x266D ; MUSIC FLAT SIGN
        #x266F ; MUSIC SHARP SIGN
        #x269E ; THREE LINES CONVERGING RIGHT
        #x269F ; THREE LINES CONVERGING LEFT
        #x26BE ; BASEBALL
        #x26BF ; SQUARED KEY
        #x26C4 ; SNOWMAN WITHOUT SNOW
        #x26C5 ; SUN BEHIND CLOUD
        #x26C6 ; RAIN
        #x26C7 ; BLACK SNOWMAN
        #x26C8 ; THUNDER CLOUD AND RAIN
        #x26C9 ; TURNED WHITE SHOGI PIECE
        #x26CA ; TURNED BLACK SHOGI PIECE
        #x26CB ; WHITE DIAMOND IN SQUARE
        #x26CC ; CROSSING LANES
        #x26CD ; DISABLED CAR
        #x26CF ; PICK
        #x26D0 ; CAR SLIDING
        #x26D1 ; HELMET WITH WHITE CROSS
        #x26D2 ; CIRCLED CROSSING LANES
        #x26D3 ; CHAINS
        #x26D4 ; NO ENTRY
        #x26D5 ; ALTERNATE ONE-WAY LEFT WAY TRAFFIC
        #x26D6 ; BLACK TWO-WAY LEFT WAY TRAFFIC
        #x26D7 ; WHITE TWO-WAY LEFT WAY TRAFFIC
        #x26D8 ; BLACK LEFT LANE MERGE
        #x26D9 ; WHITE LEFT LANE MERGE
        #x26DA ; DRIVE SLOW SIGN
        #x26DB ; HEAVY WHITE DOWN-POINTING TRIANGLE
        #x26DC ; LEFT CLOSED ENTRY
        #x26DD ; SQUARED SALTIRE
        #x26DE ; FALLING DIAGONAL IN WHITE CIRCLE IN BLACK SQUARE
        #x26DF ; BLACK TRUCK
        #x26E0 ; RESTRICTED LEFT ENTRY-1
        #x26E1 ; RESTRICTED LEFT ENTRY-2
        #x26E3 ; HEAVY CIRCLE WITH STROKE AND TWO DOTS ABOVE
        #x26E8 ; BLACK CROSS ON SHIELD
        #x26E9 ; SHINTO SHRINE
        #x26EA ; CHURCH
        #x26EB ; CASTLE
        #x26EC ; HISTORIC SITE
        #x26ED ; GEAR WITHOUT HUB
        #x26EE ; GEAR WITH HANDLES
        #x26EF ; MAP SYMBOL FOR LIGHTHOUSE
        #x26F0 ; MOUNTAIN
        #x26F1 ; UMBRELLA ON GROUND
        #x26F2 ; FOUNTAIN
        #x26F3 ; FLAG IN HOLE
        #x26F4 ; FERRY
        #x26F5 ; SAILBOAT
        #x26F6 ; SQUARE FOUR CORNERS
        #x26F7 ; SKIER
        #x26F8 ; ICE SKATE
        #x26F9 ; PERSON WITH BALL
        #x26FA ; TENT
        #x26FB ; JAPANESE BANK SYMBOL
        #x26FC ; HEADSTONE GRAVEYARD SYMBOL
        #x26FD ; FUEL PUMP
        #x26FE ; CUP ON BLACK SQUARE
        #x26FF ; WHITE FLAG WITH HORIZONTAL MIDDLE BLACK STRIPE
        #x273D ; HEAVY TEARDROP-SPOKED ASTERISK
        #x2757 ; HEAVY EXCLAMATION MARK SYMBOL
        (#x2776 . #x277F) ; DINGBAT NEGATIVE CIRCLED DIGIT
        #x2B55 ; HEAVY LARGE CIRCLE
        #x2B56 ; HEAVY OVAL WITH OVAL INSIDE
        #x2B57 ; HEAVY CIRCLE WITH CIRCLE INSIDE
        #x2B58 ; HEAVY CIRCLE
        #x2B59 ; HEAVY CIRCLED SALTIRE
        (#x3248 . #x324F) ; CIRCLED NUMBER
        (#xFE00 . #xFE0F) ; VARIATION SELECTOR
        #xFFFD ; REPLACEMENT CHARACTER
        ))

(when (= emacs-major-version 22)
  (utf-translate-cjk-set-unicode-range east-asian-ambiguous))

(when (>= emacs-major-version 23)
  (while (char-table-parent char-width-table)
    (setq char-width-table (char-table-parent char-width-table)))
  (let ((table (make-char-table nil)))
    (mapc (lambda (range) (set-char-table-range table range 2))
          east-asian-ambiguous)
    (optimize-char-table table)
    (set-char-table-parent table char-width-table)
    (setq char-width-table table)))

;; Load custom settings
(when (file-exists-p "~/.emacs.d/custom.el")
  (load (expand-file-name "~/.emacs.d/custom")))

;(condition-case nil
;    (load (expand-file-name "~/.emacs.d/custom"))
;  (error nil))
