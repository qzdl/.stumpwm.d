;;; SAMUEL'S STUMPWM CONFIG ::: Key Binds
(in-package :stumpwm)

;;; PREFIX, EOU
; These bindings underpin the keyboard interaction inside stumpwm.

(set-prefix-key (kbd "s-SPC"))
(defun show-key-seq (key seq val)
  "Shows the currently active key sequence if in a map
e.g. s-t OR s-f"
  (message (print-key-seq (reverse seq))))
(add-hook *key-press-hook* 'show-key-seq)

;;X86
(define-keysym #x1008ff11 "XF86AudioLowerVolume")
(define-keysym #x1008ff12 "XF86AudioMute")
(define-keysym #x1008ff13 "XF86AudioRaiseVolume")

(defun expand-map (name bindings)
  (loop for bind in bindings
        for key = (first bind)
        for cmd = (second bind)
        collect `(define-key ,name (kbd ,key) ,cmd)))

(defmacro extmap (name bindings)
  `(let ((_ "")) ; lambda macro?
     ,@(expand-map name bindings)))

(defmacro defmap (name bindings)
  `(setq ,name
      (let ((m (make-sparse-keymap)))
        ,@(expand-map 'm bindings)
        m)))

(extmap *top-map*
    ( ;; MAPS
     ("s-o" '*application-map*)
     ("s-b" '*bluetooth-map*)
     ("s-t" '*toggle-cmds*)
     ("s-f" '*frame-cmds*)
     ("s-g" '*groups-map*)

     ;; QUALITY OF LIFE
     ("s-?" "show-top-map")
     ("s-RET" "terminal")
     ("s-:" "colon")  ; command mode
     ("s-;" "exec")   ; shell exec
     ("s-M-;" "eval") ; cl eval

     ("s-F2" "redisplay")
     ("s-F8" "select-display")
     ("s-F9" "search") ;; TODO: port

     ;; bindsym Print               exec --no-startup-id maimpick
     ;; bindsym Shift+Print         exec --no-startup-id maim ~/screenshots/pic-full-"$(date '+%y%m%d-%H%M-%S').png"
     ;; bindsym $mod+Print          exec --no-startup-id dmenurecord
     ;; bindsym $mod+Scroll_Lock    exec --no-startup-id "killall screenkey || screenkey"
     ;; bindsym $mod+Delete         exec $stoprec
     ;; bindsym XF86Launch1         exec --no-startup-id xset dpms force off
     ;; RECORDING
     ("SunPrint_Screen" "screenpick") ; printscr ;; TODO: port
     ("Sys_Req" "screennow")          ; SHIFT ^  ;; TODO: port
     ("s-SunPrint_Screen" "screenrecord")              ;; TODO: port


     ;; NAVIGATION
     ("s-h" "move-focus left")
     ("s-j" "move-focus down")
     ("s-k" "move-focus up")
     ("s-l" "move-focus right")
     ;;
     ("s-H" "move-window left")
     ("s-J" "move-window down")
     ("s-K" "move-window up")
     ("s-L" "move-window right")
     ;;
     ("s-M-h" "exchange-direction left")
     ("s-M-j" "exchange-direction down")
     ("s-M-k" "exchange-direction up")
     ("s-M-l" "exchange-direction right")))



(defmap *toggle-cmds*
    (("g" "toggle-gaps")
     ("b" "toggle-gpu")
     ("w" "toggle-wifi")
     ("b" "toggle-bluetooth")
     ("m" "toggle-mute")))

(defmap *bluetooth-map*
    (("o" "bluetooth on")
     ("O" "bluetooth off")
     ("b" "bluetooth bose")))

(defmap *application-map*
    (("e" "emacs")
     ("w" "browser")
     ("t" "terminal")))

(defmap *frame-cmds*
    (("l" "windowlist")
     ("=" "balance-frames")
     ("s" "vsplit")
     ("S" "hsplit")
     ("r" "iresize")
     ("f" "fullscreen")
     ("i" "show-window-properties")
     ("k" "kill")))

;; SUPER
(define-key *top-map* (kbd "s-e") "emacs")
(define-key *top-map* (kbd "s-w") "run-or-raise-browser")
(define-key *top-map* (kbd "s-RET") "run-or-raise-terminal")

;;; STUMPWM COMMANDS

;;
(define-key *top-map* (kbd "s-n") "pull-hidden-next")
(define-key *top-map* (kbd "s-p") "pull-hidden-previous")
(define-key *top-map* (kbd "s-c") "abort")

(define-key *top-map* (kbd "s-d") "exec")
(define-key *top-map* (kbd "s-D") "eval")

(define-key *top-map* (kbd "s-b") "banish")
; "quit"
(define-key *top-map* (kbd "s-ESC") "quit")

(define-key *top-map* (kbd "s-=") "vol-up")
(define-key *top-map* (kbd "s--") "vol-down")
(define-key *top-map* (kbd "s-x") "lock")
