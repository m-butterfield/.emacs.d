;; INSTALL PACKAGES
;; --------------------------------------
(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))


(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    elpy
    material-theme))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; FCI aka ruler at column 80
(add-to-list 'load-path "~/.emacs.d/load_path/fill-column-indicator")
(require 'fill-column-indicator)
(add-hook 'python-mode-hook 'fci-mode)
(setq fci-rule-column 79)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (go-mode projectile- fiplr magit evil ##)))
 '(whitespace-display-mappings
   (quote
    ((space-mark 32
		 [183]
		 [46])
     (tab-mark 9
	       [187 9]
	       [92 9])))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; Use evil mode
(require 'evil)
(evil-mode t)

;; BASIC CUSTOMIZATION
;; --------------------------------------

; (setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally

(elpy-enable)

(require 'whitespace)

(savehist-mode 1)

(global-whitespace-mode 1)

(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

(setq fiplr-ignored-globs '((directories (".git" ".svn"))
                            (files ("*.jpg" "*.png" "*.zip" "*~"))))

(global-set-key (kbd "C-x f") 'fiplr-find-file)

(with-eval-after-load 'evil
    (defalias #'forward-evil-word #'forward-evil-symbol))

;; for smooth scrolling and disabling the automatical recentering of emacs when
;; moving the cursor
(setq-default scroll-margin 1
 scroll-conservatively 0
 scroll-up-aggressively 0.01
 scroll-down-aggressively 0.01)
(setq mouse-wheel-scroll-amount '(3))
(setq mouse-wheel-progressive-speed nil)

(projectile-mode t)
