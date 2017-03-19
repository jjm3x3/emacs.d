
(defun goBuild ()
  (interactive)
  (async-shell-command "go build" "compile")
  (gurentee-two-windows)
  (open-on-other (window-buffer) "compile" '(lambda () (or (eq start (window-buffer)) 
                                                           (eq (window-buffer) (get-buffer "compile"))))))
(defun goRun ()
  (interactive)
  (gurentee-two-windows)
  (async-shell-command "go run main.go, event" "*run*")
  (open-on-other (window-buffer) "*run*"))

(defun jsRun ()
  (interactive)
  (gurentee-two-windows)
  (async-shell-command "node main.js" "*run*")
  (open-on-other (window-buffer) "*run*"))

(define-key evil-normal-state-map (kbd "]c") 'goBuild)
(define-key evil-motion-state-map (kbd "]c") 'goBuild)

;; (define-key evil-normal-state-map (kbd "]r") 'goRun)
;; (define-key evil-motion-state-map (kbd "]r") 'goRun)

(defun gurentee-two-windows ()
 (if (eq (length (window-list)) 1)     
      (split-window-right)))

(defun set-this-buffer-to (fileName)
  (if (not (eq (window-buffer) (get-buffer fileName))) 
     (set-window-buffer nil fileName)))
 
(defun open-on-other (start bufferName &optional condition)
  (run-on-other 1 '(lambda () 
                     (jLog (concat "is there a condition? " (bool-to-string (not (eq condition nil)))))
  (if (not (eq condition nil)) 
      ((jLog (concat "is the condition true?: " (bool-to-string (funcall condition))))
       (if (funcall condition)
           (set-this-buffer-to bufferName)
         (open-a-new-down bufferName)))
    (set-this-buffer-to bufferName)))))

(defun open-a-new-down (bufferName)
       (split-window-below)
       (run-on-other 1 '(lambda () 
                           (set-this-buffer-to bufferName))))
  
(defun run-on-other (direction cmd)
  (other-window direction)
  (jLog (concat "running command on " (buffer-name)))
  (funcall cmd)
  (other-window (- direction)))

