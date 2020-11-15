(setq mu4e-mu-binary (executable-find "mu"))

(setq org-publish-project-alist
      '(("org-notes"
         :base-directory "~/notes/"
         :publishing-directory "~/public_html/"
         :publishing-function org-twbs-publish-to-html
         :with-sub-superscript nil
         )))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (ox-pandoc ox-twbs ccls company-lsp lsp-ui lsp-mode yard-mode yaml-mode which-key wgrep web-mode use-package synosaurus solarized-theme smex slim-mode scss-mode scala-mode sbt-mode ruby-end rspec-mode rainbow-delimiters python-mode py-autopep8 projectile-rails paredit org-bullets multi-term moody minions instapaper helpful haskell-mode haml-mode graphviz-dot-mode go-errcheck gnuplot forge flycheck-package flx evil-surround evil-org evil-mu4e evil-magit engine-mode elpy elfeed-org dumb-jump dired-open dired-hide-dotfiles diff-hl deft counsel company-jedi company-go company-coq coffee-mode chruby bbdb auto-compile ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-code-face ((t nil))))


(server-start)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))


(defun get-point (symbol &optional arg)
  "get the point"
  (funcall symbol arg)
  (point))

(defun copy-thing (begin-of-thing end-of-thing &optional arg)
  "Copy thing between beg & end into kill ring."
  (save-excursion
    (let ((beg (get-point begin-of-thing 1))
          (end (get-point end-of-thing arg)))
      (copy-region-as-kill beg end))))

(defun paste-to-mark (&optional arg)
  "Paste things to mark, or to the prompt in shell-mode."
  (unless (eq arg 1)
    (if (string= "shell-mode" major-mode)
        (comint-next-prompt 25535)
      (goto-char (mark)))
    (yank)))

(defun beginning-of-string (&optional arg)
  (when (re-search-backward "[ \t]" (line-beginning-position) :noerror 1)
    (forward-char 1)))

(defun end-of-string (&optional arg)
  (when (re-search-forward "[ \t]" (line-end-position) :noerror arg)
    (backward-char 1)))


(defun copy-word (&optional arg)
  "Copy words at point into kill-ring"
  (interactive "P")
  (copy-thing 'beginning-of-string 'end-of-string arg)
  ;;(paste-to-mark arg)
  )


(defun thing-copy-string-to-mark(&optional arg)
  " Try to copy a string and paste it to the mark
     When used in shell-mode, it will paste string on shell prompt by default "
  (interactive "P")
  (copy-thing 'beginning-of-string 'end-of-string arg)
  (paste-to-mark arg)
  )


(defun my/fix-inline-images ()
  (when org-inline-image-overlays
    (org-redisplay-inline-images)))

(add-hook 'org-babel-after-execute-hook 'my/fix-inline-images)

(defun aj-toggle-fold ()
  "Toggle fold all lines larger than indentation on current line"
  (interactive)
  (let ((col 1))
    (save-excursion
      (back-to-indentation)
      (setq col (+ 1 (current-column)))
      (set-selective-display
       (if selective-display nil (or col 1))))))
(global-set-key (kbd "C-c C-f") 'aj-toggle-fold)

(defun copy-buffer-file-name-as-kill (choice)
  "Copyies the buffer {name/mode}, file {name/full path/directory} to the kill-ring."
  (interactive "cCopy (b) buffer name, (m) buffer major mode, (f) full buffer-file path, (d) buffer-file directory, (n) buffer-file basename")
  (let ((new-kill-string)
        (name (if (eq major-mode 'dired-mode)
                  (dired-get-filename)
                (or (buffer-file-name) ""))))
    (cond ((eq choice ?f)
           (setq new-kill-string name))
          ((eq choice ?d)
           (setq new-kill-string (file-name-directory name)))
          ((eq choice ?n)
           (setq new-kill-string (file-name-nondirectory name)))
          ((eq choice ?b)
           (setq new-kill-string (buffer-name)))
          ((eq choice ?m)
           (setq new-kill-string (format "%s" major-mode)))
          (t (message "Quit")))
    (when new-kill-string
      (message "%s copied" new-kill-string)
      (kill-new new-kill-string))))


;; (require 'js2-mode)
;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; ;; Better imenu
;; (add-hook 'js2-mode-hook #'js2-imenu-extras-mode)


(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)
(setq-default typescript-indent-level 2)


(require 'ansi-color)
(defun display-ansi-colors ()
  (interactive)
  (ansi-color-apply-on-region (point-min) (point-max)))

(setq inferior-lisp-program "sbcl")


(use-package vscode-dark-plus-theme
  :config
  (load-theme 'vscode-dark-plus t))

(defun call-argo-delete ()
  "run a command on the current file and revert the buffer"
  (interactive)
  (shell-command
   (format "argo template delete  %s"
           (shell-quote-argument (file-name-base buffer-file-name))))
  )

(defun call-argo-create ()
  "run a command on the current file and revert the buffer"
  (interactive)
  (shell-command
   (format "argo template create  %s"
           (shell-quote-argument (buffer-file-name))))
  )

(defun call-argo-logs ()
  "run a command on the current file and revert the buffer"
  (interactive)
  (shell-command
   (format "kubectl -n rolling logs -c main %s"
           (buffer-substring-no-properties (get-point 'beginning-of-string) (get-point 'end-of-string) )))
  )

(setq jiralib-url "https://outreach-io.atlassian.net")

(require 'ox-publish)
;; (setq org-publish-project-alist
;;       '(
;;         ;; ... add all the components here (see below)...
;;         ("org-notes"
;;          :base-directory "~/org/"
;;          :base-extension "org"
;;          :publishing-directory "~/public_html/"
;;          :recursive t
;;          :publishing-function org-html-publish-to-html
;;          :headline-levels 4             ; Just the default for this project.
;;          :auto-preamble t
;;          )
;;         ("org-static"
;;          :base-directory "~/org/"
;;          :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
;;          :publishing-directory "~/public_html/"
;;          :recursive t
;;          :publishing-function org-publish-attachment
;;          )
;;         ("org" :components ("org-notes" "org-static"))
;;         ))


;; ;;;
;; ;;; Org Mode
;; ;;;
;; (add-to-list 'load-path (expand-file-name "~/code/org-mode/lisp"))
;; (add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
;; (require 'org)
;; ;;
;; ;; Standard key bindings
;; (global-set-key "\C-cl" 'org-store-link)
;; (global-set-key "\C-ca" 'org-agenda)
;; (global-set-key "\C-cb" 'org-iswitchb)

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu/mu4e")
(require 'mu4e)

(require 'smtpmail)

; smtp
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials
      '(("smtp.gmail.com" 587 nil nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-debug-info t)

(require 'mu4e)

(setq mu4e-maildir (expand-file-name "~/email/mbsyncmail"))

(setq mu4e-drafts-folder "/Drafts")
(setq mu4e-sent-folder   "/Sent Items")
(setq mu4e-trash-folder  "/Trash")
(setq message-signature-file "~/.emacs.d/.signature") ; put your signature in this file

; get mail
(setq mu4e-get-mail-command "mbsync -c ~/.dotfiles/email/.mbsyncrc personal"
      mu4e-html2text-command "w3m -T text/html"
      mu4e-update-interval 120
      mu4e-headers-auto-update t
      mu4e-compose-signature-auto-include nil)

(setq mu4e-maildir-shortcuts
      '( ("/INBOX"               . ?i)
         ("/Sent Items"   . ?s)
         ("/Trash"       . ?t)
         ("/Drafts"    . ?d)))

;; show images
(setq mu4e-show-images t)

;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

;; general emacs mail settings; used when composing e-mail
;; the non-mu4e-* stuff is inherited from emacs/message-mode
(setq mu4e-reply-to-address "me@example.com"
    user-mail-address "me@example.com"
    user-full-name  "Rob Stewart")

;; don't save message to Sent Messages, IMAP takes care of this
; (setq mu4e-sent-messages-behavior 'delete)

;; spell check
(add-hook 'mu4e-compose-mode-hook
        (defun my-do-compose-stuff ()
           "My settings for message composition."
           (set-fill-column 72)
           (flyspell-mode)))
