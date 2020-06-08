;; Configure package.el to include MELPA.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Ensure that use-package is installed.
;;
;; If use-package isn't already installed, it's extremely likely that this is a
;; fresh installation! So we'll want to update the package repository and
;; install use-package before loading the literate configuration.
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

(org-babel-load-file "~/.emacs.d/configuration.org")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-export-with-sub-superscripts nil)
 '(package-selected-packages
   (quote
    (vscode-dark-plus-theme string-inflection minimap org-attach-screenshot kubernetes-helm kubernetes-tramp terraform-doc company-terraform terraform-mode polymode csv csv-mode protobuf-mode kubel tmux-pane ssh tide ox-pandoc ox-twbs ccls company-lsp lsp-ui lsp-mode yard-mode yaml-mode which-key wgrep web-mode use-package synosaurus solarized-theme smex slim-mode scss-mode scala-mode sbt-mode ruby-end rspec-mode rainbow-delimiters python-mode py-autopep8 projectile-rails paredit org-bullets multi-term moody minions instapaper helpful haskell-mode haml-mode graphviz-dot-mode go-errcheck gnuplot forge flycheck-package flx evil-surround evil-org evil-mu4e evil-magit engine-mode elpy elfeed-org dumb-jump dired-open dired-hide-dotfiles diff-hl deft counsel company-jedi company-go company-coq coffee-mode chruby bbdb auto-compile ag))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-code-face ((t nil))))
