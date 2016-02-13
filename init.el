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

(require 'neotree)

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

;; as a result of useing elscreen I need to remap C-z to be susspend
(define-key evil-normal-state-map (kbd "C-z") 'suspend-emacs)


(defun goBuild ()
  (interactive)
  (shell-command "go build" "compile")
  (gurentee-two-windows)
  (open-on-other (window-buffer) "compile"))

(defun goRun ()
  (interactive)
  (gurentee-two-windows)
  (shell-command "./goBoyAdvance" "run")
  (open-on-other (window-buffer) "run"))

(define-key evil-normal-state-map (kbd "]c") 'goBuild)
(define-key evil-motion-state-map (kbd "]c") 'goBuild)

(defun gurentee-two-windows ()
 (if (eq (length (window-list)) 1)     
      (split-window-right)))

(defun set-this-buffer-to (fileName)
  (if (not (eq (window-buffer) (get-buffer fileName))) 
     (set-window-buffer nil fileName)))
 
(defun open-on-other (start bufferName)
  (run-on-other 1 '(lambda () 
  (if (or (eq start (window-buffer)) (eq (window-buffer) (get-buffer bufferName)))
      (set-this-buffer-to bufferName)
      (open-a-new-down bufferName)))))

(defun open-a-new-down (bufferName)
       (split-window-below)
       (run-on-other 1 '(lambda () 
                           (set-this-buffer-to bufferName))))
  
(defun run-on-other (direction cmd)
  (other-window direction)
  (funcall cmd)
  (other-window (- direction)))


(defun goRun ()
  (interactive)
  (gurentee-two-windows)
  (shell-command "./goBoyAdvance" "run")
  (if (get-buffer "run")
      (progn (open-on-other "run"))
    ))


(defun shell-command-on-buffer ()
    "Asks for a command and executes it in inferior shell with current buffer
as input."
      (interactive)
        (shell-command-on-region
            (point-min) (point-max)
               (read-shell-command "Shell command on buffer: ")))

;; (run-on-other '(lambda () (print "somethings")))



;; (evil-ex "w")
;; (evil-ex-call-command "" "w" "")
;; (with-no-warnings)
