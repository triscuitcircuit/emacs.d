(add-to-list 'load-path "~/.emacs.d/2020-init/spotify.el")
(require 'spotify)

;; Settings
(setq spotify-oauth2-client-secret "5958973f4b594915bc6f081aa18293b7")
(setq spotify-oauth2-client-id "8b008c3a65ba4dea90e694611edaf9ee")
(define-key spotify-mode-map (kbd "C-c .") 'spotify-command-map)
