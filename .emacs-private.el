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
