;;; package --- Summary
;;; Commentary: 
;;; This is my own personal customizations.  I borrowed
;;; them from a lot of places

;;; Code:

;; Set path from shell

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(setq initial-frame-alist '((top . 0) (left . 0) (width . 150) (height . 40)))

;; Place downloaded elisp files in this directory. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; 
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
(add-to-list 'load-path "~/.emacs.d/vendor")

;; shell scripts
(setq-default sh-basic-offset 2)
(setq-default sh-indentation 2)

;; Themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized")
(add-to-list 'load-path "~/.emacs.d/themes")

(set-face-attribute 'default nil :height 160)
(load-theme 'solarized-light t)
(set-frame-font "Consolas 14")

;; Flyspell often slows down editing so it's turned off
(remove-hook 'text-mode-hook 'turn-on-flyspell)

(load "~/.emacs.d/vendor/clojure")

;; hippie expand - don't try to complete with file names
(setq hippie-expand-try-functions-list (delete 'try-complete-file-name hippie-expand-try-functions-list))
(setq hippie-expand-try-functions-list (delete 'try-complete-file-name-partially hippie-expand-try-functions-list))

(setq ido-use-filename-at-point nil)

;; Save here instead of littering current directory with emacs backup files
(setq backup-directory-alist `(("." . "~/.saves")))

;; Javascript Customizations
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js2-mode))

(defvar camwest/packages
  '(js2-mode ac-js2 projectile flx-ido flycheck exec-path-from-shell tern tern-auto-complete))

(dolist (p camwest/packages)
  (when (not (package-installed-p p))
    (package-install p)))

(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)

(custom-set-variables
 '(js2-basic-offset 2)
 '(js2-bounce-indent-p t)
 '(js2-highlight-level 3)
 '(js2-mode-show-parse-errors nil)
 '(js2-mode-show-strict-warnings nil))

(defun my-js2-mode-hook ()
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'js2-mode-hook 'my-js2-mode-hook)

;;; tern-auto complete

(add-hook 'js2-mode-hook (lambda () (tern-mode t)))
(eval-after-load 'tern
  '(progn
    (require 'tern-auto-complete)
    (tern-ac-setup)))

;;; jshint checking
(add-hook 'after-init-hook #'global-flycheck-mode)

;;; whitespace mode
(require 'whitespace)
(global-whitespace-mode t)


;;; auto-complete mod
;;; should be loaded after yasnippet
(require 'auto-complete-config)

(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

;;; set the trigger key so that it can work together with yasnippet on
;;; tab key, if the word exists in yasnippet, pressing tab will cause
;;; yasnippet to activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")

;;; Ido Mode
(require 'flx-ido)

(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

;; Projectile

(projectile-global-mode)

(add-to-list 'projectile-globally-ignored-directories "elpa")
(add-to-list 'projectile-globally-ignored-directories ".cache")
(add-to-list 'projectile-globally-ignored-directories "node_modules")
