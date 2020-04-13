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
        for keys = (ensure-list (first bind))
        for cmd  = (second bind)
        append (loop for key in keys
                     collect `(define-key ,name (kbd ,key) ,cmd))))

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
     ("s-c" "abort")
     ("s-?" "show-top-map")
     ("s-RET" "terminal")
     ("S-s-RET" "terminal new") ; TODO: implement new option in command
     ("s-n" "pull-hidden-next")
     (("s-TAB" "s-p") "pull-hidden-previous"
                      "an attempt a left-handed 'last window' bind")

     ;; INPUT BASED (fire away, c-y)
     ("s-:" "colon"
            "fire into command mode")
     (("s-d" "s-;") "exec"
                    "fire into shell execution context")
     (("s-D" "s-M-;") "eval"
              "fire into cl eval; arbitrary sexps.")

     ;; SUPER FUNCTION
     ("s-F2" "redisplay")
     ("s-F8" "select-display")
     (("s-F9" "s-u") "srun ducksearch")

     ("s-b" "banish"
            "send mouse to max x,y on screen")
     ("s-ESC" "quit"
              "quits stumpwm")
     ("s-=" "vol-up")
     ("s--" "vol-down")
     ("s-x" "lock")

     ;; RECORDING
     ("SunPrint_Screen" "screenpick")     ; printscr ;; TODO: port to CL
     ("Sys_Req" "screennow")              ; SHIFT ^  ;; TODO: port to CL
     ("s-SunPrint_Screen" "screenrecord") ; SUPER ^  ;; TODO: port to CL
     ;; bindsym $mod+Scroll_Lock    exec --no-startup-id "killall screenkey || screenkey"
     ;; bindsym $mod+Delete         exec $stoprec
     ;; bindsym XF86Launch1         exec --no-startup-id xset dpms force off

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

     ("m" "mode-line")
     ("M" "toggle-mute")))

(defmap *bluetooth-map*
    (("o" "bluetooth on")
     ("O" "bluetooth off")
     ("b" "bluetooth bose")))

(defmap *application-map*
    (("e" "emacs")
     ("w" "browser")
     ("t" "terminal")
     ("s" "spotify")
     ("h" "cli htop")))

(defmap *frame-cmds*
    (("l" "windowlist")
     ("=" "balance-frames")

     ("s" "vsplit")
     ("S" "hsplit")

     ("r" "iresize")
     ("f" "fullscreen")
     ("Q" "only")
     ("i" "show-window-properties")
     ("k" "kill")

     ("0" "select-window-by-number 0")
     ("1" "select-window-by-number 1")
     ("2" "select-window-by-number 2")
     ("3" "select-window-by-number 3")
     ("4" "select-window-by-number 4")
     ("5" "select-window-by-number 5")
     ("6" "select-window-by-number 6")
     ("7" "select-window-by-number 7")
     ("8" "select-window-by-number 8")
     ("9" "select-window-by-number 9")))
