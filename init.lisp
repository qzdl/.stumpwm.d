;;; SAMUEL'S STUMPWM CONFIG
(in-package :stumpwm)
; TODO
; [x] font size
; [x] background
; [x] transparency (compton?)
; [x] program *top-map* bindings
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
; [x] split to files
; [ ] shuffle background & wal cmd/bind

;; SERVER --------------------------------------------------------------------
; TODO: only open server if reserved port is free
(ql:quickload :slynk)
(slynk:create-server :port 4005)

;;; EXTERNS --------------------------------------------------------------------
;; the os
(run-shell-command "emacs --daemon")
;; alpha energy compositing
(run-shell-command "compton")
;; less sucky notifs
(run-shell-command "dunst")
;; hide the mouse for inactivity
(run-shell-command "unclutter")
;; annotations
(run-shell-command "gromit-mpx")
;; flavour of the day
(run-shell-command "setbg ~/.config/wall.png")
; (run-shell-command "wal -i ~/config/wall.png")
; (run-shell-command "wal -w")

(load "~/.stumpwm.d/visual.lisp")
(load "~/.stumpwm.d/command.lisp")
(load "~/.stumpwm.d/kbd.lisp")

;; DEBUG
;; (setq *debug-level* 2)
;; (redirect-all-output (data-dir-file "debug-output" "txt"))
