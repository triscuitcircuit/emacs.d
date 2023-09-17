(put 'upcase-region 'disabled nil)


;;load path change
(defun push-load-path (file)
  (push (expand-file-name file) load-path))


(defun  append-load-path (file)
  (setq load-path (append load-path 
			  (list (expand-file-name file)))))
(defun push-exec-path (file)
  (push (expand-file-name file) exec-path))

(defun append-exec-path (file)
  (setq exec-path (append exec-path (list (expand-file-name file)))))
;; Load path:1 ends here

(defun my/custom-set-variables (varval)
  "Replacement for custom-set-variables for use in init file.  VARVAL should be a list of lists, each of the form (var val)."
  (mapcar #'(lambda (a) (customize-set-variable (car a) (cadr a)))
	  varval))

;;(pdf-tools-install)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(menu-bar-mode)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;;something emacs should have on by default... this is used to increase and decrease size
(setenv "PATH" (concat (getenv "PATH") ":/Library/TeX/texbin"))

;;(use-package ox-moderncv
;;  :load-path "/Users//Documents/moderncv/org-cv"
;;  :init (require 'ox-moderncv))

(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(show-paren-mode t)

;;(package-install 'flycheck)
;;(global-flycheck-mode t)

;;(auto-complete-mode 1)
(global-display-line-numbers-mode t)
(desktop-save-mode 1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Package Management
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(customize-set-variable 'package-archives
			'(("org"       . "https://orgmode.org/elpa/")
			  ("gnu"       . "https://elpa.gnu.org/packages/")
			  ("melpa"     . "https://melpa.org/packages/")
			  ("melpa-stable"     . "https://stable.melpa.org/packages/")
			  ))


;(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))

(require 'use-package)
(require 'org)


(require 'yasnippet)
(yas-global-mode 1)

(load (expand-file-name "~/.quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")


(require 'company)
(setq company-idle-delay 0)

(add-hook 'after-init-hook 'global-company-mode)

(add-to-list 'company-backends 'company-c-headers)

(setq company-backends (delete 'company-semantic company-backends))

;;(define-key c-mode-map  [(tab)] 'company-complete)
;;(define-key c++-mode-map  [(tab)] 'company-complete)

(require 'smartparens-config)
(show-smartparens-global-mode +1)
(smartparens-global-mode 1)

(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))

(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
 )


(require 'cc-mode)
(require 'semantic)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)

(semantic-mode 1)

(setq mode-line-format
      (list
       '(:eval (list (nyan-create)))
       ))
(setq nyan-mode t)


(use-package dired-sidebar
  :ensure t
  :commands (dired-sidebar-toggle-sidebar))

;;python support in emacs
(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable))
(customize-set-variable 'elpy-rpc-python-command "/usr/bin/python3")

;;rust lang support in emacs!!!
(add-hook 'racer-mode-hook #'company-mode)
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(require 'rust-mode)

(package-install 'use-package)

(when (not package-archive-contents)
  (package-refresh-contents))

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))

(customize-set-variable 'use-package-always-defer nil)
(customize-set-variable 'use-package-always-ensure t)

(use-package auto-compile
  :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)


(package-install 'use-package)

(when (not package-archive-contents)
  (package-refresh-contents))

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))

(customize-set-variable 'use-package-always-defer nil)
(customize-set-variable 'use-package-always-ensure t)

(use-package auto-compile
  :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)

;;(use-package env-var-import
;;  :config (env-var-import))

(append-exec-path "~/bin")
(push-exec-path ".")

;; Access mode to delete a region when a key is struck (i.e., as in Windows):
(customize-set-variable 'cua-delete-selection nil)
(customize-set-variable 'delete-active-region nil)
(savehist-mode 1)

(message "Loading eldoc")
(use-package eldoc
 :diminish eldoc-mode
  :commands turn-on-eldoc-mode
  :defer t
  :init (progn
	   (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
	   (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
	   (add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)))

;(custom-set-variables
; '((projectile-switch-project-action neotree-projectile-action)))
(setq org-babel-lisp-eval-fn #'sly-eval)
(setq org-confirm-babel-evaluate nil
      org-src-fontify-natively t
      org-src-tab-acts-natively t)


(message "Loading undo-tree")
(use-package undo-tree
  :config (global-undo-tree-mode))

(use-package filladapt
  :config (setq-default filladapt-mode t))

(use-package visual-regexp)

(message "Loading autoinsert")
(use-package autoinsert
  :config (auto-insert-mode t))
(customize-set-variable
 'auto-insert-alist
 '((html-mode lambda nil
	      (sgml-tag "html"))
   (plain-tex-mode . "tex-insert.tex")
   (org-mode . "org.org")
   ("notes.org" . "notes-insert.org")))

(message "loading fly spell")
(use-package flyspell
  :hook (
	 (prog-mode . flyspell-prog-mode)
	 (text-mode . flyspell-mode)
	)
)

(message "loading synosaurus")
(use-package synosaurus
  :diminish synosaurus-mode
  :init (synosaurus-mode)
  :config (setq synosaurus-choose-method 'popup)
  (global-set-key (kbd "M-#") 'synosaurus-choose-and-replace))
(message "loading google translate")
(use-package google-translate
  :config (global-set-key "\C-ct" 'google-translate-at-point))
(message "loading goto-chg")
(use-package goto-chg
  :init (setq glc-default-span 0)
  :bind (("C-c e ," . goto-last-change)
	 ("C-c e ." . goto-last-change-reverse))
  )
(message "Loading dired-toggle-sudo")

(use-package dired-toggle-sudo
  :config (eval-after-load 'tramp
	    '(progn
	       ;; Allow to use: /sudo:user@host:/path/to/file
	       (add-to-list 'tramp-default-proxies-alist
			    '(".*" "\\`.+\\'" "/ssh:%h:"))))
  :bind (:map dired-mode-map ("C-c C-s" . dired-toggle-sudo)))
;; Use sudo in dired:1 ends here
(message "Loading Helm")
(add-to-list 'load-path "~/.emacs.d/libs")
(load-library "helm-setup")
(message "loading magit")
(use-package magit)
(message "loading which key")
(use-package which-key
  :defer nil
  :diminish which-key-mode
  :config
  (which-key-mode))
(message "loading persistent scratch")
(use-package persistent-scratch
  :config
  (persistent-scratch-setup-default))
(bind-key "M-g" #'goto-line)
(server-start)

`(
  (savehist-file "~/.emacs.d/history")
  (history-length t)
  (history-delete-duplicates t)
  (savehist-save-minibuffer-history 1)
  (savehist-additional-variables
   (kill-ring
    search-ring
    regexp-search-ring
    )
   )
  )
(savehist-mode 1)
(message "loading spaceline")
(use-package spaceline
  :config
  (require 'spaceline-config)
  (setq spaceline-buffer-encoding-abbrev-p nil)
  (setq spaceline-line-column-p nil)
  (setq spaceline-line-p nil)
  (setq powerline-default-separator 'arrow)
  :init
  (spaceline-helm-mode)
  (spaceline-spacemacs-theme)
  )
(package-install 'flycheck)
(global-flycheck-mode)
(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))


(use-package dired-sidebar
  :ensure t
  :commands (dired-sidebar-toggle-sidebar))
(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-theme 'vscode)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))
  
  (defcustom python-shell-interpreter "python3"
  "Default Python interpreter for shell."
  :type 'string
  :group 'python)

(org-babel-do-load-languages
'org-babel-load-languages
   (quote
    ((emacs-lisp . t)
     (latex . t)
     (lisp . t)
     (dot . t)
     (perl . t)
     (python . t))))
  
(message "Loading org-setup")
(add-to-list 'load-path "~/.emacs.d/libs")
(load-library "org-setup")

(require 'company-lsp)
(add-to-list 'company-lsp-filter-candidates '(digestif . nil))

(message "loading auctix")
(use-package "auctex")

(message "loading osx browse")
(use-package osx-browse
  :config (osx-browse-mode 1))

(message "loading osx dictionary")
(use-package osx-dictionary)

(use-package exec-path-from-shell
  :init (when (memq window-system '(mac ns x))
	  (exec-path-from-shell-initialize)))


(message "loading osx-trash")
(use-package osx-trash
  :config (progn (osx-trash-setup)
		 (setq delete-by-moving-to-trash t)))
(message "Loading osx-lib")
(use-package osx-lib)

(my/custom-set-variables
 '(
   (ical-pull-list ("https://www.icloud.com/#calendar"))
   (ns-command-modifier meta)
   (ns-tool-bar-display-mode both)
   (ns-tool-bar-size-mode small)
   ))

(my/custom-set-variables
 '((TeX-PDF-mode t)
   (TeX-auto-save t)
   (TeX-engine xetex)
   (TeX-master nil)
   (TeX-output-view-style
    (("^dvi$"
      ("^landscape$" "^pstricks$\\|^pst-\\|^psfrag$")
      "%(o?)dvips -t landscape %d -o && gv %f")
     ("^dvi$" "^pstricks$\\|^pst-\\|^psfrag$" "%(o?)dvips %d -o && gv %f")
     ("^dvi$"
      ("^\\(?:a4\\(?:dutch\\|paper\\|wide\\)\\|sem-a4\\)$" "^landscape$")
      "%(o?)xdvi %dS -paper a4r -s 0 %d")
     ("^dvi$" "^\\(?:a4\\(?:dutch\\|paper\\|wide\\)\\|sem-a4\\)$" "%(o?)xdvi %dS -paper a4 %d")
     ("^dvi$"
      ("^\\(?:a5\\(?:comb\\|paper\\)\\)$" "^landscape$")
      "%(o?)xdvi %dS -paper a5r -s 0 %d")
     ("^dvi$" "^\\(?:a5\\(?:comb\\|paper\\)\\)$" "%(o?)xdvi %dS -paper a5 %d")
     ("^dvi$" "^b5paper$" "%(o?)xdvi %dS -paper b5 %d")
     ("^dvi$" "^letterpaper$" "%(o?)xdvi %dS -paper us %d")
     ("^dvi$" "^legalpaper$" "%(o?)xdvi %dS -paper legal %d")
     ("^dvi$" "^executivepaper$" "%(o?)xdvi %dS -paper 7.25x10.5in %d")
     ("^dvi$" "." "%(o?)xdvi %dS %d")
     ("^pdf$" "." "open %o")
     ("^html?$" "." "netscape %o")))
   (TeX-parse-self t)
   (TeX-print-command "dvips -f %s|lpr -h -P%p")
   (TeX-view-program-list (("open" "open %o")))
   (TeX-view-program-selection
    (((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "open")
     (output-html "xdg-open")))
   (TeX-view-style
    (("^a5$" "xdvi %d -paper a5")
     ("^landscape$" "xdvi %d -paper a4r -s 4")
     ("." "xdvi %d")))))

;; celcius to Fahrenheit
(defun c-to-f (c)
  (interactive "nCelsius: ")
  (let ((f (round-to (+ 32 ( * 1.8 )) 1))
	(message (format "%g C is %1g F." c f))
	f)))
 ;; Fahrenheit to Celsius
(defun f-to-c (f)
  (interactive "nFahrenheit: ")
  (let ((c (round-to (/ (- f 32) 1.8) 1)))
    (message (format "%g F is %g F." f c))
    c))
(require 'org-ref)
;;(setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))
;;(setq org-latex-pdf-process (quote ("texi2dvi -p -b -V %f")))

(setq org-latex-pdf-process (list "latexmk -pdflatex='lualatex -shell-escape -interaction nonstopmode' -pdf -f  %f"))

(use-package org-ref
  :ensure nil
  :load-path (lambda () (expand-file-name "org-ref" scimax-dir))
  :init
  (add-to-list 'load-path
	       (expand-file-name "org-ref" scimax-dir))
  (require 'bibtex)
  (setq bibtex-autokey-year-length 4
	bibtex-autokey-name-year-separator "-"
	bibtex-autokey-year-title-separator "-"
	bibtex-autokey-titleword-separator "-"
	bibtex-autokey-titlewords 2
	bibtex-autokey-titlewords-stretch 1
	bibtex-autokey-titleword-length 5)
  (define-key bibtex-mode-map (kbd "H-b") 'org-ref-bibtex-hydra/body)
  (define-key org-mode-map (kbd "C-c ]") 'org-ref-insert-link)
  (define-key org-mode-map (kbd "s-[") 'org-ref-insert-link-hydra/body)
  (require 'org-ref-ivy)
  (require 'org-ref-arxiv)
  (require 'org-ref-scopus)
  (require 'org-ref-wos))

(require 'ox-reveal)

;; Kills all buffers
(defun close-all-buffers ()
(interactive)
  (mapc 'kill-buffer (buffer-list)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Appearance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(set-fringe-style 0)

(use-package sweet-theme
  :ensure t
  :init
  (load-theme 'sweet t))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(defun tkj-load-graphical-settings()
  (interactive)
  ;; Themes
  (add-to-list 'custom-theme-load-path "$HOME/.emacs.d/themes")

  (if (eq system-type 'gnu/linux)
      (progn
        ;; Favourite fonts: Source Code Pro, Terminus
        (set-face-attribute 'default nil
                            :family "Source Code Pro"
                            :height 120
                            :weight 'medium
                            :width 'normal)))
  (set-cursor-color "red")
  (set-scroll-bar-mode nil)
  (setq-default cursor-type 'box)
  (tool-bar-mode 0))

(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'character)
(setq highlight-indent-guides-character ?|)
(setq highlight-indent-guides-auto-character-face-perc 40)

;; Turn off unwanted clutter from the modeline
(use-package diminish
  :init
  (diminish 'abbrev-mode)
  (diminish 'auto-fill-mode)
  (diminish 'company-mode)
  (diminish 'eldoc-mode)
  (diminish 'flycheck-mode)
  (diminish 'git-gutter+-mode)
  (diminish 'gtags-mode)
  (diminish 'java-mode)
  (diminish 'projectile-mode)
  (diminish 'visual-line-mode)
  (diminish 'winner-mode)
  (diminish 'ws-butler-global-mode)
  (diminish 'ws-butler-mode)
  (diminish 'yas-minor-mode)
  (diminish 'slack-buffer-mode)
  (diminish 'slack-thread-message-buffer-mode)
  )


(when window-system
  (tkj-load-graphical-settings))

;; Rainbow Delimeter
;; Customize Rainbow Delimiters.
(require 'rainbow-delimiters)
(set-face-foreground 'rainbow-delimiters-depth-1-face "#c66")  ; red
(set-face-foreground 'rainbow-delimiters-depth-2-face "#6c6")  ; green
(set-face-foreground 'rainbow-delimiters-depth-3-face "#69f")  ; blue
(set-face-foreground 'rainbow-delimiters-depth-4-face "#cc6")  ; yellow
(set-face-foreground 'rainbow-delimiters-depth-5-face "#6cc")  ; cyan
(set-face-foreground 'rainbow-delimiters-depth-6-face "#c6c")  ; magenta
(set-face-foreground 'rainbow-delimiters-depth-7-face "#ccc")  ; light gray
(set-face-foreground 'rainbow-delimiters-depth-8-face "#999")  ; medium gray
(set-face-foreground 'rainbow-delimiters-depth-9-face "#666")  ; dark gray


;;; custom.el
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(org-html-head-extra "
")
 '(org-latex-classes
   '(("IEEEtran" "\\documentclass[conference]{IEEEtran}"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
     ("article" "\\documentclass[11pt]{article}"
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
      ("\\paragraph{%s}" . "\\paragraph*{%s}")
      ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
     ("report" "\\documentclass[11pt]{report}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
     ("book" "\\documentclass[11pt]{book}"
      ("\\part{%s}" . "\\part*{%s}")
      ("\\chapter{%s}" . "\\chapter*{%s}")
      ("\\section{%s}" . "\\section*{%s}")
      ("\\subsection{%s}" . "\\subsection*{%s}")
      ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))
 '(org-latex-image-default-width "0.3\\linewidth")
 '(package-selected-packages '(org-ref)))


