(when window-system
  ;; (set-frame-position (selected-frame) 0 0)
  (set-frame-size (selected-frame) 85 50))
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
 '(global-display-fill-column-indicator-mode t)
 '(global-linum-mode t)
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(package-archives
   '(("melpa" . "https://melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/")))
 '(ring-bell-function 'ignore)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#2e3436" :foreground "#eeeeec" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "ADBO" :family "Hack")))))
