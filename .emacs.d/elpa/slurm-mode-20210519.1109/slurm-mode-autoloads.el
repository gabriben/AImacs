;;; slurm-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "slurm-mode" "slurm-mode.el" (0 0 0 0))
;;; Generated autoloads from slurm-mode.el

(let ((loads (get 'slurm 'custom-loads))) (if (member '"slurm-mode" loads) nil (put 'slurm 'custom-loads (cons '"slurm-mode" loads))))

(defvar slurm-display-help t "\
If non-nil, `slurm-mode' should display an help message at the top of the screen.")

(custom-autoload 'slurm-display-help "slurm-mode" t)

(defvar slurm-filter-user-at-start t "\
If non-nil, the jobs list is filtered by user at start.")

(custom-autoload 'slurm-filter-user-at-start "slurm-mode" t)

(defvar slurm-remote-host nil "\
Execute SLURM commands on this remote host.
It uses SSH rather than executing them directlySee also `slurm-remote-username' and `slurm-remote-ssh-cmd'.")

(custom-autoload 'slurm-remote-host "slurm-mode" t)

(defvar slurm-remote-username nil "\
Username to use for SSHing to the remote machine.
It is specified in `slurm-remote-host'.")

(custom-autoload 'slurm-remote-username "slurm-mode" t)

(defvar slurm-scancel-confirm t "\
If non-nil, ask for confirmation before cancelling a job.")

(custom-autoload 'slurm-scancel-confirm "slurm-mode" t)

(defvar slurm-squeue-format '((jobid 20 left) (partition 9 left) (name 37 left) (user 8 left) (st 2 left) (time 10 right) (nodes 4 right) (priority 4 right) (nodelist 40 left)) "\
List of fields to display in the jobs list.

Each entry in the list should be of the form:
  (FIELD WIDTH ALIGNMENT)
where:
FIELD is a symbol whose name corresponds to the column title in
      the squeue output.
WIDTH is an integer setting the column width.
ALIGN is either `left' or `right'.

`slurm-update-squeue-format' must be called after this variable
is changed to ensure the new value is used wherever necessary.")

(custom-autoload 'slurm-squeue-format "slurm-mode" nil)

(autoload 'slurm "slurm-mode" "\
Open a `slurm-mode' buffer to manage jobs.

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "slurm-mode" '("slurm-")))

;;;***

;;;### (autoloads nil "slurm-script-mode" "slurm-script-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from slurm-script-mode.el

(defvar slurm-script-directives-face 'slurm-script-directives "\
Face name to use for SBATCH directives in SLURM job submission scripts.")

(custom-autoload 'slurm-script-directives-face "slurm-script-mode" t)

(defface slurm-script-directives nil "\
Face to use for SBATCH directives in SLURM job submission scripts." :group (quote slurm))

(autoload 'slurm-script-mode "slurm-script-mode" "\
Edit SLURM job submission scripts.

When slurm-script-mode is on, SBATCH directives are highlighted.
This mode also provides a command to insert new SBATCH directives :
  \\<slurm-script-mode-map>
  \\[slurm-script-insert-directive] - `slurm-script-insert-directive'

\(fn &optional ARG)" t nil)

(defvar slurm-script-global-mode nil "\
Non-nil if Slurm-Script-Global mode is enabled.
See the `slurm-script-global-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `slurm-script-global-mode'.")

(custom-autoload 'slurm-script-global-mode "slurm-script-mode" nil)

(autoload 'slurm-script-global-mode "slurm-script-mode" "\
Toggle Slurm-Script mode in all buffers.
With prefix ARG, enable Slurm-Script-Global mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Slurm-Script mode is enabled in all buffers where
`(lambda nil (save-excursion (goto-char (point-min)) (when (slurm-search-directive (point-max)) (slurm-script-mode 1))))' would do it.
See `slurm-script-mode' for more information on Slurm-Script mode.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "slurm-script-mode" '("slurm-s")))

;;;***

;;;### (autoloads nil nil ("slurm-mode-pkg.el" "slurm-pkg.el") (0
;;;;;;  0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; slurm-mode-autoloads.el ends here
