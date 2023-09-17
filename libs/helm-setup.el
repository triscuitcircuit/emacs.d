;; [[file:~/Documents/emacs.d/2020-init/helm-setup.org::*Helm%20setup][Helm setup:1]]
;; use popwin
(use-package popwin
  :demand t
  :config (popwin-mode 1))

;; Sort helm results using fuzzy matching from flx:
(use-package helm-flx 
  :ensure t
  :config (helm-flx-mode 1))
(defun my-helm-display-frame-center (buffer &optional resume)
  "Display `helm-buffer' in a separate frame which centered in
parent frame."
  (if (not (display-graphic-p))
      ;; Fallback to default when frames are not usable.
      (helm-default-display-buffer buffer)
    (setq helm--buffer-in-new-frame-p t)
    (let* ((parent (selected-frame))
           (frame-pos (frame-position parent))
           (parent-left (car frame-pos))
           (parent-top (cdr frame-pos))
           (width (/ (frame-width parent) 2))
           (height (/ (frame-height parent) 3))
           tab-bar-mode
           (default-frame-alist
             (if resume
                 (buffer-local-value 'helm--last-frame-parameters
                                     (get-buffer buffer))
               `((parent . ,parent)
                 (width . ,width)
                 (height . ,height)
                 (undecorated . ,helm-use-undecorated-frame-option)
                 (left-fringe . 0)
                 (right-fringe . 0)
                 (tool-bar-lines . 0)
                 (line-spacing . 0)
                 (desktop-dont-save . t)
                 (no-special-glyphs . t)
                 (inhibit-double-buffering . t)
                 (tool-bar-lines . 0)
                 (left . ,(+ parent-left (/ (* (frame-char-width parent) (frame-width parent)) 4)))
                 (top . ,(+ parent-top (/ (* (frame-char-width parent) (frame-height parent)) 6)))
                 (title . "Helm")
                 (vertical-scroll-bars . nil)
                 (menu-bar-lines . 0)
                 (fullscreen . nil)
                 (visible . ,(null helm-display-buffer-reuse-frame))
                 ;; (internal-border-width . ,(if IS-MAC 1 0))
                )))
           display-buffer-alist)
      (set-face-background 'internal-border (face-foreground 'default))
      (helm-display-buffer-popup-frame buffer default-frame-alist))
    (helm-log-run-hook 'helm-window-configuration-hook)))

(use-package helm-config
  :ensure helm
  :demand t
  :diminish helm-mode			;get rid of mode-line display for helm
  ;; someone else's bindings that seem to work well:
  :bind (("C-M-z" . helm-resume)
	 ("C-x C-f" . helm-find-files)
	 ("C-x C-r" . helm-mini)
;	 ("C-x o" . helm-occur)
	 ("M-y" . helm-show-kill-ring)
	 ("C-h a" . helm-apropos)
	 ("C-h m" . helm-man-woman)
	 ("C-h SPC" . helm-all-mark-rings)
	 ("C-x C-i" . helm-semantic-or-imenu)
	 ("M-x" . helm-M-x)
	 ("C-x C-b" . helm-buffers-list)
	 ("C-x C-r" . helm-mini)
	 ("C-x b" . helm-mini)
	 ("C-h t" . helm-world-time))
  ;; Some initializations to run before loading helm-config:
  :init (setq helm-grep-default-command "grep -a -d skip %e -n%cH -e %p %f"
	      ;; may be overridden if 'ggrep' is in path (see below)
	      helm-grep-default-recurse-command "grep -a -d recurse %e -n%cH -e %p %f"
	      ;; use CURL, not url-retrieve-synchronously
	      helm-net-prefer-curl t
	      ;; be idle for this many seconds, before updating in delayed sources.
	      helm-input-idle-delay 0
	      ;; wider buffer name in helm-buffers-list
	      helm-buffer-max-length 28 ;; default is 20
	      ;; instead of "..." use a smaller unicode ellipsis
	      helm-buffers-end-truncated-string "…"
	      ;; open helm buffer in another window
	      ;;helm-split-window-default-side 'other
	      ;; set to nil and use <C-backspace> to toggle it in helm-find-files
	      helm-ff-auto-update-initial-value nil
	      ;; if I change the resplit state, re-use my settings
	      ;; helm-reuse-last-window-split-state t
	      ;; don't delete windows to always have 2
	      helm-always-two-windows nil
	      ;; open helm buffer inside current window, don't occupy whole other window
	      helm-split-window-in-side-p t
	      ;; fit buffer to width automatically
	      ;; fit-window-to-buffer-horizontally 1
	      ;; don't check if the file exists on remote files
	      helm-buffer-skip-remote-checking t
	      ;; limit the number of displayed canidates
	      helm-candidate-number-limit 100
	      ;; don't use recentf stuff in helm-ff, I use C-x C-r for this
	      helm-ff-file-name-history-use-recentf nil
	      ;; move to end or beginning of source when reaching top or bottom
	      ;; of source
	      helm-move-to-line-cycle-in-source t
	      ;; don't display the header line
					;	helm-display-header-line nil
	      ;; verbosity for helm tramp messages
	      helm-tramp-verbose 0
	      ;; fuzzy matching
	      helm-recentf-fuzzy-match t
	      helm-locate-fuzzy-match nil ;; locate fuzzy is worthless
	      helm-M-x-fuzzy-match t
	      helm-buffers-fuzzy-matching t
	      helm-semantic-fuzzy-match nil
	      helm-gtags-fuzzy-match nil
	      helm-imenu-fuzzy-match nil
	      helm-apropos-fuzzy-match nil
	      helm-lisp-fuzzy-completion nil
	      helm-completion-in-region-fuzzy-match nil
	      ;; autoresize to 25 rows
	      helm-autoresize-min-height 25
	      helm-autoresize-max-height 25
	      ;; Here are the things helm-mini shows, I add `helm-source-bookmarks'
	      ;; here to the regular default list
	      helm-mini-default-sources '(helm-source-buffers-list
					  helm-source-recentf
					  helm-source-bookmarks
					  helm-source-buffer-not-found)
	      ;; Reduce the list of things for helm-apropos
	      helm-apropos-function-list '(helm-def-source--emacs-commands
					   helm-def-source--emacs-functions
					   helm-def-source--emacs-variables
					   helm-def-source--emacs-faces))
  :config 
     (load "helm-files")
     (setq helm-ff-file-compressed-list '("gz" "bz2" "zip" "tgz" "xz" "txz"))
     (load "helm-buffers")
     (add-to-list 'helm-boring-buffer-regexp-list "^TAGS$")
     (add-to-list 'helm-boring-buffer-regexp-list "git-gutter:diff")
     (load "helm-mode")
     (add-hook 'after-init-hook #'helm-mode)
     (add-hook 'after-init-hook #'helm-autoresize-mode)
     (add-hook 'after-init-hook #'helm-adaptive-mode)
     (add-hook 'after-init-hook #'helm-popup-tip-mode)
     (load "helm-sys")
     (add-hook 'after-init-hook #'helm-top-poll-mode)
     (load "helm-grep")
     (setq helm-grep-truncate-lines nil)
     (define-key helm-grep-mode-map (kbd "<return>")  'helm-grep-mode-jump-other-window)
     (define-key helm-grep-mode-map (kbd "n")  'helm-grep-mode-jump-other-window-forward)
     (define-key helm-grep-mode-map (kbd "p")  'helm-grep-mode-jump-other-window-backward)
     (load "helm-man")
     (load "helm-misc")
     (load "helm-elisp")
     (load "helm-imenu")
     (load "helm-semantic")
     (load "helm-ring")
     (use-package smex :ensure t)
     (use-package helm-smex :ensure t)
     (load "helm-bookmark")
     (bind-key "C-x M-b" #'helm-bookmarks)
     (global-set-key (kbd "C-c h") 'helm-command-prefix)
     (global-unset-key (kbd "C-x c"))

     ;; Use popwin for helm buffers, otherwise I can't get helm to display the way
     ;; I want (at the bottom, without deleting windows)
     (push '("^\*helm.+\*$" :regexp t :height 20) popwin:special-display-config)
     ;;(setq helm-display-function 'popwin:pop-to-buffer)
     (setq helm-display-function 'my-helm-display-frame-center)
     ;; Shows helm input in the header instead of the footer
     (setq helm-echo-input-in-header-line t)
     (defun helm-hide-minibuffer-maybe ()
       "Hide minibuffer in Helm session if we use the header line as input field."
       (when (with-helm-buffer helm-echo-input-in-header-line)
	 (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
	   (overlay-put ov 'window (selected-window))
	   (overlay-put ov 'face
			(let ((bg-color (face-background 'default nil)))
			  `(:background ,bg-color :foreground ,bg-color)))
	   (setq-local cursor-type nil))))
     (add-hook 'helm-minibuffer-set-up-hook #'helm-hide-minibuffer-maybe)
     
     ;; Files that helm should know how to open
     (setq helm-external-programs-associations
	   '(("avi"  . "mpv")
	     ("part" . "mpv")
	     ("mkv"  . "mpv")
	     ("webm" . "mpv")
	     ("mp4"  . "mpv")))

     ;; List of times to show in helm-world-time
     (setq display-time-world-list '(("PST8PDT" "Mountain View")
				     ("America/Denver" "Denver")
				     ("EST5EDT" "Boston")
				     ("UTC" "UTC")
				     ("Europe/London" "London")
				     ("Europe/Amsterdam" "Amsterdam")
				     ("Asia/Bangkok" "Bangkok")
				     ("Asia/Tokyo" "Tokyo")
				     ("Australia/Sydney" "Sydney")))

     ;; rebind tab to do persistent action
     (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
     ;; make TAB works in terminal
     (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
     ;; list actions using C-z
     (define-key helm-map (kbd "C-z")  'helm-select-action)

     (define-key helm-map (kbd "C-p")   'helm-previous-line)
     (define-key helm-map (kbd "C-n")   'helm-next-line)
     (define-key helm-map (kbd "C-M-n") 'helm-next-source)
     (define-key helm-map (kbd "C-M-p") 'helm-previous-source)
     (define-key helm-map (kbd "M-N")   'helm-next-source)
     (define-key helm-map (kbd "M-P")   'helm-previous-source)

     (when (executable-find "curl")
       (setq helm-google-suggest-use-curl-p t))

     ;; ggrep is gnu grep on OSX
     (when (executable-find "ggrep")
       (setq helm-grep-default-command
	     "ggrep -a -d skip %e -n%cH -e %p %f"
	     helm-grep-default-recurse-command
	     "ggrep -a -d recurse %e -n%cH -e %p %f"))

     ;; helm-mini instead of recentf
     (define-key 'help-command (kbd "C-f") 'helm-apropos)
     (define-key 'help-command (kbd "r") 'helm-info-emacs)

     (defvar helm-httpstatus-source
       '((name . "HTTP STATUS")
	 (candidates . (("100 Continue") ("101 Switching Protocols")
			("102 Processing") ("200 OK")
			("201 Created") ("202 Accepted")
			("203 Non-Authoritative Information") ("204 No Content")
			("205 Reset Content") ("206 Partial Content")
			("207 Multi-Status") ("208 Already Reported")
			("300 Multiple Choices") ("301 Moved Permanently")
			("302 Found") ("303 See Other")
			("304 Not Modified") ("305 Use Proxy")
			("307 Temporary Redirect") ("400 Bad Request")
			("401 Unauthorized") ("402 Payment Required")
			("403 Forbidden") ("404 Not Found")
			("405 Method Not Allowed") ("406 Not Acceptable")
			("407 Proxy Authentication Required") ("408 Request Timeout")
			("409 Conflict") ("410 Gone")
			("411 Length Required") ("412 Precondition Failed")
			("413 Request Entity Too Large")
			("414 Request-URI Too Large")
			("415 Unsupported Media Type")
			("416 Request Range Not Satisfiable")
			("417 Expectation Failed") ("418 I'm a teapot")
			("421 Misdirected Request")
			("422 Unprocessable Entity") ("423 Locked")
			("424 Failed Dependency") ("425 No code")
			("426 Upgrade Required") ("428 Precondition Required")
			("429 Too Many Requests")
			("431 Request Header Fields Too Large")
			("449 Retry with") ("500 Internal Server Error")
			("501 Not Implemented") ("502 Bad Gateway")
			("503 Service Unavailable") ("504 Gateway Timeout")
			("505 HTTP Version Not Supported")
			("506 Variant Also Negotiates")
			("507 Insufficient Storage") ("509 Bandwidth Limit Exceeded")
			("510 Not Extended")
			("511 Network Authentication Required")))
	 (action . message)))

     (defvar helm-clj-http-source
       '((name . "clj-http options")
	 (candidates
	  .
	  ((":accept - keyword for content type to accept")
	   (":as - output coercion: :json, :json-string-keys, :clojure, :stream, :auto or string")
	   (":basic-auth - string or vector of basic auth creds")
	   (":body - body of request")
	   (":body-encoding - encoding type for body string")
	   (":client-params - apache http client params")
	   (":coerce - when to coerce response body: :always, :unexceptional, :exceptional")
	   (":conn-timeout - timeout for connection")
	   (":connection-manager - connection pooling manager")
	   (":content-type - content-type for request")
	   (":cookie-store - CookieStore object to store/retrieve cookies")
	   (":cookies - map of cookie name to cookie map")
	   (":debug - boolean to print info to stdout")
	   (":debug-body - boolean to print body debug info to stdout")
	   (":decode-body-headers - automatically decode body headers")
	   (":decompress-body - whether to decompress body automatically")
	   (":digest-auth - vector of digest authentication")
	   (":follow-redirects - boolean whether to follow HTTP redirects")
	   (":form-params - map of form parameters to send")
	   (":headers - map of headers")
	   (":ignore-unknown-host? - whether to ignore inability to resolve host")
	   (":insecure? - boolean whether to accept invalid SSL certs")
	   (":json-opts - map of json options to be used for form params")
	   (":keystore - file path to SSL keystore")
	   (":keystore-pass - password for keystore")
	   (":keystore-type - type of SSL keystore")
	   (":length - manually specified length of body")
	   (":max-redirects - maximum number of redirects to follow")
	   (":multipart - vector of multipart options")
	   (":oauth-token - oauth token")
	   (":proxy-host - hostname of proxy server")
	   (":proxy-ignore-hosts - set of hosts to ignore for proxy")
	   (":proxy-post - port for proxy server")
	   (":query-params - map of query parameters")
	   (":raw-headers - boolean whether to return raw headers with response")
	   (":response-interceptor - function called for each redirect")
	   (":retry-handler - function to handle HTTP retries on IOException")
	   (":save-request? - boolean to return original request with response")
	   (":socket-timeout - timeout for establishing socket")
	   (":throw-entire-message? - whether to throw the entire response on errors")
	   (":throw-exceptions - boolean whether to throw exceptions on 5xx & 4xx")
	   (":trust-store - file path to trust store")
	   (":trust-store-pass - password for trust store")
	   (":trust-store-type - type of trust store")))
	 (action . message)))

     (defun helm-httpstatus ()
       (interactive)
       (helm-other-buffer '(helm-httpstatus-source) "*helm httpstatus*"))

     (defun helm-clj-http ()
       (interactive)
       (helm-other-buffer '(helm-clj-http-source) "*helm clj-http flags*")))

;; Helm setup:1 ends here
