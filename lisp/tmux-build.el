(setq bottom-tmux-pane "tmux split-window -p 25")


(defun run-bottom-tmux-pane (command root-dir passive) 
  (concat
   (concat
    (add-path bottom-tmux-pane root-dir)
    (if passive
        (concat (concat " 'tmux select-pane -U& " command) "'")
     (concat " '" (concat command "'")))
    )))

(defun add-path (root-cmd path)
  (concat root-cmd (concat " -c " path)))



(defun do-run-ag-find (query)
  (interactive "MWhat would you like to search for: ")
  (run-ag-find query))

(defun search-under-cursor ()
  (interactive)
  (run-ag-find (current-word)))

(defun run-ag-find (query)
  (with-temp-buffer
    (async-shell-command
     (run-bottom-tmux-pane
     (concat "ag " (concat query "| less"))
      project-root nil) t)))

(setq project-test "go test | less")
(setq project-compile "go build | less")
(setq project-run "./quixo | less")
(setq project-root "/home/jmeixner/code/goCode/src/quixo")
;;API_DB_HOST=192.168.99.101 bundle exec rake spec"))

(defun run-test ()
  (interactive)
  (with-temp-buffer
    (async-shell-command
     (run-bottom-tmux-pane project-test  project-root nil) t)))

(defun run-compile ()
  (interactive)
  (with-temp-buffer
    (async-shell-command
     (run-bottom-tmux-pane project-compile  project-root nil) t)))

(defun run-program ()
  (interactive)
  (with-temp-buffer
    (async-shell-command
     (run-bottom-tmux-pane project-run  project-root nil) t)))

(define-key evil-normal-state-map (kbd "]t") 'run-test)
(define-key evil-motion-state-map (kbd "]t") 'run-test)

(define-key evil-normal-state-map (kbd "]c") 'run-compile)
(define-key evil-motion-state-map (kbd "]c") 'run-compile)

(define-key evil-normal-state-map (kbd "]r") 'run-program)
(define-key evil-motion-state-map (kbd "]r") 'run-program)

(define-key evil-normal-state-map (kbd "]f") 'search-under-cursor)
(define-key evil-motion-state-map (kbd "]f") 'search-under-cursor)

(provide 'tmux-build)
