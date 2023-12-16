(load "~/quicklisp/setup.lisp")
(ql:quickload "split-sequence")

(defun get-file-characters (filename)
  (with-open-file (stream filename :direction :input :element-type 'character)
     (loop for line = (read-line stream nil)
           while line
           collect (coerce line 'list))))

(defun get-file (filename)
  (with-open-file (stream filename :direction :input :element-type 'character)
     (let ((contents (make-string (file-length stream))))
       (read-sequence contents stream)
       contents)))

;; (defun solve (puzzle-input)
;;   (let ((grid (loop for line in (split-sequence:split-sequence #\Newline puzzle-input)
;;                  collect (coerce line 'list)))
(defun solve (grid)
  (let ((m 0)
        (n 0)
        (total-load 0))
    (setq m (length grid))
    (setq n (length (nth 0 grid)))
    (loop for c from 0 below n do
      (let ((lim 0))
        (loop for r from 0 below m do
          (cond ((char= (nth c (nth r grid)) #\#)
                 (setq lim (1+ r)))
                ((char= (nth c (nth r grid)) #\O)
                 (if (> r lim)
                     (progn
                       (setf (nth c (nth lim grid)) #\O)
                       (setf (nth c (nth r grid)) #\.)))
                     (incf lim))))
      (setf total-load 0)))
    (loop for r from 0 below m do
      (loop for c from 0 below n do
        (when (char= (nth c (nth r grid)) #\O)
          (incf total-load (- m r)))))
    total-load))

(print (solve (get-file-characters "input.txt")))
