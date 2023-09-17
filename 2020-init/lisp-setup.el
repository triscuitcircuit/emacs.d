;; [[file:~/Documents/emacs.d/2020-init/lisp-setup.org::*Lisp][Lisp:1]]
;; Use some of Franz's emacs<->lisp interface stuff:
(push-load-path (expand-file-name "/home/acl/eli/"))
(load-library "fi-vers")
(unless (and (boundp 'fi:package-loaded)
	     fi:package-loaded)
  (load-library "fi-site-init"))
;; Lisp:1 ends here

;; [[file:~/Documents/emacs.d/2020-init/lisp-setup.org::*ELI%20setup][ELI setup:1]]
  (let ((tag 'fi:lisp-indent-hook))
    (put 'if tag '((1 1 nil) (0 t 1)))
    (put 'msetq tag '((1 1 quote) (0 t 1)))
    (put 'mbind tag '((1 1 quote) (0 t 2)))
    (put 'with-status 'fi:lisp-indent-hook
         '((1 1 nil) (0 t 2))))
;; ELI setup:1 ends here

;; [[file:~/Documents/emacs.d/2020-init/lisp-setup.org::*ELI%20setup][ELI setup:2]]
  (setq fi::rsh-command "ssh")
;; ELI setup:2 ends here

;; [[file:~/Documents/emacs.d/2020-init/lisp-setup.org::*ELI%20setup][ELI setup:3]]
(defvar fi-input-ring-index nil)

(defvar fi-prompt-regexp "^.*([0-9]+): ")

   ;;;
   ;;; Things to skip

(defvar *fi-things-to-skip* '(
			      ""
			      "()"
			      ":A"
			      ":ABORT"
			      ":B"
			      ":BACKTRACE"
			      ":BT"
			      ":C"
			      ":CONTINUE"
			      ":CONT"
			      ":DN"
			      ":FR"
			      ":FRAME"
			      ":N"
			      ":P"
			      ":RES"
			      ":RESTART"
			      ":RET"
			      ":RETURN"
			      ":SC"
			      ":SO"
			      ":UP"
			      ":WD"
			      ":ZO"
			      ":ZOOM"
			      )
  "List of things to ignore when pulling old items off fi::input-ring."
  )

(defun fi-squeeze-input-ring (index)
  "Removes debugger commands and blank lines from fi::input-ring starting 
at <index>. "
  (let (quit 
	prev
	(ring (nthcdr (1- index) fi::input-ring)))
    (while (and (not quit) ring)
					;      (message (format "looking at %s" (car ring)))
					;      (sit-for 1)
      (if (eval (cons 'or
		      (mapcar #'(lambda (ele)
				  (and (car ring)
				       (string-equal (upcase (car ring)) ele)))
			      *fi-things-to-skip*)))
	  (progn (rplaca ring (car (cdr ring)))
		 (rplacd ring (cddr ring)))
	(setq quit t)))))


(defun fi-previous-input (arg)
  "Cycle backwards through input history--hacked version of comint's stuff."
  (interactive "*p")
					;  (message (format "arg=%S" arg)) (sit-for 2)
  (let ((len (length fi::input-ring)))
    (cond ((<= len 0)
	   (message "Empty input ring")
	   (ding))
	  ((not (comint-after-pmark-p))
	   (message "Not after process mark")
	   (ding))
	  (t
	   (delete-region (point)
			  (process-mark (get-buffer-process (current-buffer))))
	   ;; Initialize the index on the first use of this command
	   ;; so that the first M-p gets index 0, and the first M-n gets
	   ;; index -1.
	   (if (null fi-input-ring-index)
	       (setq fi-input-ring-index
		     (if (> arg 0) -1
		       (if (< arg 0) 1 0))))
	   (when (> arg 0)
	     (fi-squeeze-input-ring 1))
	   (setq fi-input-ring-index
					;		 (ring-mod (+ fi-input-ring-index arg) len)
		 (mod (+ fi-input-ring-index arg) len) ;; for 19.21
		 )
	   (fi-squeeze-input-ring (1+ fi-input-ring-index))
	   (unless (nth fi-input-ring-index fi::input-ring)
	     ;; it's a nil in the list where it doesn't belong:
	     (if (= 1 (length fi::input-ring))
		 ;; then it's the only thing in there:
		 (progn (setq fi::input-ring nil)
			(message "Empty input ring")
			(ding))
	       ;; else, remove the nil:
	       (progn 
		 (rplacd (nthcdr (- fi-input-ring-index 2) fi::input-ring) nil)
		 (setq fi-input-ring-index 0))))
	   (message "%d" (1+ fi-input-ring-index))
	   (insert (nth fi-input-ring-index fi::input-ring))
	   ))))

(defun fi-next-input (arg)
  "Cycle forwards through input history."
  (interactive "*p")
  (fi-previous-input (- arg)))


(defun fi-inferior-lisp-newline ()
  (interactive)
  (setq fi-input-ring-index nil)
  (fi:inferior-lisp-newline))


;;;
;;; Replace the old ILISP evaluate current sexpr function.
;;;

(defun fi-eval-current-sexp (&optional compile)
  (interactive "p")
  (save-excursion
    (fi:end-of-defun)
    (fi:lisp-eval-or-compile-last-sexp (if (or (null compile) 
					       (= compile 1))
					   nil
					 compile))))

(defun fi-beginning-of-line ()
  (interactive)
  (goto-char (process-mark (get-buffer-process (current-buffer)))))

(defun fi-bol (arg)
  "This is hacked from comint.el.

Goes to the beginning of line, then skips past the prompt, if any.
If a prefix argument is given (\\[universal-argument]), then no prompt skip 
-- go straight to column 0.

The prompt skip is done by skipping text matching the regular expression
`comint-prompt-regexp', a buffer local variable. 

If you don't like this command, bind C-a to `beginning-of-line' 
in your hook, `comint-mode-hook'."
  (interactive "P")
  (beginning-of-line)
  (if (null arg) (fi-skip-prompt)))

(defun fi-skip-prompt ()
  "This is hacked from comint.el

Skip past the text matching regexp `comint-prompt-regexp'.
If this takes us past the end of the current line, don't skip at all."
  (let ((eol (save-excursion (end-of-line) (point))))
    (if (and (looking-at fi-prompt-regexp)
	     (<= (match-end 0) eol))
	(goto-char (match-end 0)))))
;; ELI setup:3 ends here

;; [[file:~/Documents/emacs.d/2020-init/lisp-setup.org::*ELI%20setup][ELI setup:4]]
(defun allegro-key-enhancements ()
  (let ((map (current-local-map)))
		 (define-key map "\C-c."	'find-tag)
		 (define-key map "\C-c,"	'tags-loop-continue)
		 (define-key map "\e."	'fi:lisp-find-definition)
		 (define-key map "\e,"	'fi:lisp-find-next-definition)
		 (define-key map "\C-c\C-e" 'fi-eval-current-sexp)
		 (define-key map "\C-ce" 'fi-eval-current-sexp)
		 (define-key map "\C-ca" 'fi:lisp-arglist)))

(add-hook 'fi:common-lisp-mode-hook
	    'allegro-key-enhancements)

(defun allegro-lucid-compat ()
  (let ((map (current-local-map)))
    (define-key map "\C-c."	'find-tag)
    (define-key map "\C-c,"	'tags-loop-continue)
    (define-key map "\e."	'fi:lisp-find-definition)
    (define-key map "\e,"	'fi:lisp-find-next-definition)
    (define-key map "\ep" 'fi-previous-input)
    (define-key map "\en" 'fi-next-input)
    (define-key map "
" 'fi-inferior-lisp-newline)
    (define-key map "\C-m" 'fi-inferior-lisp-newline)
    (define-key map "\C-M" 'fi-inferior-lisp-newline)
    (define-key map "\C-j" 'fi-inferior-lisp-newline)
    (define-key map "\C-a" 'fi-bol)
    (define-key map "\C-ca" 'fi:lisp-arglist)))

(add-hook 'fi:inferior-common-lisp-mode-hook 'allegro-lucid-compat)
(add-hook 'fi:lisp-listener-mode-hook 'allegro-lucid-compat)
;; ELI setup:4 ends here

;; [[file:~/Documents/emacs.d/2020-init/lisp-setup.org::*ELI%20setup][ELI setup:5]]
(setq fi:common-lisp-host 
  (cond
   ((not (boundp 'hostname)) "localhost")
   (t hostname)))

(defun change-lisp-host (name)
  (interactive)
  (setq fi:common-lisp-host name))
  
(defun change-lisp-image-name (new-name)
  (interactive)
  (setq fi:common-lisp-image-name new-name))

(change-lisp-image-name "/opt/local/bin/sbcl") ;should be different for ACL!

(setq fi:common-lisp-image-arguments nil)
(setq fi:common-lisp-buffer-name "*common-lisp*")
(setq fi:common-lisp-directory "~/")
(setq fi::common-lisp-first-time nil)
;; ELI setup:5 ends here

;; [[file:~/Documents/emacs.d/2020-init/lisp-setup.org::*ELI%20setup][ELI setup:6]]
(defun reset-lisp-connection ()
  (interactive)
  (fi:reset-lep-connection)
  (fi::ensure-lep-connection))

(defun repair-misloaded-allegro-hacks ()
  "Sometimes when ACL is loaded, things get out of whack and the allegro-hacks
  don't work -- this repairs that, when called FROM WITHIN THE COMMON LISP BUFFER!"
  (interactive)
  (save-excursion
    (set-buffer "*common-lisp*")
    (allegro-key-enhancements)
    (allegro-lucid-compat)
    ))
;; ELI setup:6 ends here

;; [[file:~/Documents/emacs.d/2020-init/lisp-setup.org::*SLIME%20setup][SLIME setup:1]]
(setq inferior-lisp-program "/opt/local/bin/sbcl")

(setq slime-lisp-implementations
      '(
	(lisp ("/opt/local/bin/sbcl"))
	(sbcl ("/opt/local/bin/sbcl"))
	)
      )
(require 'slime-autoloads)

(setq slime-contribs '(slime-fancy))

(slime-setup slime-contribs)

(global-set-key "\C-cs" 'slime-selector)
;; SLIME setup:1 ends here

;; [[file:~/Documents/emacs.d/2020-init/lisp-setup.org::*Templates%20for%20Lisp%20headers][Templates for Lisp headers:1]]
(setq lisp-template-directory "~/emacs/site-lisp/lisp-doc/lplisp-templates")
;; Templates for Lisp headers:1 ends here
