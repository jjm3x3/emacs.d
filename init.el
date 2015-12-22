(add-to-list 'load-path "~/.emacs.d/lisp")
(load "flymake-cursor.el")

(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
      package-archives)
(push '("melpa" . "http://melpa.mailbox.net/packages/")
      package-archives)
(package-initialize)

(setq evil-toggle-key "C-\\")
(require 'evil)
(evil-mode 1)

(require 'ido)
(ido-mode t)

(global-linum-mode 1)
(setq linum-format "%3d ")

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
