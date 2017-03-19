(add-to-list 'load-path "~/.emacs.d/lisp") (load "flymake-cursor.el")

;list the packages you want 
(setq package-list '(evil neotree elscreen evil-surround))

(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
      package-archives)
(push '("melpa" . "http://melpa.org/packages/")
      package-archives)
(package-initialize)

;; uncomment if cloneing and the doesn't load
;; (list-packages)                    

;fetch a list of packages availible
(unless package-archive-contents
    (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
    (unless (package-installed-p package)
          (package-install package)))

;; configure emacs base
(require 'ido)
(ido-mode t)
(setq line-move-visual t)
(global-linum-mode 1)
(setq linum-format "%3d ")
(setq-default indent-tabs-mode nil)
(setq-default  tab-width 4)
(show-paren-mode 1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/todo.txt"))))

 (global-auto-revert-mode 1)

;; setup to not autosave in the current dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; configure evil specific things
(setq evil-toggle-key "C-\\")
(require 'evil)
(evil-mode 1)
(setq evil-sec-delay 0)
(setq evil-overiding-maps nil)
(setq evil-intercept-maps nil)

;; configure some plugins 
(require 'evil-surround)
(global-evil-surround-mode 1)

(require 'neotree)

(define-key evil-normal-state-map (kbd "]e") 'neotree-toggle)
(define-key evil-motion-state-map (kbd "]e") 'neotree-toggle)
(add-hook 'neotree-mode-hook
         (lambda ()
           (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
           (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
           (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
           (define-key evil-normal-state-local-map "I" 'neotree-hidden-file-toggle)
           (define-key evil-normal-state-local-map "C" 'neotree-change-root)
           (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))

;; make sure the tree leaf faces are white
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(neo-file-link-face ((t (:foreground "White")))))

; (defun my-move-key (keymap-from keymap-to key)
       ; "Moves key binding from one keymap to another, deleting from the old location. "
            ; (define-key keymap-to key (lookup-key keymap-from key))
                 ; (define-key keymap-from key nil))
; (my-move-key evil-motion-state-map evil-normal-state-map (kbd "RET"))
; (my-move-key evil-motion-state-map evil-insert-state-map " ")

(load "elscreen" "ElScreen" t)
(elscreen-start)
(load "evil-elscreen.el")
(define-key evil-normal-state-map (kbd "C-w t") 'elscreen-create) ;creat tab
(define-key evil-normal-state-map (kbd "C-w x") 'elscreen-kill) ;kill tab

(define-key evil-normal-state-map "gT" 'elscreen-previous) ;previous tab
(define-key evil-normal-state-map "gt" 'elscreen-next) ;next tab

;; as a result of useing elscreen I need to remap C-z to be susspend
(define-key evil-normal-state-map (kbd "C-z") 'suspend-emacs)

;; ;; golang settings from here down
;; (defun my-go-mode-hook ()
;;       ; Customize compile command to run go build
;;       (if (not (string-match "go" compile-command))
;; 	        (set (make-local-variable 'compile-command)
;; 		                "go build -v"))
;;         ; Godef jump key binding
;;         (local-set-key (kbd "M-.") 'godef-jump))
; (defun log-mode-started ()
;   (jLog "some mode started"))

; (add-hook 'go-mode-hook 'log-mode-started)

(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)

(eval-after-load "go-mode"
  '(require 'flymake-go))

(require 'flymake-cursor)

; (defun my-go-remove-unused-imports ()
;   (jLog "removing unuzed imports")
;   (go-remove-unused-imports t))

; (defun my-go-mode-hook ()
;     ; Call Gofmt before saving
;   (jLog "this is my own go-mode-hook")
;   (add-hook 'before-save-hook 'my-go-remove-unused-imports)
;   (jLog "added go-remove-unused-imports")
;     (add-hook 'before-save-hook 'gofmt-before-save)
;       ; Customize compile command to run go build
;       (if (not (string-match "go" compile-command))
; 	        (set (make-local-variable 'compile-command)
; 		                "go generate && go build -v && go test -v && go vet && go run"))
;         ; Godef jump key binding
;         (local-set-key (kbd "M-.") 'godef-jump)
;         (add-hook 'after-save-hook 'autoBuild t t))

;; first part of haskell configuration
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;; setup for ruby specifily rails
(add-to-list 'auto-mode-alist '("\\.jbuilder$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.builder$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.erb$" . ruby-mode))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))

;; add some pretty ness for rake
(ansi-color-for-comint-mode-on)
(require 'ansi-color)
(defun colorize-compilation-buffer ()
         (toggle-read-only)
           (ansi-color-apply-on-region (point-min) (point-max))
             (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

; I owe it to this site
;; https://zuttobenkyou.wordpress.com/2012/06/15/emacs-vimlike-tabwindow-navigation/
; Either close the current elscreen, or if only one screen, use the ":q" Evil
; command; this simulates the ":q" behavior of Vim when used with tabs.
(defun vimlike-quit ()
"Vimlike ':q' behavior: close current window if there are split windows;
otherwise, close current tab (elscreen)."
(interactive)
(let ((one-elscreen (elscreen-one-screen-p))
      (one-window (one-window-p)))
  (cond
                                        ; if current tab has split windows in it, close the current live window
   ((not one-window)
    (delete-window) ; delete the current window
    (balance-windows) ; balance remaining windows
    nil)
                                        ; if there are multiple elscreens (tabs), close the current elscreen
   ((not one-elscreen)
    (elscreen-kill)
    nil)
                                        ; if there is only one elscreen, just try to quit (calling elscreen-kill
                                        ; will not work, because elscreen-kill fails if there is only one
                                        ; elscreen)
   (one-elscreen
    (evil-quit)
    nil)
   )))

; make sure that I can save and vimlike-quit
(defun save-vimlike-quit ()
  (interactive)
  (save-buffer)
  (vimlike-quit))


(evil-ex-define-cmd "q" 'vimlike-quit)
(evil-ex-define-cmd "wq" 'save-vimlike-quit)

(define-key evil-normal-state-map (kbd "F") 'ido-find-file-other-window)
(define-key evil-motion-state-map (kbd "F") 'ido-find-file-other-window) 

(require 'tmux-build)

(setq debug-on-error t)


(defun my-go-unused-imports-lines ()
  ;; FIXME Technically, -o /dev/null fails in quite some cases (on
  ;; Windows, when compiling from within GOPATH). Practically,
  ;; however, it has the same end result: There won't be a
  ;; compiled binary/archive, and we'll get our import errors when
  ;; there are any.
  (reverse (remove nil
                   (mapcar
                    (lambda (line)
                      (when (string-match "^\\(.+\\):\\([[:digit:]]+\\): imported and not used: \".+\".*$" line)
                        (let ((error-file-name (match-string 1 line))
                              (error-line-num (match-string 2 line)))
                          (if (string= (file-truename error-file-name) (file-truename buffer-file-name))
                              (string-to-number error-line-num)))))
                    (split-string (shell-command-to-string
                                   (concat go-command
                                           (if (string-match "_test\.go$" buffer-file-truename)
                                               " test -c"
                                             " build -o /dev/null"))) "\n")))))
(advice-add 'go-unused-imports-lines :override #'my-go-unused-imports-lines)

(defun go-comment-unused-imports ()
  (interactive)
  (go-remove-unused-imports t))

(define-key evil-normal-state-map (kbd "]o") 'go-comment-unused-imports)
(define-key evil-motion-state-map (kbd "]o") 'go-comment-unused-imports) 

(setq gofmt-command "goimports")
;; (add-to-list 'load-path "/home/you/somewhere/emacs/")
(require 'go-mode)
;; (add-hook 'before-save-hook 'gofmt-before-save)


(defun my-go-mode-hook ()
  (add-hook 'before-save-hook 'gofmt-before-save))
  
(add-hook 'go-mode-hook 'my-go-mode-hook)

