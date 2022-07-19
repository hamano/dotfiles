;;; .emacs
;;; Commentary: initialization for Emacs
;;; Code:
(add-to-list 'load-path "~/.emacs.d/site-lisp")

;; User information
(setq user-mail-address (getenv "EMAIL"))

;; Language settings
(set-language-environment "Japanese")
(if (<= emacs-major-version 21)
    (require 'jisx0213))

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

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

(defun kill-whitespace ()
  (interactive "*")
  (save-excursion
    (save-restriction
      (save-match-data
        (progn
          (re-search-backward "[^ \t\r\n]" nil t)
          (re-search-forward "[ \t\r\n]+" nil t)
          (replace-match "" nil nil))))))

;; Keybind settings
(global-unset-key "\C-t") ; used by tmux
(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-x\C-u" 'undo) ; for continuous undo
(global-set-key "\M-h" 'kill-whitespace)
(global-set-key "\M-k"
                (lambda () (interactive) (kill-line 0))) ; backward kill line

;; Backup settings
; no create ~/.emacs.d/auto-save-list
(setq auto-save-list-file-prefix nil)

;; Common settings
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

;; highliting white space at EOL
(when (boundp 'show-trailing-whitespace)
  (setq-default show-trailing-whitespace t)
  (set-face-background 'trailing-whitespace "gray"))

;; Workaround TLS-related "Bad request" issue
;; https://www.reddit.com/r/orgmode/comments/cvmjjr/workaround_for_tlsrelated_bad_request_and_package/
(when (and (>= libgnutls-version 30603)
           (version<= (number-to-string emacs-major-version) "26.2"))
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))
(setq package-check-signature nil)

(when (>= emacs-major-version 26)
  (global-display-line-numbers-mode t))

(when (>= emacs-major-version 27)
  (tab-bar-mode 1))

;; Package settings
(when (>= emacs-major-version 24)
  (setq package-archives
        '(
          ("gnu" . "https://elpa.gnu.org/packages/")
          ("melpa-stable" . "https://stable.melpa.org/packages/")
          ;;("melpa" . "https://melpa.org/packages/")
          ;;("org" . "http://orgmode.org/elpa/")
          ;;("marmalade" . "http://marmalade-repo.org/packages/")
          ))
  (package-initialize)
  (setq package-list
        '(
          use-package
          multi-term
          ))
  (unless package-archive-contents (package-refresh-contents))
  (dolist (pkg package-list)
    (unless (package-installed-p pkg)
      (package-install pkg)))
  )

;; mlterm color settings
(defun terminal-init-mlterm ()
  (load "term/xterm")
  (cond ((>= emacs-major-version 25)
         (xterm-register-default-colors xterm-standard-colors))
        (t
         (xterm-register-default-colors))
        )
  (tty-set-up-initial-frame-faces))

;; Theme settings
;(add-to-list 'load-path "~/.emacs.d/themes")
(add-to-list 'custom-theme-load-path "~/etc/.emacs.d/themes/")
;;(load-theme 'misterioso t)

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-gruvbox16 t))

;; X settings
(if window-system
    (progn
      (tool-bar-mode nil)
      (mwheel-install)
      ;; Font settings
      (custom-set-faces
        '(default
           ((t (:family "UDEV Gothic" :foundry "twr " :slant normal :weight normal :height 160 :width normal)))))
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
(setq temporary-file-directory "~/.emacs.tmp")

(use-package lsp-mode
  :ensure t
  :hook (
         (python-mode . lsp)
         )
  )

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
            (define-key sh-mode-map "\C-c\C-c" 'executable-interpret)
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
            ;(c-set-style "linux")
            (c-toggle-auto-state -1)
            (c-toggle-hungry-state 0)
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
   (setq c-basic-offset 4)
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

(add-hook 'js-mode-hook
          (lambda ()
            (setq js-indent-level 2)
            (setq indent-tabs-mode nil)
            (setq tab-width 8)
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
                (python-shell-send-buffer t)
                ))
            ;;(call-interactively 'run-python)
            ;;(enlarge-window (/ (window-height) 2))
            ;; company mode
            ;;(when (locate-library "company")
            ;;(company-mode)
            ;;(define-key python-mode-map (kbd "M-/") 'company-complete))
;            (when (locate-library "jedi")
;              (setq jedi:complete-on-dot t)
;              (jedi:setup)
;              (define-key python-mode-map (kbd "M-/") 'jedi:complete))
            (setq python-shell-completion-native-enable nil)
            ))
(add-hook 'latex-mode-hook
          (lambda ()
            (define-key latex-mode-map "\C-c\C-c" 'compile)
            ))

(add-hook 'nxml-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            ))

(add-hook 'dns-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)
            ))

(add-hook 'org-mode-hook
          (lambda ()
            (visual-line-mode)
            ))

(add-hook 'objc-mode-hook
          '(lambda()
             (setq c-basic-offset 4)
             (setq tab-width 4)
             (setq indent-tabs-mode nil)))

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
         ("\\.vue$" . html-mode)
         ("\\.jinja2$" . html-mode)
         ("\\.t$" . perl-mode)
         ("\\.json$" . js-mode)
         ("\\.ts$" . js-mode)
         ("\\.sass$" . css-mode)
         ("\\.scss$" . css-mode)
         ) auto-mode-alist))

; packages
;; hl-line settings
(use-package hl-line
  :config
  (global-hl-line-mode)
  ;;(setq hl-line-face 'underline)
  (set-face-background 'hl-line "#393939")
  )

;; EditorConfig settings
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

;; ido-mode settings
(use-package ido
  :disabled t
  :config
  (ido-mode 1)
  (ido-everywhere t)
  (setq ido-enable-flex-matching t)
  (use-package ido-vertical-mode
    :ensure
    :config
    (ido-vertical-mode 1)
    (setq ido-vertical-define-keys 'C-n-and-C-p-only)
    (setq ido-vertical-show-count t)
    )
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

;; auto-complete settings
(use-package auto-complete
  :ensure
  :config
  (ac-config-default)
  (add-to-list 'ac-modes 'text-mode)
  (add-to-list 'ac-modes 'markdown-mode)
  (add-to-list 'ac-modes 'java-mode)
  (setq ac-use-menu-map t)
  (setq ac-use-fuzzy t)
  )

;; erlang-mode settings
(when (locate-library "erlang-mode")
  (add-to-list 'load-path "~/.emacs.d/site-lisp/erlang")
  (require 'erlang-start))

;; go settings
(use-package go-mode
  :ensure
  :config
  (autoload 'go-mode "go-mode" nil t)
  (add-hook 'go-mode-hook
            '(lambda()
               (setq default-tab-width 4)
               (setq indent-tabs-mode t)
               ))
  (add-hook 'before-save-hook 'gofmt-before-save)
  )

;; lua-mode settings
(use-package lua-mode
  :ensure
  :config
  (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
  (add-hook 'lua-mode-hook
            (lambda ()
              (setq lua-indent-level 2)
              (setq lua-electric-flag nil)
              (setq indent-tabs-mode nil)
              (abbrev-mode 0)
              )))

;; swift-mode settings
(use-package swift-mode
  :ensure
  :config
  (add-to-list 'auto-mode-alist '("\\.swift$" . swift-mode))
  (add-hook 'swift-mode-hook
            (lambda ())))

;; mmm-mode settings
(use-package mmm-mode
  :ensure
  :config
  (set-face-background 'mmm-default-submode-face nil)
  (mmm-add-classes
    '((vue-embeded-html-mode
        :submode html-mode
        :front "^<template>\n"
        :back "^</template>\n")
       (vue-embeded-js-mode
         :submode js-mode
         :front "^<script.*>\n"
         :back "^</script>")
       (vue-embeded-css-mode
         :submode css-mode
         :front "^<style.*>\n"
         :back "^</style>")
       (vue-embeded-yaml-mode
         :submode yaml-mode
         :front "^<i18n.*lang=\"yaml\".*>\n"
         :back "^</i18n>")
       ))
  (mmm-add-mode-ext-class 'html-mode "\\.vue\\'" 'vue-embeded-html-mode)
  (mmm-add-mode-ext-class 'html-mode "\\.vue\\'" 'vue-embeded-js-mode)
  (mmm-add-mode-ext-class 'html-mode "\\.vue\\'" 'vue-embeded-css-mode)
  (mmm-add-mode-ext-class 'html-mode "\\.vue\\'" 'vue-embeded-yaml-mode)
  )

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

;; groovy-mode settings
(use-package groovy-mode
  :ensure
  :config
  (autoload 'groovy-mode "groovy-mode" "Groovy mode." t)
  (add-to-list 'auto-mode-alist '("\\.gradle$" . groovy-mode))
  (add-hook 'groovy-mode-hook
            (lambda ()
              (setq indent-tabs-mode nil)
              (setq c-basic-offset 4)
              )))

;; rust-mode settings
(use-package rust-mode
  :ensure t
  :custom rust-format-on-save t)

(use-package cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode))

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
  (setq mime-setup-enable-inline-html 'w3m)
  (setq mime-view-text/html-previewer 'w3m)
  (setq mime-view-type-subtype-score-alist
        '(((text . plain) . 4)
          ((text . enriched) . 3)
          ((text . html) . 2)
          ((text . richtext) . 1)))
  (load "mime-setup")
  (autoload 'wl "wl" "Wanderlust" t)
  (autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)
  (setq wl-icon-directory "~/.emacs.d/site-lisp/wl/etc/icons")
  (setq mime-header-accept-quoted-encoded-words t)
  (setq wl-draft-buffer-style 'split)
  (setq wl-auto-select-first t)

  ; for reading HTML mail
  ;(when (locate-library "w3m")
  ;  (require 'mime-w3m))

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
;(use-package flycheck
;  :ensure
;  :init (global-flycheck-mode)
;  )

;; google-translate settings
(use-package google-translate
  :ensure
  :config
  (global-set-key [(C x) (C x)] 'google-translate-at-point)
  (setq google-translate-default-source-language "auto")
  (setq google-translate-default-target-language "ja")
  )

;; auto-install settings
(add-to-list 'load-path "~/.emacs.d/auto-install/")
(when (locate-library "auto-install")
  (require 'auto-install)
  ;;(auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  )

;; markdown-mode
(use-package markdown-mode
  :ensure
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :config
  (setq markdown-command "multimarkdown")
  (add-hook 'markdown-mode-hook
            (lambda ()
              (define-key markdown-mode-map "\C-c\C-c" 'compile)
              ))
  )

;; dockerfile-mode
(use-package dockerfile-mode
  :ensure
  :mode (("Dockerfile\\'" . dockerfile-mode))
  )

;; yaml-mode
(use-package yaml-mode
  :ensure
  :mode (("\\.yml\\'" . yaml-mode)
         ("\\.yaml\\'" . yaml-mode))
  )

(when (locate-library "elixir-mode")
  (autoload 'elixir-mode "elixir-mode"
    "Major mode for editing Elixir files" t))

;; East Asian Width settings
(when (locate-library "eaw")
  (require 'eaw)
  ;;(eaw-fullwidth)
  (eaw-set-width 1)
  )

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
(setq custom-file (concat user-emacs-directory "/custom.el"))
(when (file-exists-p custom-file)
  (load (expand-file-name custom-file)))

;(condition-case nil
;    (load (expand-file-name "~/.emacs.d/custom"))
;  (error nil))
