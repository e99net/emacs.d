 ;; (require 'cl)

;; (when (>= emacs-major-version 24)
;;   (setq package-archives '(("gnu" . "http://elpa.emacs-china.org/gnu/")
;; 			   ("melpa" . "http://elpa.emacs-china.org/melpa/")))
;;     )



;;   ;;add whatever packages you want here
;;   (defvar e99net/packages '(
;;                             company
;; 			    monokai-theme
;; 			    hungry-delete
;; 			    swiper
;; 			    counsel
;; 			    smartparens
;; 			    js2-mode
;; 			    nodejs-repl
;; 			    exec-path-from-shell
;; 			    popwin
;; 			    reveal-in-osx-finder
;; 			    web-mode
;; 			    js2-refactor
;; 			    expand-region
;; 			    iedit
;; 			    org-pomodoro
;; 			    helm-ag
;; 			    flycheck
;; 			    auto-yasnippet
;; 			    evil
;; 			    evil-leader
;; 			    window-numbering
;; 			    evil-surround
;; 			    evil-nerd-commenter
;; 			    which-key
;; 			    ) "Default packages")

;; (setq package-selected-packages e99net/packages)

;;   (defun e99net/packages-installed-p ()
;;     (loop for pkg in e99net/packages
;;           when (not (package-installed-p pkg)) do (return nil)
;; 	  finally (return t)))

;;   (unless (e99net/packages-installed-p)
;;     (message "%s" "Refreshing package database...")
;;     (package-refresh-contents)
;;     (dolist (pkg e99net/packages)
;;       (when (not (package-installed-p pkg))
;;         (package-install pkg))))


;; let emacs could find the executable
;; (when (memq window-system '(mac ns))
;;   (exec-path-from-shell-initialize))

(use-package exec-path-from-shell
:if (and (eq system-type 'darwin) (display-graphic-p))
:ensure t
:pin melpa-stable
:config
(progn
(when (string-match-p "/zsh$" (getenv "SHELL"))
;; Use a non-interactive login shell. A login shell, because my
;; environment variables are mostly set in `.zprofile'.
(setq exec-path-from-shell-arguments '("-l")))

(exec-path-from-shell-initialize)
)
)


(global-hungry-delete-mode)

;;(add-hook 'emacs-lisp-mode-hook 'smartparens-mode)
(smartparens-global-mode t)

(sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
(sp-local-pair 'lisp-interaction-mode "'" nil :actions nil)

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)

;; config js2-mode for js files
(setq auto-mode-alist
      (append
       '(("\\.js\\'" . js2-mode)
	 ("\\.html\\'" . web-mode))
       auto-mode-alist))

(global-company-mode t)

;; config for web mode
 (defun my-web-mode-indent-setup ()
    (setq web-mode-markup-indent-offset 2) ; web-mode, html tag in html file
    (setq web-mode-css-indent-offset 2)    ; web-mode, css in html file
    (setq web-mode-code-indent-offset 2)   ; web-mode, js code in html file
    )

(add-hook 'web-mode-hook 'my-web-mode-indent-setup)

 (defun my-toggle-web-indent ()
    (interactive)
    ;; web development
    (if (or (eq major-mode 'js-mode) (eq major-mode 'js2-mode))
        (progn
	  (setq js-indent-level (if (= js-indent-level 2) 4 2))
	  (setq js2-basic-offset (if (= js2-basic-offset 2) 4 2))))

    (if (eq major-mode 'web-mode)
        (progn (setq web-mode-markup-indent-offset (if (= web-mode-markup-indent-offset 2) 4 2))
	       (setq web-mode-css-indent-offset (if (= web-mode-css-indent-offset 2) 4 2))
	       (setq web-mode-code-indent-offset (if (= web-mode-code-indent-offset 2) 4 2))))
    (if (eq major-mode 'css-mode)
        (setq css-indent-offset (if (= css-indent-offset 2) 4 2)))

    (setq indent-tabs-mode nil))



;; config for js2-refactor
(add-hook 'js2-mode-hook #'js2-refactor-mode)



(defun js2-imenu-make-index ()
         (interactive)
	 (save-excursion
	   ;; (setq imenu-generic-expression '((nil "describe\\(\"\\(.+\\)\"" 1)))
	   (imenu--generic-function '(("describe" "\\s-*describe\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
	   ("it" "\\s-*it\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
	   ("test" "\\s-*test\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
	   ("before" "\\s-*before\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
	   ("after" "\\s-*after\\s-*(\\s-*[\"']\\(.+\\)[\"']\\s-*,.*" 1)
	   ("Function" "function[ \t]+\\([a-zA-Z0-9_$.]+\\)[ \t]*(" 1)
	   ("Function" "^[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*=[ \t]*function[ \t]*(" 1)
	   ("Function" "^var[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*=[ \t]*function[ \t]*(" 1)
	   ("Function" "^[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*()[ \t]*{" 1)
	   ("Function" "^[ \t]*\\([a-zA-Z0-9_$.]+\\)[ \t]*:[ \t]*function[ \t]*(" 1)
	   ("Task" "[. \t]task([ \t]*['\"]\\([^'\"]+\\)" 1)))))
  (add-hook 'js2-mode-hook
                (lambda ()
		  (setq imenu-create-index-function 'js2-imenu-make-index)))

(load-theme 'monokai t)

(require 'popwin)
(popwin-mode t)




(require 'org-pomodoro)

(add-hook 'js2-mode-hook 'flycheck-mode)

(require 'yasnippet)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)

(evil-mode 1)
(setcdr evil-insert-state-map nil)
(define-key evil-insert-state-map [escape] 'evil-normal-state)

(global-evil-leader-mode)
(evil-leader/set-key
  "ff" 'find-file
  "fr" 'recentf-open-files
  "bb" 'switch-to-buffer
  "bk" 'kill-buffere
  "pf" 'counsel-git
  "ps" 'helm-do-ag-project-root
  "0" 'select-window-0
  "1" 'select-window-1
  "2" 'select-window-2
  "3" 'select-window-3
  "w/" 'split-window-right
  "w-" 'split-window-below
  ":" 'counsel-M-x
  "wm" 'delete-other-windows
  "qq" 'save-buffers-kill-terminal
  )


(window-numbering-mode 1)

(require 'evil-surround)
(global-evil-surround-mode 1)

(define-key evil-normal-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)
(define-key evil-visual-state-map (kbd ",/") 'evilnc-comment-or-uncomment-lines)

(evilnc-default-hotkeys)

(dolist (mode '(ag-mode
		flycheck-error-list-mode
		occur-mode
		git-rebase-mode))
  (add-to-list 'evil-emacs-state-modes mode))


  (add-hook 'occur-mode-hook
  (lambda ()
(evil-add-hjkl-bindings occur-mode-map 'emacs
(kbd "/") 'evil-search-forward
(kbd "n") 'evil-search-next
(kbd "N") 'evil-search-previous
(kbd "C-d") 'evil-scroll-down
(kbd "C-u") 'evil-scroll-up
)))

(which-key-mode 1)
(setq which-key-side-window-location 'right)

(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook
	  (lambda()
	    (set (make-local-variable 'company-backends) '((company-anaconda company-dabbrev-code) company-dabbrev))))

(provide 'init-packages)
