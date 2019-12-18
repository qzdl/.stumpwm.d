;;; SAMUEL'S STUMPWM CONFIG
(in-package :stumpwm)
;;;; TODO
; [x] font size
; [x] background
; [x] transparency (compton?)
; [ ] program *top-map* bindings
; - [ ] $EDITOR
; - [ ] $BROWSER
; [ ] lock (maybe ditch i3lock)
; [ ] tiling
; [x] SLIME connection
; [ ] git repo
; [ ] gpu init



(ql:quickload :clx-truetype)
(load-module "ttf-fonts")
(load-module "swm-gaps")

(defun restore-default-font-dir ()
  "Restores clx-truetype:*font-dirs* to original paths"
  (setq clx-truetype::*font-dirs* '("/usr/share/fonts")))

(defun add-font-dir (font)
  "Add a subdir to clx-truetype:*font-dirs*, qualifying `*.tff`s
/usr/share/fonts/ (default) is seemingly not sufficient, as subdirs
  for each font aren't recursed into. For example, the Liberation Mono
  family lives in '/usr/share/fonts/Liberation', and isn't found unless
  that path is in clx-truetype:*font-dirs*.

While it would be nice to look at the root cause of the issue in :clx-truetype,
  this workaround is okay for my purposes.

Refreshes font cache & returns updated values"
  (setq clx-truetype::*font-dirs*
        (append (list(namestring (concat "/usr/share/fonts/" font "/")))
                      clx-truetype::*font-dirs*))
  (xft:cache-fonts)
  clx-truetype:*font-dirs*)

(restore-default-font-dir)
(add-font-dir "Liberation")
(defvar font-size 13)
(set-font (make-instance 'xft:font
                          :family "Liberation Mono"
                          :subfamily "Bold"
                          :size font-size))


;;; protecc and SERVE
(ql:quickload :swank)
(swank:create-server)


(defun restart-swank (port)
  (if (> 0 port) (swank:stop-server port))
  (ql:quickload :swank)
  (swank:start-server))


;; COMMANDS --------------------------------------------------------------------
; doesn't seem to work through "run-shell-command"
(defcommand lock () ()
  "A command to lock the DE with corrupted screen
Pause PMC, remove tmp screenshot, capture new frame,
corrupt capture,invoke lock with output

Every instance of `run-shell-command awaits output "
  (run-shell-command "mpc pause" t)
  (run-shell-command "pauseallmpv" t)
  (run-shell-command "rm -f /tmp/screenshot.png /tmp/out.png" t)
  (run-shell-command "scrot /tmp/screenshot.png" t)
  (run-shell-command "~/git/corrupter/corrupter /tmp/screenshot.png /tmp/out.png" t)
  (run-shell-command "i3lock -i /tmp/out.png" t))


(defcommand vol-down () ()
  "Volume down through lmc
TODO: Make interactive"
  (run-shell-command "lmc down 5"))

(defcommand vol-up () ()
  "Volume up through lmc
TODO: Make interactive"
  (run-shell-command "lmc up 5"))

(defcommand run-or-raise-terminal () ()
  "Opens the system terminal, as exported in ~/.profile"
  (run-or-raise (getenv "TERMINAL") '()))

(defcommand run-or-raise-browser () ()
  "Opens the system browser, as exported in ~/.profile"
    (run-or-raise (getenv "BROWSER") '()))

(defun run-shell-command-no-startup (command)
  (run-shell-command (concat "exec --no-startup-id " command)))

;;; KEYMAPS --------------------------------------------------------------------
(defun show-key-seq (key seq val)
  "Shows the currently active key sequence if in a map
e.g. s-t OR C-t"
  (message (print-key-seq (reverse seq))))
(add-hook *key-press-hook* 'show-key-seq)

;;X86
(define-keysym #x1008ff11 "XF86AudioLowerVolume")
(define-keysym #x1008ff12 "XF86AudioMute")
(define-keysym #x1008ff13 "XF86AudioRaiseVolume")

;; TOGGLE
(defvar *toggle-map* (make-sparse-keymap))
(define-key *top-map* (kbd "s-t") '*toggle-map*)
(define-key *toggle-map* (kbd "g") "toggle-gaps")
;; SUPER

(define-key *top-map* (kbd "s-e") "emacs")
(define-key *top-map* (kbd "s-w") "run-or-raise-browser")
(define-key *top-map* (kbd "s-RET") "run-or-raise-terminal")

(define-key *top-map* (kbd "s-h") "move-focus left")
(define-key *top-map* (kbd "s-j") "move-focus down")
(define-key *top-map* (kbd "s-k") "move-focus up")
(define-key *top-map* (kbd "s-l") "move-focus right")
(define-key *top-map* (kbd "s-H") "move-window left")
(define-key *top-map* (kbd "s-J") "move-window down")
(define-key *top-map* (kbd "s-K") "move-window up")
(define-key *top-map* (kbd "s-L") "move-window right")
(define-key *top-map* (kbd "s-n") "pull-hidden-next")
(define-key *top-map* (kbd "s-p") "pull-hidden-previous")
(define-key *top-map* (kbd "s-g") "abort")

(define-key *top-map* (kbd "s-=") "vol-up")
(define-key *top-map* (kbd "s--") "vol-down")
;; dmenu WHO
(define-key *top-map* (kbd "s-d") "exec")
(define-key *top-map* (kbd "s-D") "eval")
(define-key *top-map* (kbd "s-b") "banish")
(define-key *top-map* (kbd "s-ESC") "quit")
(define-key *top-map* (kbd "s-x") "lock")


;;; EXTERNS --------------------------------------------------------------------
(run-shell-command "emacs --daemon")
(run-shell-command "compton")
(run-shell-command "setbg ~/.config/wall.png")
(load "~/.stumpwm.d/visual.lisp")

(setf swm-gaps:*inner-gaps-size* 15
      swm-gaps:*outer-gaps-size* 15
      swm-gaps:*head-gaps-size* 15)

(setf *message-window-gravity* :center
      *input-window-gravity* :center
      *window-border-style* :thin
      *message-window-padding* 10
      *maxsize-border-width* 5
      *normal-border-width* 5
      *transient-border-width* 2
      stumpwm::*float-window-border* 2
      stumpwm::*float-window-title-height* 5
      *mouse-focus-policy* :click)
