#lang racket/base

(require rackunit)
(require "util.rkt")

#|dst-PtoP|#
(check-equal? (dst-PtoP 0 0 3 4) 5 "dst-PtoP")


#|delete-n|#
; valid
(check-equal? (delete-n (list 1 2 3) 0) (list 2 3) "delete-n")
(check-equal? (delete-n (list 1 2 3) 1) (list 1 3) "delete-n")
(check-equal? (delete-n (list 1 2 3) 2) (list 1 2) "delete-n")

; invalid
(check-equal? (delete-n (list 1 2 3) 3) (list 1 2 3) "delete-n")
; empty list
(check-equal? (delete-n '() 0) '() "delete-n")
(check-equal? (delete-n '() 2) '() "delete-n")


#|number-wrap|#
; inside range
(check-equal? (number-wrap 0 5 0) 0 "number-wrap")
(check-equal? (number-wrap 0 5 3) 3 "number-wrap")
(check-equal? (number-wrap 0 5 5) 5 "number-wrap")

(check-equal? (number-wrap 2 5 3) 3 "number-wrap")
(check-equal? (number-wrap 2 5 4) 4 "number-wrap")

; below range
(check-equal? (number-wrap 2 5 1) 5 "number-wrap")
(check-equal? (number-wrap 2 5 0) 4 "number-wrap")
(check-equal? (number-wrap 2 5 -2) 2 "number-wrap")

; above range
(check-equal? (number-wrap 2 5 6) 2 "number-wrap")
(check-equal? (number-wrap 2 5 10) 2 "number-wrap")

; zero range length
(check-equal? (number-wrap 0 0 0) 0 "number-wrap")
(check-equal? (number-wrap 0 0 1) 0 "number-wrap")
(check-equal? (number-wrap 0 0 -2) 0 "number-wrap")