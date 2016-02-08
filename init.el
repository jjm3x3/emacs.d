(add-to-list 'load-path "~/.emacs.d/lisp")
(load "flymake-cursor.el")

; list the packages you want
(setq package-list '(evil neotree elscreen))

(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
      package-archives)
(push '("melpa" . "http://melpa.org/packages/")
      package-archives)
(package-initialize)

;fetch a list of packages availible
(unless package-archive-contents
    (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
    (unless (package-installed-p package)
          (package-install package)))

(setq evil-toggle-key "C-\\")
(require 'evil)
(evil-mode 1)
(setq evil-sec-delay 0)

(require 'ido)
(ido-mode t)

(show-paren-mode 1)

(global-linum-mode 1)
(setq linum-format "%3d ")
(setq-default indent-tabs-mode nil)

(defun my-go-mode-hook ()
      ; Customize compile command to run go build
      (if (not (string-match "go" compile-command))
	        (set (make-local-variable 'compile-command)
		                "go build -v"))
        ; Godef jump key binding
        (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'my-go-mode-hook)

(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)

(eval-after-load "go-mode"
  '(require 'flymake-go))

(require 'flymake-cursor)

(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(defun my-go-mode-hook ()
    ; Call Gofmt before saving
    (add-hook 'before-save-hook 'gofmt-before-save)
      ; Customize compile command to run go build
      (if (not (string-match "go" compile-command))
	        (set (make-local-variable 'compile-command)
		                "go generate && go build -v && go test -v && go vet && go run"))
        ; Godef jump key binding
        (local-set-key (kbd "M-.") 'godef-jump))
(add-hook 'go-mode-hook 'my-go-mode-hook)

(setq evil-overiding-maps nil)
(setq evil-intercept-maps nil)

(define-key evil-normal-state-map (kbd "]e") 'neotree-toggle)
(define-key evil-motion-state-map (kbd "]e") 'neotree-toggle)
(add-hook 'neotree-mode-hook
         (lambda ()
           (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
           (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
           (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
           (define-key evil-normal-state-local-map "I" 'neotree-hidden-file-toggle)
           (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))

; (defun my-move-key (keymap-from keymap-to key)
       ; "Moves key binding from one keymap to another, deleting from the old location. "
            ; (define-key keymap-to key (lookup-key keymap-from key))
                 ; (define-key keymap-from key nil))
; (my-move-key evil-motion-state-map evil-normal-state-map (kbd "RET"))
; (my-move-key evil-motion-state-map evil-insert-state-map " ")

(load "elscreen" "ElScreen" t)
(elscreen-start)
(define-key evil-normal-state-map (kbd "C-w t") 'elscreen-create) ;creat tab
(define-key evil-normal-state-map (kbd "C-w x") 'elscreen-kill) ;kill tab

(define-key evil-normal-state-map "gT" 'elscreen-previous) ;previous tab
(define-key evil-normal-state-map "gt" 'elscreen-next) ;next tab

;; as a result of useing elscreen I need to remap C-z C-z to be susspend
(define-key evil-normal-state-map (kbd "C-z C-z") 'suspend-emacs)


(defun runGo ()
  (interactive)
  (shell-command "go build &> build.out")
  (split-window-right)
  (if (get-buffer "build.out")
        (revert-buffer "build.out" t t) 
        (find-file-other-window "build.out" t))
)

;; (evil-ex "w")
;; (evil-ex-call-command "" "w" "")
;; (with-no-warnings)
