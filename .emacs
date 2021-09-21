;; Increase GC threshold to make init.el load faster
(defvar lunaryorn-default-gc-cons-threshold gc-cons-threshold)
(setq gc-cons-threshold 100000000)

(add-hook 'after-init-hook (lambda () (message "Time to load init file: %s"
                                               (emacs-init-time))))

;;;; mac specific

;; allow to use the right alt as a real alt key
(setq mac-right-option-modifier nil)
(setq ns-right-option-modifer 'super)

;; allow pdf latex for El-Capitan
(getenv "PATH")
(setenv "PATH"
        (concat
         "/Library/TeX/texbin/" ":"
         (getenv "PATH")))

;; allow the right paths to be used to other apps such as R, pandoc, etc.
(defun set-exec-path-from-shell-PATH ()
  "Sets the exec-path to the same value used by the user shell"
  (let ((path-from-shell
         (replace-regexp-in-string
          "[[:space:]\n]*$" ""
          (shell-command-to-string "$SHELL -l -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)

;;; Code:

;;;; install and load packages


(require 'package)
;; Any add to list for package-archives (to add marmalade or melpa) goes here
;; (add-to-list 'package-archives
;;              '("MELPA" .
;;                "http://melpa.milkbox.net/packages/"))
;; (package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(require 'use-package)

;; automatically refresh links before installing
(defun package-refresh-then-install ()
  "Refreshes packages and then calls `package-install'."
  (interactive)
  (package-refresh-contents)
  (call-interactively 'package-install))

;;;; Help with programming in elm
(require 'elm-mode)

;;;; Allow programming in R

(require 'ess-site)

;; (use-package ess
;;   :ensure t
;;   :init (require 'ess-site))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)))

;;;; Allow programming in Stan

(require 'stan-mode)


(setq-default inferior-R-program-name "/usr/local/bin/R")

;;;; better python integration

;; (elpy-enable)

(setq python-shell-interpreter "/Library/Frameworks/Python.framework/Versions/3.8/bin/ipython"
      python-shell-interpreter-args "-i --simple-prompt" ;; --pprint
      python-shell-prompt-detect-failure-warning nil)

;; (setq python-shell-interpreter "/ivi/ilps/projects/TREC_Fair_2021/anaconda3/bin/ipython"
;;       python-shell-interpreter-args "-i --simple-prompt" ;; --pprint
;;       python-shell-prompt-detect-failure-warning nil) ;; /ssh:ilps-h1.science.uva.nl:

;; run line or selection
(defun my-python-send-region (&optional beg end)
  (interactive)
  (let ((beg (cond (beg beg)
                   ((region-active-p)
                    (region-beginning))
                   (t (line-beginning-position))))
        (end (cond (end end)
                   ((region-active-p)
                    (copy-marker (region-end)))
                   (t (line-end-position)))))
    (python-shell-send-string (buffer-substring-no-properties beg end)))
  (deactivate-mark) (back-to-indentation) (next-line)
  )

;; python-shell-send-region
;; string

(global-set-key (kbd "M-RET") (lambda () (interactive) (my-python-send-region)))


;; (defun python-shell-append-to-output (string)
;;   (let ((buffer (current-buffer)))
;;     (set-buffer (process-buffer (python-shell-get-process)))
;;     (let ((oldpoint (point)))
;;       (goto-char (process-mark (python-shell-get-process)))
;;       (insert string)
;;       (set-marker (process-mark (python-shell-get-process)) (point))
;;       (goto-char oldpoint))
;;     (set-buffer buffer)))

;; (defadvice python-shell-send-string
;;     (around advice-python-shell-send-string activate)
;;   (interactive)
;;   (let* ((append-string1
;;          (if (string-match "import codecs, os;__pyfile = codecs.open.*$" string)
;;              (replace-match "" nil nil string)
;;            string))
;;         (append-string2
;;          (if (string-match "^# -\\*- coding: utf-8 -\\*-\n*$" append-string1)
;;              (replace-match "" nil nil append-string1)
;;            append-string1))
;;         (append-string
;;          (if (string-match "^\n*$" append-string2)
;;              (replace-match "" nil nil append-string2)
;;            append-string2)))  
;;     (python-shell-append-to-output
;;      (concat (string-trim-right append-string) "\n")))
;;   (if (called-interactively-p 'any)
;;       (call-interactively (ad-get-orig-definition 'python-shell-send-string))
;;     ad-do-it))

;; (eval-after-load "python"
;;   '(define-key python-mode-map [(control c)(kbd "RET")] 'my-python-send-region))

;; (define-key python-mode-map [(control c)(kbd "RET")] 'my-python-shell-send-region)

;; (add-hook 'python-mode-hook
;;           (lambda () (interactive) (local-set-key (kbd "<C-return>") #'my-python-send-region)))

;; (add-hook 'python-mode-hook 'anaconda-mode)
;; (setq python-shell-interpreter "python3")
;; (setenv "PATH"
;;         (concat
;;          "/usr/bin/" ":"
;;          (getenv "PATH")))

;; (Setq python-shell-interpreter "ipython3"
;;       python-shell-interpreter-args "--simple-prompt -c exec('__import__(\\'readline\\')') -i --pprint")

;; (setq python-shell-interpreter "ipython"
;;       python-shell-interpreter-args "--simple-prompt -c exec('__import__(\\'readline\\')') -i")

;; enable C-RET for running
;; (eval-after-load "python"
;;   '(define-key python-mode-map [(control c)(kbd "RET")] 'python-shell-send-region))

;; eval current line under cursor (not working)
;; (defun get-current-line ()
;;   (buffer-substring-no-properties (line-beginning-position)
;;                                   (line-end-position)))
;; (defun run-python-command (str)
;;   (shell-command-to-string
;;    (concat "/usr/bin/env python -u -m sfPP -c "
;;            (shell-quote-argument (concat "print(" str ")")))))
;; (defun eval-line-in-python ()
;;   "Evaluates the current line in python, then copies the result to the clipboard."
;;   (interactive)
;;   (let ((str (run-python-command (get-current-line))))
;;     (message str)
;;     (kill-new str)))

;; (defun run-python-command (str)
;;   (shell-command-to-string
;;    (concat "/usr/bin python3 -u -m sfPP -c "
;;            (shell-quote-argument (concat "print(" str ")")))))

;; follow end of buffer when running (not working)
;; (let ((buf (get-buffer "*Python*")))
;;   (set-window-point (get-buffer-window buf) (buffer-size buf)))

;; (process-id (get-buffer-process "*Python*"))

;; (defun shell-process-running-child-p (process-name)
;;   (interactive)
;;   (if (process-running-child-p process-name)
;;       (print t)
;;     (print nil)))


;; send whole line under cursor to python (doesn't work perfectly)

;; (defun block-line-end ()
;;   (setq indentation (current-indentation))
;;   (forward-line)
;;   (while (> (current-indentation) indentation)
;;     (forward-line))
;;   (forward-line -1)
;;   (line-end-position))
;; (defun my-python-shell-send-region (&optional beg end)
;;   (interactive)
;;   (let ((beg (cond (beg beg)
;;                    ((region-active-p) (region-beginning))
;;                    (t (line-beginning-position))))
;;         (end (cond (end end)
;;                    ((region-active-p) 
;;                     (copy-marker (region-end)))
;;                    (t (block-line-end)))))
;;     (python-shell-send-region beg end))
;;   (forward-line))

;; (eval-after-load "python"
;;   '(define-key python-mode-map [(control c)(kbd "RET")] 'my-python-shell-send-region))

;; (add-hook 'python-mode-hook 'jedi:setup)
;; (setq jedi:complete-on-dot t)

;; (defvar myPackages
;;   '(better-defaults
;;     elpy ;; add the elpy package
;;     material-theme))

;; r markdown mode
; requires brew install markdown and brew install pandoc


(setq load-path
      (append '("/Users/gabrielbenedict/.emacs.d/elpa/polymode-20180912.1854/")
              load-path))

(require 'poly-markdown)
(require 'poly-R)
;; (require poly-ein-polymode)

;;;; matlab mode
; http://gewhere.github.io/blog/2017/12/19/setup-matlab-in-emacs-and-babel-orgmode/

(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
(add-to-list
 'auto-mode-alist
 '("\\.m$" . matlab-mode))
(setq matlab-indent-function t)
(setq matlab-shell-command "matlab")
(setq matlab-shell-command "/Applications/MATLAB_R2019a.app/bin/matlab")
(customize-set-variable 'matlab-shell-command "~/bin/matlab_emacs_wrapper.sh")

;; setup matlab in babel
(setq org-babel-default-header-args:matlab
      '((:results . "output") (:session . "*MATLAB*")))

;; list of babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((matlab . t)
   ))

;; (define-key matlab-mode-map (kbd "<C-return>") 'matlab-shell-run-region-or-line)
;; (define-key matlab-mode (kbd "<C-S-return>") 'matlab-shell-run-cell)

(when (fboundp 'matlab-mode)

  (defun my-matlab-config ()
    "For use in `matlab-mode-hook'."
    (local-set-key  (kbd "<C-return>") 'matlab-shell-run-region-or-line)
    ;; more stuff here
    )

  (add-hook 'matlab-mode-hook 'my-matlab-config)

  ;; (add-hook 'before-save-hook 'gofmt-before-save)
  )


;;;; org-mode

;; MESSES UP WITH PACKAGE-INSTALL
;; (setq package-load-list
;;       '((org-plus-contrib t)))

;; install org-mode
;; (add-to-list 'package-archives
;;              '("org" . "http://orgmode.org/elpa/") t)
;; (package-install 'org-plus-contrib)

;;(require 'package)
;;(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
;;(package-initialize)
;;(require 'org-checklist)

;; nice support for bibtex
(require 'org-ref)
;; (setq org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f"))
(global-set-key (kbd "C-c c") 'org-ref-helm-insert-cite-link)
(global-set-key (kbd "C-c c") 'helm-bibtex)

(autoload 'helm-bibtex "helm-bibtex" "" t)
(setq bibtex-completion-bibliography
      '("/Users/gabrielbenedict/Google_Drive/docs/Jobs/Work Experience/Bertelsmann/UVA/research topics/trailerPersonalisation/multilabel/references.bib"))

(setq bibtex-completion-library-path '("/Users/gabrielbenedict/Google_Drive/docs/Jobs/Work Experience/Bertelsmann/UVA/research topics/trailerPersonalisation/multilabel/references/multilabel"))

(setq bibtex-completion-pdf-symbol "⌘")
(setq bibtex-completion-notes-symbol "✎")

;; ;; org to coloured text in latex
;; (require 'org-colored-text)

;; ;; Taken and adapted from org-colored-text
;; (org-add-link-type
;;  "color"
;;  (lambda (path)
;;    "No follow action.")
;;  (lambda (color description backend)
;;    (cond
;;     ((eq backend 'latex)                  ; added by TL
;;      (format "{\\color{%s}%s}" color description)) ; added by TL
;;     ((eq backend 'html)
;;      (let ((rgb (assoc color color-name-rgb-alist))
;;            r g b)
;;        (if rgb
;;            (progn
;;              (setq r (* 255 (/ (nth 1 rgb) 65535.0))
;;                    g (* 255 (/ (nth 2 rgb) 65535.0))
;;                    b (* 255 (/ (nth 3 rgb) 65535.0)))
;;              (format "<span style=\"color: rgb(%s,%s,%s)\">%s</span>"
;;                      (truncate r) (truncate g) (truncate b)
;;                      (or description color)))
;;          (format "No Color RGB for %s" color)))))))

;; bullets for titles
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; allow shift select in org mode
(setq shift-select-mode t)
(setq org-support-shift-select t)

;; highlighting latex in orgmode NOT WORKING
(eval-after-load 'org
  '(setf org-highlight-latex-and-related '(latex)))

;; show in-line images
(defun do-org-show-all-inline-images ()
  (interactive)
  (org-display-inline-images t t))
(global-set-key (kbd "C-c C-x C v")
                'do-org-show-all-inline-images)
(setq org-image-actual-width (/ (display-pixel-width) 3))

;; get the right scientific notation for org to latex
(setq org-latex-table-scientific-notation nil)

;; colour coding in org
;; (setq org-src-fontify-natively t
;;       org-src-preserve-indentation t
;;       org-src-tab-acts-natively t)

;; colour coding R output
(require 'ox-latex)
;; requires sudo apt-get install python-pygments
(setq org-latex-prefer-user-labels t)
(setq org-latex-listings 'minted
      org-latex-packages-alist '(("" "minted"))
      ;; modify margins in TeX generated from org-mode (not working)
;org-latex-packages-alist '(("margin=2cm" "geometry" nil))
      org-latex-minted-options
      '(("bgcolor" "lightgray")
        ("fontsize" "\\scriptsize"))
      ;; org-latex-packages-alist '(("" "color"))
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "latexmk -shell-escape -bibtex -f -pdf %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

;; (setq org-latex-pdf-process (quote ("texi2dvi -p -b -V %f")))
;; (setq org-latex-pdf-process 
;;       "latexmk -pdflatex='lualatex -shell-escape -interaction nonstopmode' -pdf -f  %f")
;; (setq org-latex-pdf-process (quote ("texi2dvi -shell-escape --pdf --clean --verbose
;; --batch %f" "bibtex %b" "texi2dvi --pdf --clean --verbose --batch %f"
;; "texi2dvi --pdf --clean --verbose --batch %f")))
;; (setq org-latex-pdf-process (list "latexmk -pdf %f"))

(add-to-list 'org-latex-minted-langs '(R "r"))
; tricking emacs to allow colour coding of a script appendix with noweb
(add-to-list 'org-latex-minted-langs '(text "r"))

;; Compile org file to latex, then to pdf and open the pdf
(setq org-confirm-babel-evaluate nil)
(setq ess-ask-for-ess-directory nil)
(fset 'org-latex-pdf
      [?\C-c ?\C-e ?l ?o])

;; allow for other latex classes
(add-to-list 'org-latex-classes
         '("letter"
       "\\documentclass{letter}"
       ("\\section{%s}" . "\\section*{%s}")
       ("\\subsection{%s}" . "\\subsection*{%s}")
       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

(add-to-list 'org-latex-classes '("acmart" "\\documentclass{acmart}"
                                  ("\\section{%s}" . "\\section*{%s}")
                                  ("\\subsection{%s}" . "\\subsection*{%s}")
                                  ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

;; todo in red
;; https://stackoverflow.com/questions/36197545/org-mode-latex-export-making-todos-red
(defun org-latex-format-headline-colored-keywords-function
    (todo todo-type priority text tags info)
        (concat
           (cond ((string= todo "TODO")(and todo (format "{\\color{red}\\bfseries\\sffamily %s} " todo)))
   ((string= todo "DONE")(and todo (format "{\\color{green}\\bfseries\\sffamily %s} " todo))))
            (and priority (format "\\framebox{\\#%c} " priority))
            text
            (and tags
            (format "\\hfill{}\\textsc{%s}"
    (mapconcat (lambda (tag) (org-latex-plain-text tag info))
           tags ":")))))

(setq org-latex-format-headline-function 'org-latex-format-headline-colored-keywords-function)

;; AUCTeX
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil) ; detect main.tex


;; on linux
;;(fset 'org-latex-pdf
;; [?\C-c ?\C-e ?l ?o])

(global-set-key (kbd "M-n") 'org-latex-pdf)

;; display all pages of pdf preview by scrolling
(setq doc-view-continuous t)

;; pdfview is supposed to be better than the base pdf viewer (can't make it work
;; though)
;; (eval-after-load 'org '(require 'org-pdfview))

;; (add-to-list 'org-file-apps
;;              '("\\.pdf\\'" . (lambda (file link)
;;                                      (org-pdfview-open link))))

(setq default-directory "~/")

;;;; spellchecking and syntax highlighting

;; check for spelling mistakes, requires the installation of aspell
;; (aspell is generally, built in most machines)
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))

;; Detect too long lines (not working)
(require 'whitespace)
(setq whitespace-line-column 800) ;; limit line length
(setq whitespace-style '(face lines-tail))
(add-hook 'prog-mode-hook 'whitespace-mode)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-line ((t (:foreground "firebrick4")))))

;; Flycheck: On the fly syntax checking (not working)
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
; stronger error display
(defface flycheck-error
  '((t (:foreground "red" :underline (:color "Red1" :style wave) :weight bold)))
  "Flycheck face for errors"
  :group "flycheck")

; syntax highlighting everywhere
(global-font-lock-mode 1)

;; autocomplete but not on buffer
;; (require 'auto-complete)
;; (global-auto-complete-mode 1)
;; (defun auto-complete-mode-maybe ()
;;   "No maybe for you. Only AC!"
;;   (unless (minibufferp (current-buffer))
;;     (auto-complete-mode 1)))

;; tabnine
(use-package company-tabnine :ensure t)
(add-to-list 'company-backends #'company-tabnine)
(setq company-idle-delay 0) ; Trigger completion immediately.
(setq company-show-numbers t) ; Number the candidates (use M-1, M-2 etc to select completions).

;; get synonyms (not working)
;(require 'synosaurus)
;(synosaurus-mode)

;;;; visual aspects

;; allow undo (‘C-c left’) and redo (‘C-c right’) actions on windows
(when (fboundp 'winner-mode)
      (winner-mode 1))

;; (spinner-start 'vertical-breathing 10)

;; concentrate on one buffer with big margins

;; striped buffer
(add-hook 'dired-mode-hook 'turn-on-stripe-buffer-mode)

;;; dired

;; Auto refresh buffers
(global-auto-revert-mode 1)

;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

;; ;; golden ratio buffer sizes
;; (require 'golden-ratio)

;; font theme (change theme with M-x load-theme)
;; (add-to-list 'custom-theme-load-path " ~/.emacs.d/elpa/leuven-theme-20190831.1008/")
;; (load-theme 'leuven t) ;; 't t' gives silent loading
;; (enable-theme 'leuven)

(add-hook 'emacs-startup-hook
  (lambda ()
    (load-theme 'leuven-dark)
    ))

;; (load-theme 'leuven t)
;; (load-theme 'leuven-dark t)

;; display line numbers in current buffer
(global-set-key (kbd "<C-c C-l>")  'display-line-numbers-mode)

;; the toolbar is just a waste of valuable screen estate
;; in a tty tool-bar-mode does not properly auto-load, and is
;; already disabled anyway
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

;; disable the scroll bar
;; (scroll-bar-mode 0)

;; speedbar doesn't work
;; (require 'sr-speedbar)
;; (global-set-key (kbd "C-1") 'sr-speedbar-toggle)


;; move from window to window with meta + super + arrow keys
(global-set-key (kbd "<M-s-left>")  'windmove-left)
(global-set-key (kbd "<M-s-right>") 'windmove-right)
(global-set-key (kbd "<M-s-up>")    'windmove-up)
(global-set-key (kbd "<M-s-down>")  'windmove-down)

;; switch cursor to new window
(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

;; create new windows vertically by default
(split-window-right)

; Add proper word wrapping
(global-visual-line-mode t)

;; line wrapping at window with indicators
(global-visual-line-mode t)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))

;; simple modeline
(setq-default mode-line-format
              '(list mode-line-modified
                     mode-line-buffer-identification
                     mode-line-remote))
;; '(:eval (cond (buffer-read-only "%* ")
;;               ((buffer-modified-p) "❉ ") ; ❉ is nice for fonts which support it, * suffices otherwise
;;               (t "  ")))))

;; (setq-default mode-line-format
;;               '((:eval
;;                  (cond
;;                   (buffer-read-only
;;                    (propertize " ⚑ "
;;                                'face '(:foreground "red" :weight 'bold)
;;                                'help-echo "buffer is read-only!!!"))
;;                   ((buffer-modified-p)
;;                    (propertize " ☡ "
;;                                'face '(:foreground "orange")
;;                                'help-echo "buffer modified."))))
;;                 (:eval (if (memq (buffer-local-value 'major-mode (current-buffer))
;;                                  '(ruby-mode enh-ruby-mode))
;;                            (propertize "Ruby" 'face '(:foreground "green"))
;;                          (propertize "Not Ruby" 'face '(:foreground "orange")))))) 

;; change the cursor to a line and stop blinking
(setq-default cursor-type 'bar)
(blink-cursor-mode -1)

;; remember the cursor position of files when reopening them
(setq save-place-file "~/.emacs.d/saveplace")
(setq-default save-place t)
(require 'saveplace)

;; stopped here

;; Show column number on the bottom status bar. (doesnt work)
(require 'fill-column-indicator)

;; smooth scrolling
;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 3)))
;; one line at a time (faster when holding shift)
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; replace highlighted text with what I type
(delete-selection-mode 1)

;; highlight matched parentheses
(require 'paren)
(setq show-paren-style 'parenthesis)
(show-paren-mode +1)

;; hide warnings
(setq warning-minimum-level :emergency)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; M-arrows to select to begin / end of line
(cond

; Microsoft Windows
 ((string-equal system-type "windows-nt") 
  (progn
    (global-set-key (kbd "M-<left>") 'move-beginning-of-line)
    (global-set-key (kbd "M-<right>") 'move-end-of-line)))

; Mac OS X
 ((string-equal system-type "darwin") 
  (progn
    (global-set-key (kbd "s-<left>") 'move-beginning-of-line)
    (global-set-key (kbd "s-<right>") 'move-end-of-line)
    (global-set-key (kbd "s-<up>") 'backward-paragraph)
    (global-set-key (kbd "s-<down>") 'forward-paragraph)))

; linux
 ((string-equal system-type "gnu/linux") 
  (progn
    (global-set-key (kbd "M-<left>") 'move-beginning-of-line)
    (global-set-key (kbd "M-<right>") 'move-end-of-line)))
 )

;; display useful information in the frame title
(setq-default frame-title-format '("%f"))

;; blink instead of beeping
(setq visible-bell nil
      ring-bell-function 'flash-mode-line)
(defun flash-mode-line ()
  (invert-face 'mode-line)
  (run-with-timer 0.2 nil #'invert-face 'mode-line))


;;;; Indentation and spacing

;; auto-indent all my code
;; (global-set-key (kbd "<?\\t>") 'indent-code-rigidly)

;; stop indenting comments weirdly in lisp
(defun foo () (setq comment-indent-function (lambda () 0)))
(add-hook 'emacs-lisp-mode-hook 'foo 'APPEND)

;; Tabs yields 2 spaces, use tab key to tab
; force it everywhere
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default js2-basic-offset 2)
(setq ess-default-style 'DEFAULT)
(add-hook 'sh-mode-hook
          (lambda ()
            (setq sh-basic-offset 2
                  sh-indentation 2)))
(setq ess-indent-level 2)

;; ;; automatic tabs
;; (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
;; (add-hook 'css-mode-hook #'aggressive-indent-mode)
;; (add-hook 'python-mode-hook #'aggressive-indent-mode)
;; (global-aggressive-indent-mode 1)
;; (add-to-list 'aggressive-indent-excluded-modes 'html-mode 'buffer-mode)

;; automatic spacing in R
(add-hook 'ess-mode-hook #'electric-operator-mode)


;;;; RStudio style

;; object navigator for R ("v" for values, "p" for plot and "d" to delete)
(autoload 'ess-rdired "ess-rdired"
  "View *R* objects in a dired-like buffer." t)
(global-set-key (kbd "C-0") 'ess-rdired)


;;;; auto-completion

;; completion help for everything in the command line
(ido-mode 1)
(ido-everywhere 1)
(require 'ido-completing-read+)
(ido-ubiquitous-mode 1)


;;;; versioning

;; magit
(global-set-key (kbd "C-x g") 'magit-status)

;;forge to allow for github/gitlab
(use-package forge
  :after magit)

;; backups
(setq backup-directory-alist `(("." . "~/.saves"))) ; setup backup folder
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; save session for reopen
;(require 'desktop)
(desktop-save-mode 1)

;; save minibuffer history
(savehist-mode 1)

; save the current macro as reusable function.
(defun save-current-kbd-macro-to-dot-emacs (name)
  "Save the current macro as named function definition inside
your initialization file so you can reuse it anytime in the
future."
  (interactive "SSave Macro as: ")
  (name-last-kbd-macro name)
  (save-excursion
    (find-file-literally user-init-file)
    (goto-char (point-max))
    (insert "\n\n;; Saved macro\n")
    (insert-kbd-macro name)
    (insert "\n")))

; rename file in buffer
(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let* ((name (buffer-name))
         (filename (buffer-file-name))
         (basename (file-name-nondirectory filename)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " (file-name-directory filename) basename nil basename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

;;;; SSH

(require 'tramp)
(custom-set-variables
 '(tramp-remote-path (quote (tramp-own-remote-path)) nil (tramp)))
;; (setq 'tramp-remote-path "/home/yz555/anaconda2/envs/gab3/bin/")


;; UVA
(add-to-list 'tramp-remote-path "/home/yz555/anaconda2/envs/gab3/bin/")
(add-to-list 'tramp-remote-path "/ivi/ilps/projects/TREC_Fair_2021/anaconda3/bin/")


;; (add-to-list 'tramp-remote-path 'tramp-own-remote-path)

;; (setq python-shell-interpreter "python3.6"
;;       python-shell-interpreter-args "-u")

;; (setq python-shell-interpreter "python3.8"
;;       python-shell-interpreter-args ""
;;       python-shell-prompt-detect-failure-warning nil)
      ;; python-shell-prompt-detect-failure-warning nil)

;; (add-hook 'python-mode-hook
;;           (lambda () (interactive) (local-set-key (kbd "<C-return>") #'my-python-send-region)))

;; (eval-after-load 'python 
;;                     '(define-key python-mode-map [(control c)(kbd "RET")] 'my-python-send-region))

;; (add-hook 'python-mode-hook
;;           (lambda () (interactive) (define-key python-mode-map (kbd "<C-return>") 'my-python-send-region)))

;; (add-hook 'python-mode-hook
;;      '(lambda () (interactive) (define-key python-mode-map "<C-return>" 'my-python-send-region)))


(setq desktop-buffers-not-to-save "^$")

;; (add-to-list 'tramp-own-remote-path "/home/yz555/anaconda2/envs/gab3/bin/python3.6")
;; (car tramp-own-remote-path)

;; (setq python-shell-interpreter "/home/yz555/anaconda2/bin/python")
;; (getenv "PATH")

;; (setenv "PATH"
;;         (concat
;;          "/ssh:yz555@login-gpu.hpc.cam.ac.uk:/home/yz555/anaconda2/bin/" ":"
;;          (getenv "PATH")))

;; (setq python-shell-interpreter "ipython"
;;       python-shell-interpreter-args "-i --simple-prompt")
;;       python-shell-interpreter-args "-u")

;; (setq python-shell-interpreter "/ssh:yz555@login-gpu.hpc.cam.ac.uk:/home/yz555/anaconda2/bin/python")
;; (add-to-list 'tramp-remote-path "/home/yz555/anaconda2/bin/python")

;; (setq python-shell-interpreter "/miniconda2/bin/remote-python")
;; python-shell-interpreter-args "-i --simple-prompt")

;; (setq python-shell-interpreter "~/anaconda2/bin/python")


;;;; Miscellanous

;; newsletter
(add-to-list 'newsticker-url-list '("ACM-tech-news"
                                 "https://kill-the-newsletter.com/feeds/5097m2e1cy24h6fu.xml"))


;; open docx as html files and render
(load-library "shr.el")

(defun docx2html (file) 
  "Convert FILE to html in a buffer and display it." 
  (interactive "f") 
  (let ((html-buffer (format "*%s --> html*" file))) 
    (call-process "pandoc" nil `(,html-buffer nil) nil "--to=html" (expand-file-name file)) 
    (switch-to-buffer html-buffer)
    (shr-render-buffer html-buffer)) 
  ) 

;; work on SLURM
(add-to-list 'load-path "/path/to/slurm.el")
(require 'slurm-mode)
(require 'slurm-script-mode)

;; show unused key bindings
(require 'free-keys)

;; find and replace dynamically with C-;
(require 'iedit)

(use-package csv-mode)
;;   :mode ("\\.csv$" . csv-mode))

(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(bind-keys ("M-<up>" . move-line-up)
           ("M-<down>" . move-line-down))

;;;; delete?

(add-hook 'rmail-show-message-hook 'icalendar-import-buffer)

;; fontify code in code blocks
(setq org-src-fontify-natively t)

(comint-redirect-send-command "s()\n"  (get-buffer-create "*svg output*") nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3" "DeepSkyBlue" "gray50"])
 '(custom-safe-themes
   (quote
    ("1dd7b369ab51f00e91b6a990634017916e7bdeb64002b4dda0d7a618785725ac" default)))
 '(matlab-shell-command "~/bin/matlab_emacs_wrapper.sh")
 '(package-selected-packages
   (quote
    (underwater-theme diffview yasnippet use-package stan-mode sr-speedbar spacemacs-theme pyvenv polymode org-ref org-plus-contrib org-pdfview org-link-minor-mode org-bullets matlab-mode julia-mode iedit ido-completing-read+ highlight-indentation free-keys flycheck find-file-in-project fill-column-indicator darktooth-theme csv-mode company auto-complete aggressive-indent))))
