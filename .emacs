;;; .emacs
;;; $Id: init.el,v 1.20 2008-04-10 14:45:57 hamano Exp $
;;;

(add-to-list 'load-path "~/.emacs.d/site-lisp")

;; User information
(setq user-mail-address (getenv "EMAIL"))

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

;; Backup settings
; no create ~/.emacs.d/auto-save-list
(setq auto-save-list-file-prefix nil)

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
(setq transient-mark-mode t)
(show-paren-mode t)

;; Compilation settings
(setq compilation-window-height 8)
(setq compilation-scroll-output t)
(setq compilation-ask-about-save nil)

;; Version dependent settings
(cond
 ((= emacs-major-version 21)
  (iswitchb-default-keybindings)
  (resize-minibuffer-mode t)
  (tool-bar-mode nil))
 ((= emacs-major-version 22)
  (iswitchb-mode 1))
 ((= emacs-major-version 23)
  (iswitchb-mode 1))
 )

;; Theme settings
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;;(load-theme 'flatland t)
(load-theme 'misterioso t)

;; Face settings
(set-cursor-color "green")
;;(set-face-foreground 'default "white")
;;(set-face-background 'default "black")
;;(set-face-foreground 'region "white")
;;(set-face-background 'region "brightblack")
;;(set-face-foreground 'mode-line "black")
;;(set-face-background 'mode-line "white")
;;(set-face-background 'show-paren-match-face "yellow")
;;(set-face-foreground 'show-paren-match-face "black")

;; highliting white space at EOL
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

;; Package settings
(when (>= emacs-major-version 24)
  (package-initialize)
  (setq package-archives
        '(("gnu" . "http://elpa.gnu.org/packages/")
          ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
          ("melpa" . "http://melpa.org/packages/")
          ("org" . "http://orgmode.org/elpa/")
          ("marmalade" . "http://marmalade-repo.org/packages/")
          ))
  )

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
            (define-key text-mode-map "\C-c\C-c" 'compile)
            ))

(add-hook 'conf-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
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
            (c-set-style "linux")
            (c-toggle-auto-state -1)
            (c-toggle-hungry-state 1)
;            (setq indent-tabs-mode t)
;            (setq tab-width 4)
;            (setq c-basic-offset 4)
            (define-key c-mode-map "\C-c\C-m" 'manual-entry)
            (define-key c-mode-map "\C-c\C-c" 'compile)
            (define-key c-mode-map "\C-c\C-n" 'next-error)
            (define-key c-mode-map "\C-c\C-f" 'ff-find-other-file)
            ))

(add-hook 'c++-mode-hook
          (lambda ()
            (define-key c++-mode-map "\C-c\C-m" 'manual-entry)
            (define-key c++-mode-map "\C-c\C-c" 'compile)
            (define-key c++-mode-map "\C-c\C-n" 'next-error)
            (define-key c++-mode-map "\C-c\C-f" 'ff-find-other-file)
            ))

(defun compile-ant()
  (interactive)
  (let ((build-dir (locate-dominating-file default-directory "build.xml")))
    (when build-dir
      (with-temp-buffer
        (cd build-dir)
        (call-interactively 'compile)
        ))))

(add-hook
 'java-mode-hook
 (lambda ()
   (setq indent-tabs-mode nil)
   (setq compile-command "ant -emacs ")
   (define-key java-mode-map "\C-c\C-c" 'compile-ant)
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
            (define-key ruby-mode-map "\C-c\C-c" 'quickrun)
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

(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (setq tab-width 4)
            (setq indent-level 4)
            (setq python-indent 4)
            (define-key python-mode-map (kbd "C-c C-c")
              (lambda ()
                (interactive)
                (python-shell-get-or-create-process
                 (if (getenv "VIRTUAL_ENV") "python -i" "python3 -i")
                 nil t)
                (python-shell-send-buffer)
                ))
            ;;(call-interactively 'run-python)
            ;;(enlarge-window (/ (window-height) 2))
            ;; company mode
            ;;(when (locate-library "company")
            ;;(company-mode)
            ;;(define-key python-mode-map (kbd "M-/") 'company-complete))
            (when (locate-library "jedi")
              (setq jedi:complete-on-dot t)
              (jedi:setup)
              (define-key python-mode-map (kbd "M-/") 'jedi:complete))
            ))
(add-hook 'latex-mode-hook
          (lambda ()
            (define-key latex-mode-map "\C-c\C-c" 'compile)
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

(add-hook 'org-mode-hook
          (lambda ()
            (visual-line-mode)
            ))

;; auto-mode
(setq auto-mode-alist
      (append
       '(
;         ("Makefile" . makefile-mode)
         ("Changes" . change-log-mode)
         ("Corefile" . shell-script-mode)
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
  (setq hl-line-face 'underline)
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
(setq auto-insert-directory "~/etc/templates/")
(setq auto-insert-alist
      (append '(
                (c-mode . "gpl.c")
                (sh-mode . "templ.sh")
                (makefile-mode . "templ.mk")
                (make-mode . "templ.mk")
                (html-mode . "strict.html")
                (python-mode . "python.py")
                )))

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
(when (locate-library "erlang-mode")
  (add-to-list 'load-path "~/.emacs.d/site-lisp/erlang")
  (require 'erlang-start))

;; go settings
(when (locate-library "go-mode")
  (autoload 'go-mode "go-mode" nil t)
  (add-hook 'go-mode-hook
            '(lambda()
               (setq default-tab-width 4)
               (setq indent-tabs-mode t)
               ))
  (add-hook 'before-save-hook 'gofmt-before-save)
  )

;; lua-mode settings
(when (locate-library "lua-mode")
  (autoload 'lua-mode "lua-mode" "Lua editing mode." t)
  (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
  (add-hook 'lua-mode-hook
            (lambda ()
              (setq lua-indent-level 2)
              (setq lua-electric-flag nil)
              (abbrev-mode 0)
              )))

;; php-mode settings
(when (locate-library "php-mode")
  (add-to-list 'load-path "~/.emacs.d/site-lisp/php-mode")
  (autoload 'php-mode "php-mode" "Major mode for editing php code." t)
  (add-to-list 'auto-mode-alist '("\\.php$" . php-mode)))

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

  ; for reading HTML mail
  (when (locate-library "w3m")
    (require 'mime-w3m))

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
                  '((t (:foreground "brightblue"))))
  (my-wl-set-face 'wl-highlight-message-cited-text-3
                  '((t (:foreground "brightgreen"))))
  (my-wl-set-face 'wl-highlight-message-cited-text-4
                  '((t (:foreground "brightmagenta"))))
  (my-wl-set-face 'wl-highlight-message-cited-text-5
                  '((t (:foreground "brightcyan"))))
  (my-wl-set-face 'wl-highlight-message-cited-text-6
                  '((t (:foreground "brightyellow"))))
  (my-wl-set-face 'wl-highlight-message-cited-text-7
                  '((t (:foreground "brightred"))))
  (my-wl-set-face 'wl-highlight-message-cited-text-8
                  '((t (:foreground "brightwhite"))))

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

;; flycheck settings
(when (locate-library "flycheck")
  (add-hook 'after-init-hook #'global-flycheck-mode)
  )

;; google-translate settings
(when (locate-library "google-translate")
  (require 'google-translate)
  (global-set-key [(C x) (C x)] 'google-translate-at-point)
  (custom-set-variables
   '(google-translate-default-source-language "auto")
   '(google-translate-default-target-language "ja")))

;; auto-install settings
(add-to-list 'load-path "~/.emacs.d/auto-install/")
(when (locate-library "auto-install")
  (require 'auto-install)
  ;;(auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  )

;; markdown settings
(when (locate-library "markdown-mode")
  (autoload 'markdown-mode "markdown-mode"
    "Major mode for editing Markdown files" t)
  (add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))
  (add-hook 'markdown-mode-hook
            (lambda ()
              (define-key markdown-mode-map "\C-c\C-c" 'compile)
              )))

(when (locate-library "elixir-mode")
  (autoload 'elixir-mode "elixir-mode"
    "Major mode for editing Elixir files" t))

;; East Asian Width settings
(when (locate-library "eaw")
  (require 'eaw)
  (eaw-fullwidth))

(when (locate-library "etags-table")
  (require 'etags-table)
  (setq etags-table-search-up-depth 5)
  )
(global-set-key (kbd "C-]") 'find-tag)

(when (locate-library "open-junk-file")
  (require 'open-junk-file)
  (global-set-key (kbd "C-x C-j") 'open-junk-file))

(when (locate-library "lispxmp")
  (require 'lispxmp))

(when (locate-library "init-loader")
  (require 'init-loader))

(when (locate-library "quickrun")
  (require 'quickrun)
  (setq quickrun-focus-p nil)
  )

;; Load custom settings
(when (file-exists-p "~/.emacs.d/custom.el")
  (load (expand-file-name "~/.emacs.d/custom")))

;(condition-case nil
;    (load (expand-file-name "~/.emacs.d/custom"))
;  (error nil))
