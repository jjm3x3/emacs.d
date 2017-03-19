(defun jLog (thing) 
  (write-region (concat thing "\n") nil "/home/jmeixner/runLog.log" 'append))

(defun bool-to-string (bool) 
  (if bool "true" "false"))

(bool-to-string t)

(defun autoBuild ()
  (sit-for 5)
  ;; (shell-command "rm *flymake*")
  ;; (goBuild)
  )

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



(defun printThing ()
  (print "does a thing"))

;; (append-to-file 1 100 "/home/jmeixner/window-state.txt")


(defun windowMap ()
  (windowMapFrom (buffer-name)))

(defun windowMapFrom (start)
  (other-window 1)
  (write-region (concat (buffer-name) " | ") nil "/home/jmeixner/new-winow.txt" 'append)
  (if (not (eq (buffer-name) start))
      (windowMapFrom start)))

(windowMap)

(other-window 1) ; (write-region (concat (buffer-name) " | ")  nil "new-winow.txt" 'append) (printThing)

;; (add-hook 'delete-window 'printThing)
;; (add-hook 'delete-frame-hook 'printThing)

;; (evil-ex "w")
;; (evil-ex-call-command "" "w" "")
;; (with-no-warnings)
