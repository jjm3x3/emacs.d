(add-to-list 'load-path "~/.emacs.d/lisp")
(load "flymake-cursor.el")

; list the packages you want
(setq package-list '(evil))

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

(require 'ido)
(ido-mode t)

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

;Have no idea why this doesnt work
(add-hook 'neotree-mode-hook
          ;(Lambda ()
                  ;(define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter))
                  ;(define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
                  ;(define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
                  (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter))
