;; VISUAL ----------------------------------------------------------------------
(in-package :stumpwm)

(ql:quickload :clx-truetype)
(load-module "ttf-fonts") ; oof
(load-module "swm-gaps")

;; FONTS
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

;; GAPS
(if (not swm-gaps:*gaps-on*)
    (swm-gaps:toggle-gaps))

(setf swm-gaps:*inner-gaps-size* 15
      swm-gaps:*outer-gaps-size* 0
      swm-gaps:*head-gaps-size* 15)

;; WINDOW / FRAME
(setf *message-window-gravity* :center
      *input-window-gravity* :center
      *window-border-style* :thin
      *message-window-padding* 10
      *maxsize-border-width* 2
      *normal-border-width* 5
      *transient-border-width* 2
      stumpwm::*float-window-border* 2
      stumpwm::*float-window-title-height* 5)

(setf *mouse-focus-policy* :click)

;; THEME

(defmacro deftheme (name (&key focus unfocus picture))
  `(defcommand ,name () ()
     (stumpwm:set-focus-color ,focus)
     (stumpwm:set-unfocus-color ,unfocus)
     (stumpwm:run-shell-command (concat "setbg '" ,picture "'"))
     (stumpwm:redisplay)))
;; TODO: wrap `wal' and translate output into something usable with deftheme

(defun random-command (commands)
  (run-commands (nth (random (length commands)) commands)))
;; (random-command '(""))
