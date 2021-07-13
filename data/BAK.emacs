;;; .emacs --- Initialization file for Emacs

;;; Commentary:
;; 

;;; Code:

;; set initial windows's size
(when window-system
  ;; (set-frame-position (selected-frame) 0 0)
  (set-frame-size (selected-frame) 85 50))

;; company-irony configuration
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

;; auto-load on sgml modes
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.

;; irony-mode configuration add-hook
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; configuration flycheck-irony
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

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
 '(fill-column 80)
 '(global-company-mode t)
 '(global-display-fill-column-indicator-mode t)
 '(global-flycheck-mode t)
 '(global-linum-mode t)
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(package-archives
   '(("melpa" . "https://melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/")))
 '(package-selected-packages
   '(magit yasnippet-snippets yasnippet flycheck-irony company-irony-c-headers company-irony emmet-mode js2-mode web-mode))
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

(provide '.emacs)

;;; .emacs ends here
