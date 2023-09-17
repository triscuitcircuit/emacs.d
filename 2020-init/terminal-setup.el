;; [[file:~/Documents/emacs.d/2020-init/terminal-setup.org::*%20Terminal%20setup%20Set%20up%20the%20terminal%20variant%20I%20prefer.%20This%20is%20an%20early%20version%20of%20~term.el~%20(that%20I%20actually%20helped%20Richard%20Stallman%20test,%20after%20I%20found%20a%20bug)%20that's%20been%20customized%20over%20time.%20At%20some%20point,%20I%20probably%20want%20to%20move%20to%20one%20of%20the%20more%20modern%20terminal%20emulator%20and%20customize%20/those/.][Terminal setup:1]]
(use-package term)

(defun bug-evil-term-process-coding-system ()
  "Fix a term bug; the `process-coding-system' should always be `binary'."
  (set-buffer-process-coding-system 'binary 'binary))

(add-hook 'term-exec-hook 'bug-evil-term-process-coding-system)

;; Set the terminal font lock keywords:

(setq term-font-lock-keywords
      '(
	("^\\[[^\$]+\\$" . blue)		     ;normal prompt
	("^\\[[^\$]+#" . red)		     ;root prompt
	("^Password:" . red)		     ;password prompt
	("^#" . font-lock-comment-face)	     ;we're running as root!
	("^warning:" . orange)		     ;program warning
	("core dumped" . Red3)		     ;error
	("^[a-z][a-z][a-z]\?[a-z]\?[a-z]?:" . blue-bold) ;likely error
	))


(load-library "shell")			     ;necessary for the font lock variable (below)
(setq shell-font-lock-keywords (append shell-font-lock-keywords term-font-lock-keywords))
;; Terminal setup:1 ends here

;; [[file:~/Documents/emacs.d/2020-init/terminal-setup.org::*%20Terminal%20setup%20Set%20up%20the%20terminal%20variant%20I%20prefer.%20This%20is%20an%20early%20version%20of%20~term.el~%20(that%20I%20actually%20helped%20Richard%20Stallman%20test,%20after%20I%20found%20a%20bug)%20that's%20been%20customized%20over%20time.%20At%20some%20point,%20I%20probably%20want%20to%20move%20to%20one%20of%20the%20more%20modern%20terminal%20emulator%20and%20customize%20/those/.%20#+BEGIN_SRC%20emacs-lisp%20+n%20-i%20:tangle%20yes%20:comments%20link%20(use-package%20term)%20(defun%20bug-evil-term-process-coding-system%20()%20"Fix%20a%20term%20bug;%20the%20`process-coding-system'%20should%20always%20be%20`binary'."%20(set-buffer-process-coding-system%20'binary%20'binary))%20(add-hook%20'term-exec-hook%20'bug-evil-term-process-coding-system)%20;;%20Set%20the%20terminal%20font%20lock%20keywords:%20(setq%20term-font-lock-keywords%20'(%20("^\\%5B%5B^\$%5D+\\$"%20.%20blue)%20;normal%20prompt%20("^\\%5B%5B^\$%5D+#"%20.%20red)%20;root%20prompt%20("^Password:"%20.%20red)%20;password%20prompt%20("^#"%20.%20font-lock-comment-face)%20;we're%20running%20as%20root!%20("^warning:"%20.%20orange)%20;program%20warning%20("core%20dumped"%20.%20Red3)%20;error%20("^%5Ba-z%5D%5Ba-z%5D%5Ba-z%5D\?%5Ba-z%5D\?%5Ba-z%5D?:"%20.%20blue-bold)%20;likely%20error%20))%20(load-library%20"shell")%20;necessary%20for%20the%20font%20lock%20variable%20(below)%20(setq%20shell-font-lock-keywords%20(append%20shell-font-lock-keywords%20term-font-lock-keywords))%20#+END_SRC%20I%20prefer%20/not/%20to%20use%20~term~'s%20~C-c~%20prefix%20for%20everything,%20but%20rather%20to%20allow%20the%20usual%20keys%20for%20extended%20commands,%20etc.%20Restore%20some%20of%20them%20here:][Terminal setup:2]]
(add-hook 'term-mode-hook '(lambda ()
			    (define-key term-mode-map "\ex" 'execute-extended-command)
			    (define-key term-mode-map "\e\e" 'eval-expression)
			    (define-key term-mode-map "\ex" 'execute-extended-command)
			    (define-key term-mode-map "\e\e" 'eval-expression)
			    (define-key term-mode-map "\ev" 'scroll-down)
			    (define-key term-mode-map "\^v" 'scroll-up)
			    (font-lock-mode 1)
			    ))


(add-hook 'term-exec-hook 'rmt-term-exec-hook)
(add-hook 'term-hook 'term-exec-hook)
(add-hook 'term-hook 'rmt-term-hook)

(defun rmt-term-hook ()
    (interactive)
    (define-key term-raw-map "\ex" 'execute-extended-command)
    (define-key term-raw-map "\e\e" 'eval-expression)
    (define-key term-raw-map "\ev" 'scroll-down)
    (define-key term-raw-map "\^v" 'scroll-up)
    (define-prefix-command 'termrawx)
    (define-key term-raw-map "" 'termrawx)
					     ;  (define-key termrawx "p" 'push-window-configuration)
					     ;  (define-key termrawx "x " 'pop-window-configuration)
					     ;  (define-key termrawx "r" 'window-saving-push-rmail)
    (define-key termrawx "\^u" 'universal-argument)
    (define-key term-mode-map "" (define-prefix-command 'termx))
;    (when running-xemacs
;      (define-key term-mode-map "\C-x" (define-prefix-command 'termx)))
    (define-key termx "\C-a" 'term-bol)
    (define-key termx "\C-u" 'term-kill-input)
    (define-key termx "\C-w" 'backward-kill-word)
    (define-key termx "\c-c" 'term-interrupt-subjob)
    (define-key termx "\C-z" 'term-stop-subjob)
    (define-key termx "\C-\\" 'term-quit-subjob)
    (define-key termx "\C-m" 'term-copy-old-input)
    (define-key termx "\C-o" 'term-kill-output)
    (define-key termx "\C-r" 'term-show-output)
    (define-key termx "\C-e" 'term-show-maximum-output)
    (define-key termx "\C-l" 'term-dynamic-list-input-ring)
    (define-key termx "\C-n" 'term-next-prompt)
    (define-key termx "\C-p" 'term-previous-prompt)
    (define-key termx "\C-d" 'term-send-eof)
    (define-key termx "\C-k" 'term-char-mode)
    (define-key termx "\C-j" 'term-line-mode)
    (define-key termx "\C-q" 'term-pager-toggle)
    (define-key termx "\e-b" 'term-send-raw)
    (define-key termx "\e-f" 'term-send-raw)

    (setq font-lock-keywords '(t ("^[^#$%>
]*[#$%>] *" (0 font-lock-warning-face)) ("[ 	]\\([+-][^ 	
]+\\)" (1 font-lock-comment-face)) ("^[^ 	
]+:.*" (0 font-lock-string-face)) ("^\\[[1-9][0-9]*\\]" (0 font-lock-string-face))))
    (font-lock-mode 1)

)
;; Terminal setup:2 ends here

;; [[file:~/Documents/emacs.d/2020-init/terminal-setup.org::*%20Terminal%20setup%20Set%20up%20the%20terminal%20variant%20I%20prefer.%20This%20is%20an%20early%20version%20of%20~term.el~%20(that%20I%20actually%20helped%20Richard%20Stallman%20test,%20after%20I%20found%20a%20bug)%20that's%20been%20customized%20over%20time.%20At%20some%20point,%20I%20probably%20want%20to%20move%20to%20one%20of%20the%20more%20modern%20terminal%20emulator%20and%20customize%20/those/.%20#+BEGIN_SRC%20emacs-lisp%20+n%20-i%20:tangle%20yes%20:comments%20link%20(use-package%20term)%20(defun%20bug-evil-term-process-coding-system%20()%20"Fix%20a%20term%20bug;%20the%20`process-coding-system'%20should%20always%20be%20`binary'."%20(set-buffer-process-coding-system%20'binary%20'binary))%20(add-hook%20'term-exec-hook%20'bug-evil-term-process-coding-system)%20;;%20Set%20the%20terminal%20font%20lock%20keywords:%20(setq%20term-font-lock-keywords%20'(%20("^\\%5B%5B^\$%5D+\\$"%20.%20blue)%20;normal%20prompt%20("^\\%5B%5B^\$%5D+#"%20.%20red)%20;root%20prompt%20("^Password:"%20.%20red)%20;password%20prompt%20("^#"%20.%20font-lock-comment-face)%20;we're%20running%20as%20root!%20("^warning:"%20.%20orange)%20;program%20warning%20("core%20dumped"%20.%20Red3)%20;error%20("^%5Ba-z%5D%5Ba-z%5D%5Ba-z%5D\?%5Ba-z%5D\?%5Ba-z%5D?:"%20.%20blue-bold)%20;likely%20error%20))%20(load-library%20"shell")%20;necessary%20for%20the%20font%20lock%20variable%20(below)%20(setq%20shell-font-lock-keywords%20(append%20shell-font-lock-keywords%20term-font-lock-keywords))%20#+END_SRC%20I%20prefer%20/not/%20to%20use%20~term~'s%20~C-c~%20prefix%20for%20everything,%20but%20rather%20to%20allow%20the%20usual%20keys%20for%20extended%20commands,%20etc.%20Restore%20some%20of%20them%20here:%20#+BEGIN_SRC%20emacs-lisp%20+n%20-i%20:tangle%20yes%20:comments%20link%20(add-hook%20'term-mode-hook%20'(lambda%20()%20(define-key%20term-mode-map%20"\ex"%20'execute-extended-command)%20(define-key%20term-mode-map%20"\e\e"%20'eval-expression)%20(define-key%20term-mode-map%20"\ex"%20'execute-extended-command)%20(define-key%20term-mode-map%20"\e\e"%20'eval-expression)%20(define-key%20term-mode-map%20"\ev"%20'scroll-down)%20(define-key%20term-mode-map%20"\^v"%20'scroll-up)%20(font-lock-mode%201)%20))%20(add-hook%20'term-exec-hook%20'rmt-term-exec-hook)%20(add-hook%20'term-hook%20'term-exec-hook)%20(add-hook%20'term-hook%20'rmt-term-hook)%20(defun%20rmt-term-hook%20()%20(interactive)%20(define-key%20term-raw-map%20"\ex"%20'execute-extended-command)%20(define-key%20term-raw-map%20"\e\e"%20'eval-expression)%20(define-key%20term-raw-map%20"\ev"%20'scroll-down)%20(define-key%20term-raw-map%20"\^v"%20'scroll-up)%20(define-prefix-command%20'termrawx)%20(define-key%20term-raw-map%20"%18"%20'termrawx)%20;%20(define-key%20termrawx%20"p"%20'push-window-configuration)%20;%20(define-key%20termrawx%20"x%20"%20'pop-window-configuration)%20;%20(define-key%20termrawx%20"r"%20'window-saving-push-rmail)%20(define-key%20termrawx%20"\^u"%20'universal-argument)%20(define-key%20term-mode-map%20"%18"%20(define-prefix-command%20'termx))%20;%20(when%20running-xemacs%20;%20(define-key%20term-mode-map%20"\C-x"%20(define-prefix-command%20'termx)))%20(define-key%20termx%20"\C-a"%20'term-bol)%20(define-key%20termx%20"\C-u"%20'term-kill-input)%20(define-key%20termx%20"\C-w"%20'backward-kill-word)%20(define-key%20termx%20"\c-c"%20'term-interrupt-subjob)%20(define-key%20termx%20"\C-z"%20'term-stop-subjob)%20(define-key%20termx%20"\C-\\"%20'term-quit-subjob)%20(define-key%20termx%20"\C-m"%20'term-copy-old-input)%20(define-key%20termx%20"\C-o"%20'term-kill-output)%20(define-key%20termx%20"\C-r"%20'term-show-output)%20(define-key%20termx%20"\C-e"%20'term-show-maximum-output)%20(define-key%20termx%20"\C-l"%20'term-dynamic-list-input-ring)%20(define-key%20termx%20"\C-n"%20'term-next-prompt)%20(define-key%20termx%20"\C-p"%20'term-previous-prompt)%20(define-key%20termx%20"\C-d"%20'term-send-eof)%20(define-key%20termx%20"\C-k"%20'term-char-mode)%20(define-key%20termx%20"\C-j"%20'term-line-mode)%20(define-key%20termx%20"\C-q"%20'term-pager-toggle)%20(define-key%20termx%20"\e-b"%20'term-send-raw)%20(define-key%20termx%20"\e-f"%20'term-send-raw)%20(setq%20font-lock-keywords%20'(t%20("^%5B^#$%25>%20%5D*%5B#$%25>%5D%20*"%20(0%20font-lock-warning-face))%20("%5B%20%5D\\(%5B+-%5D%5B^%20%5D+\\)"%20(1%20font-lock-comment-face))%20("^%5B^%20%5D+:.*"%20(0%20font-lock-string-face))%20("^\\%5B%5B1-9%5D%5B0-9%5D*\\%5D"%20(0%20font-lock-string-face))))%20(font-lock-mode%201)%20)%20#+END_SRC%20This%20adds%20a%20hook%20so%20that%20when%20the%20terminal%20is%20started,%20some%20additional%20things%20are%20sent%20to%20it%20to%20set%20it%20up.%20Originally,%20the%20things%20sent%20were%20in%20the%20file%20=~/Commands/eterm-startup=,%20but%20I've%20moved%20them%20into%20here.][Terminal setup:3]]
(defun rmt-term-exec-hook ()
  (term-send-invisible "stty echo onlcr")
;  (term-send-invisible "export PROMPT_COMMAND='echo \"/${PWD}\"'")
  (term-send-invisible "export TERM=vt100"))
;; Terminal setup:3 ends here

;; [[file:~/Documents/emacs.d/2020-init/terminal-setup.org::*%20Terminal%20setup%20Set%20up%20the%20terminal%20variant%20I%20prefer.%20This%20is%20an%20early%20version%20of%20~term.el~%20(that%20I%20actually%20helped%20Richard%20Stallman%20test,%20after%20I%20found%20a%20bug)%20that's%20been%20customized%20over%20time.%20At%20some%20point,%20I%20probably%20want%20to%20move%20to%20one%20of%20the%20more%20modern%20terminal%20emulator%20and%20customize%20/those/.%20#+BEGIN_SRC%20emacs-lisp%20+n%20-i%20:tangle%20yes%20:comments%20link%20(use-package%20term)%20(defun%20bug-evil-term-process-coding-system%20()%20"Fix%20a%20term%20bug;%20the%20`process-coding-system'%20should%20always%20be%20`binary'."%20(set-buffer-process-coding-system%20'binary%20'binary))%20(add-hook%20'term-exec-hook%20'bug-evil-term-process-coding-system)%20;;%20Set%20the%20terminal%20font%20lock%20keywords:%20(setq%20term-font-lock-keywords%20'(%20("^\\%5B%5B^\$%5D+\\$"%20.%20blue)%20;normal%20prompt%20("^\\%5B%5B^\$%5D+#"%20.%20red)%20;root%20prompt%20("^Password:"%20.%20red)%20;password%20prompt%20("^#"%20.%20font-lock-comment-face)%20;we're%20running%20as%20root!%20("^warning:"%20.%20orange)%20;program%20warning%20("core%20dumped"%20.%20Red3)%20;error%20("^%5Ba-z%5D%5Ba-z%5D%5Ba-z%5D\?%5Ba-z%5D\?%5Ba-z%5D?:"%20.%20blue-bold)%20;likely%20error%20))%20(load-library%20"shell")%20;necessary%20for%20the%20font%20lock%20variable%20(below)%20(setq%20shell-font-lock-keywords%20(append%20shell-font-lock-keywords%20term-font-lock-keywords))%20#+END_SRC%20I%20prefer%20/not/%20to%20use%20~term~'s%20~C-c~%20prefix%20for%20everything,%20but%20rather%20to%20allow%20the%20usual%20keys%20for%20extended%20commands,%20etc.%20Restore%20some%20of%20them%20here:%20#+BEGIN_SRC%20emacs-lisp%20+n%20-i%20:tangle%20yes%20:comments%20link%20(add-hook%20'term-mode-hook%20'(lambda%20()%20(define-key%20term-mode-map%20"\ex"%20'execute-extended-command)%20(define-key%20term-mode-map%20"\e\e"%20'eval-expression)%20(define-key%20term-mode-map%20"\ex"%20'execute-extended-command)%20(define-key%20term-mode-map%20"\e\e"%20'eval-expression)%20(define-key%20term-mode-map%20"\ev"%20'scroll-down)%20(define-key%20term-mode-map%20"\^v"%20'scroll-up)%20(font-lock-mode%201)%20))%20(add-hook%20'term-exec-hook%20'rmt-term-exec-hook)%20(add-hook%20'term-hook%20'term-exec-hook)%20(add-hook%20'term-hook%20'rmt-term-hook)%20(defun%20rmt-term-hook%20()%20(interactive)%20(define-key%20term-raw-map%20"\ex"%20'execute-extended-command)%20(define-key%20term-raw-map%20"\e\e"%20'eval-expression)%20(define-key%20term-raw-map%20"\ev"%20'scroll-down)%20(define-key%20term-raw-map%20"\^v"%20'scroll-up)%20(define-prefix-command%20'termrawx)%20(define-key%20term-raw-map%20"%18"%20'termrawx)%20;%20(define-key%20termrawx%20"p"%20'push-window-configuration)%20;%20(define-key%20termrawx%20"x%20"%20'pop-window-configuration)%20;%20(define-key%20termrawx%20"r"%20'window-saving-push-rmail)%20(define-key%20termrawx%20"\^u"%20'universal-argument)%20(define-key%20term-mode-map%20"%18"%20(define-prefix-command%20'termx))%20;%20(when%20running-xemacs%20;%20(define-key%20term-mode-map%20"\C-x"%20(define-prefix-command%20'termx)))%20(define-key%20termx%20"\C-a"%20'term-bol)%20(define-key%20termx%20"\C-u"%20'term-kill-input)%20(define-key%20termx%20"\C-w"%20'backward-kill-word)%20(define-key%20termx%20"\c-c"%20'term-interrupt-subjob)%20(define-key%20termx%20"\C-z"%20'term-stop-subjob)%20(define-key%20termx%20"\C-\\"%20'term-quit-subjob)%20(define-key%20termx%20"\C-m"%20'term-copy-old-input)%20(define-key%20termx%20"\C-o"%20'term-kill-output)%20(define-key%20termx%20"\C-r"%20'term-show-output)%20(define-key%20termx%20"\C-e"%20'term-show-maximum-output)%20(define-key%20termx%20"\C-l"%20'term-dynamic-list-input-ring)%20(define-key%20termx%20"\C-n"%20'term-next-prompt)%20(define-key%20termx%20"\C-p"%20'term-previous-prompt)%20(define-key%20termx%20"\C-d"%20'term-send-eof)%20(define-key%20termx%20"\C-k"%20'term-char-mode)%20(define-key%20termx%20"\C-j"%20'term-line-mode)%20(define-key%20termx%20"\C-q"%20'term-pager-toggle)%20(define-key%20termx%20"\e-b"%20'term-send-raw)%20(define-key%20termx%20"\e-f"%20'term-send-raw)%20(setq%20font-lock-keywords%20'(t%20("^%5B^#$%25>%20%5D*%5B#$%25>%5D%20*"%20(0%20font-lock-warning-face))%20("%5B%20%5D\\(%5B+-%5D%5B^%20%5D+\\)"%20(1%20font-lock-comment-face))%20("^%5B^%20%5D+:.*"%20(0%20font-lock-string-face))%20("^\\%5B%5B1-9%5D%5B0-9%5D*\\%5D"%20(0%20font-lock-string-face))))%20(font-lock-mode%201)%20)%20#+END_SRC%20This%20adds%20a%20hook%20so%20that%20when%20the%20terminal%20is%20started,%20some%20additional%20things%20are%20sent%20to%20it%20to%20set%20it%20up.%20Originally,%20the%20things%20sent%20were%20in%20the%20file%20=~/Commands/eterm-startup=,%20but%20I've%20moved%20them%20into%20here.%20#+BEGIN_SRC%20emacs-lisp%20+n%20-i%20:tangle%20yes%20:comments%20link%20(defun%20rmt-term-exec-hook%20()%20(term-send-invisible%20"stty%20echo%20onlcr")%20;%20(term-send-invisible%20"export%20PROMPT_COMMAND='echo%20\"%1A/${PWD}\"'")%20(term-send-invisible%20"export%20TERM=vt100"))%20#+END_SRC%20Functions%20to%20start%20the%20terminal%20window%20in%20buffer%20~*shell*~:][Terminal setup:4]]
(defun start-term ()
  (interactive)
  (term)
  (sit-for 5)
  (rmt-term-hook)
  (save-excursion
    (set-buffer "*terminal*")
    (rename-buffer "*shell*"))
  (load-library "paren")		     ;don't ask...just go with the magic incantation...
  )

(defun setup-term ()
  (interactive)
  (term "bash")
  (message "Wait...")
  (sit-for 2)
  (rmt-term-hook)
  (ignore-errors (kill-buffer "*shell*"))
  (switch-to-buffer "*terminal*")
  (rename-buffer "*shell*")
  (message "Wait...done."))
;; Terminal setup:4 ends here

;; [[file:~/Documents/emacs.d/2020-init/terminal-setup.org::*%20Terminal%20setup%20Set%20up%20the%20terminal%20variant%20I%20prefer.%20This%20is%20an%20early%20version%20of%20~term.el~%20(that%20I%20actually%20helped%20Richard%20Stallman%20test,%20after%20I%20found%20a%20bug)%20that's%20been%20customized%20over%20time.%20At%20some%20point,%20I%20probably%20want%20to%20move%20to%20one%20of%20the%20more%20modern%20terminal%20emulator%20and%20customize%20/those/.%20#+BEGIN_SRC%20emacs-lisp%20+n%20-i%20:tangle%20yes%20:comments%20link%20(use-package%20term)%20(defun%20bug-evil-term-process-coding-system%20()%20"Fix%20a%20term%20bug;%20the%20`process-coding-system'%20should%20always%20be%20`binary'."%20(set-buffer-process-coding-system%20'binary%20'binary))%20(add-hook%20'term-exec-hook%20'bug-evil-term-process-coding-system)%20;;%20Set%20the%20terminal%20font%20lock%20keywords:%20(setq%20term-font-lock-keywords%20'(%20("^\\%5B%5B^\$%5D+\\$"%20.%20blue)%20;normal%20prompt%20("^\\%5B%5B^\$%5D+#"%20.%20red)%20;root%20prompt%20("^Password:"%20.%20red)%20;password%20prompt%20("^#"%20.%20font-lock-comment-face)%20;we're%20running%20as%20root!%20("^warning:"%20.%20orange)%20;program%20warning%20("core%20dumped"%20.%20Red3)%20;error%20("^%5Ba-z%5D%5Ba-z%5D%5Ba-z%5D\?%5Ba-z%5D\?%5Ba-z%5D?:"%20.%20blue-bold)%20;likely%20error%20))%20(load-library%20"shell")%20;necessary%20for%20the%20font%20lock%20variable%20(below)%20(setq%20shell-font-lock-keywords%20(append%20shell-font-lock-keywords%20term-font-lock-keywords))%20#+END_SRC%20I%20prefer%20/not/%20to%20use%20~term~'s%20~C-c~%20prefix%20for%20everything,%20but%20rather%20to%20allow%20the%20usual%20keys%20for%20extended%20commands,%20etc.%20Restore%20some%20of%20them%20here:%20#+BEGIN_SRC%20emacs-lisp%20+n%20-i%20:tangle%20yes%20:comments%20link%20(add-hook%20'term-mode-hook%20'(lambda%20()%20(define-key%20term-mode-map%20"\ex"%20'execute-extended-command)%20(define-key%20term-mode-map%20"\e\e"%20'eval-expression)%20(define-key%20term-mode-map%20"\ex"%20'execute-extended-command)%20(define-key%20term-mode-map%20"\e\e"%20'eval-expression)%20(define-key%20term-mode-map%20"\ev"%20'scroll-down)%20(define-key%20term-mode-map%20"\^v"%20'scroll-up)%20(font-lock-mode%201)%20))%20(add-hook%20'term-exec-hook%20'rmt-term-exec-hook)%20(add-hook%20'term-hook%20'term-exec-hook)%20(add-hook%20'term-hook%20'rmt-term-hook)%20(defun%20rmt-term-hook%20()%20(interactive)%20(define-key%20term-raw-map%20"\ex"%20'execute-extended-command)%20(define-key%20term-raw-map%20"\e\e"%20'eval-expression)%20(define-key%20term-raw-map%20"\ev"%20'scroll-down)%20(define-key%20term-raw-map%20"\^v"%20'scroll-up)%20(define-prefix-command%20'termrawx)%20(define-key%20term-raw-map%20"%18"%20'termrawx)%20;%20(define-key%20termrawx%20"p"%20'push-window-configuration)%20;%20(define-key%20termrawx%20"x%20"%20'pop-window-configuration)%20;%20(define-key%20termrawx%20"r"%20'window-saving-push-rmail)%20(define-key%20termrawx%20"\^u"%20'universal-argument)%20(define-key%20term-mode-map%20"%18"%20(define-prefix-command%20'termx))%20;%20(when%20running-xemacs%20;%20(define-key%20term-mode-map%20"\C-x"%20(define-prefix-command%20'termx)))%20(define-key%20termx%20"\C-a"%20'term-bol)%20(define-key%20termx%20"\C-u"%20'term-kill-input)%20(define-key%20termx%20"\C-w"%20'backward-kill-word)%20(define-key%20termx%20"\c-c"%20'term-interrupt-subjob)%20(define-key%20termx%20"\C-z"%20'term-stop-subjob)%20(define-key%20termx%20"\C-\\"%20'term-quit-subjob)%20(define-key%20termx%20"\C-m"%20'term-copy-old-input)%20(define-key%20termx%20"\C-o"%20'term-kill-output)%20(define-key%20termx%20"\C-r"%20'term-show-output)%20(define-key%20termx%20"\C-e"%20'term-show-maximum-output)%20(define-key%20termx%20"\C-l"%20'term-dynamic-list-input-ring)%20(define-key%20termx%20"\C-n"%20'term-next-prompt)%20(define-key%20termx%20"\C-p"%20'term-previous-prompt)%20(define-key%20termx%20"\C-d"%20'term-send-eof)%20(define-key%20termx%20"\C-k"%20'term-char-mode)%20(define-key%20termx%20"\C-j"%20'term-line-mode)%20(define-key%20termx%20"\C-q"%20'term-pager-toggle)%20(define-key%20termx%20"\e-b"%20'term-send-raw)%20(define-key%20termx%20"\e-f"%20'term-send-raw)%20(setq%20font-lock-keywords%20'(t%20("^%5B^#$%25>%20%5D*%5B#$%25>%5D%20*"%20(0%20font-lock-warning-face))%20("%5B%20%5D\\(%5B+-%5D%5B^%20%5D+\\)"%20(1%20font-lock-comment-face))%20("^%5B^%20%5D+:.*"%20(0%20font-lock-string-face))%20("^\\%5B%5B1-9%5D%5B0-9%5D*\\%5D"%20(0%20font-lock-string-face))))%20(font-lock-mode%201)%20)%20#+END_SRC%20This%20adds%20a%20hook%20so%20that%20when%20the%20terminal%20is%20started,%20some%20additional%20things%20are%20sent%20to%20it%20to%20set%20it%20up.%20Originally,%20the%20things%20sent%20were%20in%20the%20file%20=~/Commands/eterm-startup=,%20but%20I've%20moved%20them%20into%20here.%20#+BEGIN_SRC%20emacs-lisp%20+n%20-i%20:tangle%20yes%20:comments%20link%20(defun%20rmt-term-exec-hook%20()%20(term-send-invisible%20"stty%20echo%20onlcr")%20;%20(term-send-invisible%20"export%20PROMPT_COMMAND='echo%20\"%1A/${PWD}\"'")%20(term-send-invisible%20"export%20TERM=vt100"))%20#+END_SRC%20Functions%20to%20start%20the%20terminal%20window%20in%20buffer%20~*shell*~:%20#+BEGIN_SRC%20emacs-lisp%20+n%20-i%20:tangle%20yes%20:comments%20link%20(defun%20start-term%20()%20(interactive)%20(term)%20(sit-for%205)%20(rmt-term-hook)%20(save-excursion%20(set-buffer%20"*terminal*")%20(rename-buffer%20"*shell*"))%20(load-library%20"paren")%20;don't%20ask...just%20go%20with%20the%20magic%20incantation...%20)%20(defun%20setup-term%20()%20(interactive)%20(term%20"bash")%20(message%20"Wait...")%20(sit-for%202)%20(rmt-term-hook)%20(ignore-errors%20(kill-buffer%20"*shell*"))%20(switch-to-buffer%20"*terminal*")%20(rename-buffer%20"*shell*")%20(message%20"Wait...done."))%20#+END_SRC%20Something%20changed%20around%20Emacs%2024%20in%20how%20the%20faces%20are%20defined,%20and%20~unspecified~,%20which%20was%20the%20first%20element%20of%20the%20faces%20vector%20for%20term,%20is%20now%20apparently%20undefined,%20leading%20to%20errors%20when%20doing%20some%20commands%20(e.g.,%20~ls~).%20This%20is%20a%20hack;%20there's%20got%20to%20be%20a%20better%20way%20of%20doing%20this.][Terminal setup:5]]
(setq ansi-term-color-vector [default term-color-black term-color-red term-color-green term-color-yellow term-color-blue term-color-magenta term-color-cyan term-color-white])
;; Terminal setup:5 ends here
