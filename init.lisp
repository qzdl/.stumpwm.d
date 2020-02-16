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
; [ ] defdoc: a function that builds up impressions from various readings of
;             whatever project I'm working on. Would be nice to have the exact
;             trace from the repo in
; - NOTE: Would be fairly easy to just have some `sexp` in multiline comment,
;         with some accompanying program just parsing out the form, encrypting
;         the contents, and dumping the output to a file. Relevant information
;         about the state of that repo could be captured, such as the date,
;         current commit SHA, repo name, and the state of the working index.
;         The sexp doesn't need to be deleted from the file, just excluded from
;         the commit history. It would be worth seeing if a multiline regex
;         could cover any ;;;;; (defdoc {:realisation "this (defdoc) would be an embedded dsl/datastructure anywhere. a git repo could be created out of the parsing of all of these repos, but a pretty mental oneliner with ideally no dependencies is required that will run on the utils that ship with git, or are present on any *NIX machine that has git installed. To stay untraceable when copying proprietary software, some way of encrypting all outbound traffic from this 'defmacro hook', some way of posting the payload to an anonymous location that is anonymously accessible, some way of clearing up that resource once it has been consumed, and some way of rearranging them back into a git repo once back out the other side"})
;          extraction of defdocs.

; - NOTE: Accompanying precommit hook that removes any (defdoc ...) shit from
;         my files that can be rolled out into any gitconfig. This would be
;         especially
;


;; SERVER --------------------------------------------------------------------
; TODO: only open server if reserved port is free
(ql:quickload :swank)
(swank:create-server)

(defun restart-swank (port)
  (if (> 0 port) (swank:stop-server port))
  (ql:quickload :swank)
  (swank:start-server))

;;; EXTERNS --------------------------------------------------------------------
(run-shell-command "emacs --daemon")
(run-shell-command "compton")
(run-shell-command "setbg ~/.config/wall.png")

(load "~/.stumpwm.d/visual.lisp")
(load "~/.stumpwm.d/command.lisp")
(load "~/.stumpwm.d/kbd.lisp")
