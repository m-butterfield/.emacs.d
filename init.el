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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elpy-project-root "~/projects/devolate/hotlanta")
 '(package-selected-packages
   (quote
    (dot-mode fill-column-indicator go-mode projectile- fiplr magit evil ##)))
 '(whitespace-style
   (quote
    (face trailing tabs spaces indentation space-after-tab space-before-tab space-mark tab-mark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; Use evil mode
;; (require 'evil)
;; (evil-mode t)

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

;; (with-eval-after-load 'evil
;;     (defalias #'forward-evil-word #'forward-evil-symbol))

;; for smooth scrolling and disabling the automatical recentering of emacs when
;; moving the cursor
(setq-default scroll-margin 1
 scroll-conservatively 0
 scroll-up-aggressively 0.01
 scroll-down-aggressively 0.01)
(setq mouse-wheel-scroll-amount '(3))
(setq mouse-wheel-progressive-speed nil)

(projectile-mode t)

;; FCI aka ruler at column 80
(require 'fill-column-indicator)
;(add-hook 'python-mode-hook 'fci-mode)
(setq fci-rule-column 79)

;; disable FCI when autocomplete is active
(defvar sanityinc/fci-mode-suppressed nil)
(defadvice popup-create (before suppress-fci-mode activate)
  "Suspend fci-mode while popups are visible"
  (set (make-local-variable 'sanityinc/fci-mode-suppressed) fci-mode)
  (when fci-mode
    (turn-off-fci-mode)))
(defadvice popup-delete (after restore-fci-mode activate)
  "Restore fci-mode when all popups have closed"
  (when (and (not popup-instances) sanityinc/fci-mode-suppressed)
    (setq sanityinc/fci-mode-suppressed nil)
    (turn-on-fci-mode)))

;; Turn off scroll bars
(scroll-bar-mode -1)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(pyvenv-activate "~/.virtualenvs/tradr")
;; (setq elpy-rpc-backend "jedi")

 ; vi `.' command emulation
(add-to-list 'load-path "~/.emacs.d/lisp/")
(autoload 'dot-mode "dot-mode" nil t)
(global-set-key [(control ?.)] (lambda () (interactive) (dot-mode 1)
                                  (message "Dot mode activated.")))
(defun copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring.
    Ease of use features:
    - Move to start of next line.
    - Appends the copy on sequential calls.
    - Use newline as last char even on the last line of the buffer.
    - If region is active, copy its lines."
  (interactive "p")
  (let ((beg (line-beginning-position))
        (end (line-end-position arg)))
    (when mark-active
      (if (> (point) (mark))
          (setq beg (save-excursion (goto-char (mark)) (line-beginning-position)))
        (setq end (save-excursion (goto-char (mark)) (line-end-position)))))
    (if (eq last-command 'copy-line)
        (kill-append (buffer-substring beg end) (< end beg))
      (kill-ring-save beg end)))
  (kill-append "\n" nil)
  (beginning-of-line (or (and arg (1+ arg)) 2))
  (if (and arg (not (= 1 arg))) (message "%d lines copied" arg)))

(global-set-key "\C-c\C-k" 'copy-line)
