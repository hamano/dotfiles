;;; init.el
;;; $Id: init.el,v 1.20 2008-04-10 14:45:57 hamano Exp $
;;;

(setq load-path (cons "~/.emacs.d/site-lisp" load-path))

;; Language configuration
;(require 'jisx0213)
;(set-language-environment "Japanese")

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

;; X
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

(add-hook 'shell-mode-hook
          (lambda ()
            (define-key shell-mode-map "\C-p" 'comint-previous-input)
            (define-key shell-mode-map "\C-n" 'comint-next-input)
            ))

(add-hook 'c-mode-common-hook
          (lambda ()
            (c-set-style "k&r")
            (setq c-basic-offset 4)
            (setq indent-tabs-mode nil)
            (setq compilation-ask-about-save nil)
            (setq compilation-window-height 8)
            (c-toggle-auto-state -1)
            (c-toggle-hungry-state -1)
            (define-key c-mode-map "\C-c\C-m" 'manual-entry)
            (define-key c-mode-map "\C-c\C-c" 'compile)
            (define-key c-mode-map "\C-c\C-n" 'next-error)
            (define-key c-mode-map "\C-c\C-f" 'ff-find-other-file)
            ))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (define-key emacs-lisp-mode-map "\C-c\C-d" 'checkdoc)
            ))

(add-hook 'lisp-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            ))

(add-hook 'sh-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
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
                ("\\.t$" . perl-mode)
                ) auto-mode-alist))

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
