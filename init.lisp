;;; SAMUEL'S STUMPWM CONFIG
(in-package :stumpwm)
; TODO
; [x] font size
; [x] background
; [x] transparency (compton?)
; [ ] program *top-map* bindings
; - [x] $EDITOR
; - [x] $BROWSER
; [x] lock (maybe ditch i3lock)
; [ ] tiling
; [x] SLIME connection
; [x] git repo
; [ ] gpu init/toggle
; [ ] scale inner gaps
; [ ] scale outer gaps
; [ ] scale fonts
; [ ] split to files

;; SERVER --------------------------------------------------------------------
; TODO: only open server if reserved port is free
(ql:quickload :swank)
(swank:create-server)

(defun restart-swank (port)
  (if (> 0 port) (swank:stop-server port))
  (ql:quickload :swank)
  (swank:start-server))

;;; EXTERNS --------------------------------------------------------------------
;; annotations
(run-shell-command "gromit-mpx")
;; the os
(run-shell-command "emacs --daemon")
;; alpha energy
(run-shell-command "compton")
;; flavour of the day
(run-shell-command "setbg ~/.config/wall.png")

(load "~/.stumpwm.d/visual.lisp")
(load "~/.stumpwm.d/command.lisp")
(load "~/.stumpwm.d/kbd.lisp")
