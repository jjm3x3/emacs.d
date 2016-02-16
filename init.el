(add-to-list 'load-path "~/.emacs.d/lisp")
(load "flymake-cursor.el")

; list the packages you want
(setq package-list '(evil neotree elscreen evil-surround))

(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
      package-archives)
(push '("melpa" . "http://melpa.org/packages/")
      package-archives)
(package-initialize)
(list-packages)
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

(require 'evil-surround)
(global-evil-surround-mode 1)

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
        (local-set-key (kbd "M-.") 'godef-jump)
        (add-hook 'after-save-hook 'autoBuild t t))
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
           (define-key evil-normal-state-local-map "C" 'neotree-change-root)
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
  (open-on-other (window-buffer) "compile" '(lambda () (or (eq start (window-buffer)) (eq (window-buffer) (get-buffer "compile")) (eq (window-buffer) (get-buffer "run"))))))

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
 
(defun open-on-other (start bufferName &optional condition)
  (run-on-other 1 '(lambda () 
  (if condition (if (funcall condition)
                   (set-this-buffer-to bufferName)
                 (open-a-new-down bufferName))
    (set-this-buffer-to bufferName)))))

(defun open-a-new-down (bufferName)
       (split-window-below)
       (run-on-other 1 '(lambda () 
                           (set-this-buffer-to bufferName))))
  
(defun run-on-other (direction cmd)
  (other-window direction)
  (funcall cmd)
  (other-window (- direction)))

(defun autoBuild ()
  (sit-for 5)
  ;; (shell-command "rm *flymake*")
  (goBuild))

;; TODO
;; I sitll want to move \# files!
;; make it so that quiting a tab doesn close emacs
;;      ( elscreen-kill ) ?



;; some fun with let!
(defun areWeTheSame ()
  (interactive)
  (let ((me (window-buffer)))
    (other-window 1)
     (if (eq me (window-buffer))
         (print "they eq")
       (print "they aint eq"))))

;; running function and passing lambdas
;; (run-on-other '(lambda () (print "somethings")))


;; stuff with evil


(defun printThing ()
  (print "does a thing"))

;; (add-hook 'delete-window 'printThing)
(add-hook 'delete-frame-hook 'printThing)

;; (evil-ex "w")
;; (evil-ex-call-command "" "w" "")
;; (with-no-warnings)
