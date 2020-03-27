(in-package :stumpwm)

;; https://solb.io/blog/asynchronize-your-life%3A-shell-commands-10x-faster
(defparameter *async-shell* (uiop:launch-program "bash" :input :stream :output :stream))
(defun async-run (command)
  "a faster run-shell-command with caveats: RETURN SOMETHING"
  (write-line command (uiop:process-info-input *async-shell*))
  (force-output (uiop:process-info-input *async-shell*))
  (let* ((output-string (read-line (uiop:process-info-output *async-shell*)))
         (stream (uiop:process-info-output *async-shell*)))
    (if (listen stream)
        (loop while (listen stream)
              do (setf output-string (concatenate 'string
                                                  output-string
                                                  '(#\Newline)
                                                  (read-line stream)))))
    output-string))

(async-run "cpu")

;; COMMANDS --------------------------------------------------------------------

(defcommand show-top-map () ()
  (display-bindings-for-keymaps '() *top-map*))

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

(defcommand select-display () ()
  (run-shell-command "displayselect"))

(defun swap-vol! (direction mod)
  (run-shell-command (swap-vol direction mod) t))

(defun swap-vol (direction mod &optional print?)
  (let ((command (concat "lmc " direction " " (write-to-string mod))))
    (if print? (message command))
    command))

(defun get-vol (print?)
  (let ((vol (run-shell-command "volume" t)))
    (if print? (message (concat "Volume: " vol)))
    vol))

(defmacro comment (body &rest more-body)
  "the whole point is to do fuck all really")

(comment "weird volume stuff"
         (time (swap-vol! "down" 5))
         (time (get-vol t))

         (defun what ()
           (get-vol t)
           (swap-vol! "down" 5)
           (get-vol t))

         (time (what)))

(defcommand vol-down () ()
  "Volume down through lmc"
  (swap-vol! "down" 5)
  (get-vol t))

(defcommand vol-up () ()
  "Volume up through lmc"
  (swap-vol! "up" 5)
  (get-vol t))

(defcommand terminal () ()
  "Opens the system terminal, as exported in ~/.profile"
  (let ((terminal (getenv "TERMINAL")))
    (run-or-raise terminal `(:class ,(string-capitalize terminal)))))

(defcommand browser () ()
  "Opens the system browser, as exported in ~/.profile"
  (let ((browser (getenv "BROWSER")))
    (run-or-raise  browser `(:class ,browser)))) ;; TODO: figure out Brave-browser :class

(defcommand run () ()
  (run-shell-command "dmenu_run"))

(defcommand cli (cmd) ((:string cmd))
  (run-shell-command (concat "st -e " cmd)))

(defcommand toggle-gpu () ()
   (message "toggle-gpu: This hasn't been implemented yet"))


;; RECORDING
(defcommand screenpick () ()
    (run-shell-command "maimpick"))

(defcommand screennow () ()
  (run-shell-command "maim ~/screenshots/pic-full-\"$(date '+%y%m%d-%H%M-%S').png\""))

(defcommand screenrecord () ()
  (run-shell-command "dmenurecord"))
