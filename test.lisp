;; TODO: figure out simple testing

(and ;; test `expand-map'
 ;; original case
     (equal (expand-map 'map-name '(("k" "c")))
            `((define-key map-name (kbd "k") "c")))

     ;; collapse n bindings
     (equal (expand-map 'map-name '((("k0" "k1") "c")))
            `((define-key map-name (kbd "k0") "c")
              (define-key map-name (kbd "k1") "c")))

     ;; original case, 2 items
     (equal (expand-map 'map-name '(("k0" "c")
                                    ("k1" "c_0")))
            `((define-key map-name (kbd "k0") "c")
              (define-key map-name (kbd "k1") "c_0")))

     ;; mix original and collapse case, 2 items
     (equal (expand-map 'map-name '((("k0" "k1") "c")
                                    ("k" "c_0")))
            `((define-key map-name (kbd "k0") "c")
              (define-key map-name (kbd "k1") "c")
              (define-key map-name (kbd "k") "c_0"))))
