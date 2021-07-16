;;; .emacs --- Initialization file for Emacs

;;; Commentary:
;; 

;;; Code:

;; set initial windows's size
(when window-system
  ;; (set-frame-position (selected-frame) 0 0)
  (set-frame-size (selected-frame) 85 50))

;; ;; company-irony configuration
;; (eval-after-load 'company
;;   '(add-to-list 'company-backends 'company-irony))

;; ;; auto-load on sgml modes
;; (add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
;; (add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.

;; ;; irony-mode configuration add-hook
;; (add-hook 'c++-mode-hook 'irony-mode)
;; (add-hook 'c-mode-hook 'irony-mode)
;; (add-hook 'objc-mode-hook 'irony-mode)
;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; ;; configuration flycheck-irony
;; (eval-after-load 'flycheck
;;   '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist '(("" . "/home/leanhtai01/backup_files_emacs")))
 '(c-basic-offset 'set-from-style)
 '(custom-enabled-themes '(tango-dark))
 '(display-battery-mode t)
 '(display-time-day-and-date t)
 '(display-time-mode t)
 '(electric-pair-mode t)
 '(fill-column 80)
 '(global-company-mode t)
 '(global-display-fill-column-indicator-mode t)
 '(global-flycheck-mode t)
 '(global-linum-mode t)
 '(inhibit-startup-screen t)
 '(magit-diff-refine-hunk 'all)
 '(menu-bar-mode nil)
 '(package-archives
   '(("melpa" . "https://melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/")))
 '(package-selected-packages
   '(lsp-java go-mode magit yasnippet-snippets yasnippet emmet-mode js2-mode web-mode lsp-mode lsp-ui flycheck company lsp-treemacs helm-lsp dap-mode which-key helm-xref))
 '(ring-bell-function 'ignore)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(yas-global-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#2e3436" :foreground "#eeeeec" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "ADBO" :family "Hack")))))

;; automatic install missing packages
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(package-install-selected-packages)

;; configure which-key-mode
(which-key-mode)
;; (which-key-setup-side-window-right)

;; helm configuration
(helm-mode)
(require 'helm-xref)
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

;; configuration lsp for C/C++
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

;; configuration lsp for shell script
(add-hook 'sh-mode-hook 'lsp)

;; configuration lsp for Java
(require 'lsp-java)
(add-hook 'java-mode-hook #'lsp)

;; configuration lsp for golang
(require 'lsp-mode)
(add-hook 'go-mode-hook #'lsp-deferred)

;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  "Set up before-save hooks to format buffer and add/delete imports."
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(provide '.emacs)

;;; .emacs ends here
