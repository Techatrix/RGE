#lang racket/base

(require rackunit)
(require "../util/util.rkt")

#|dst-PtoP|#
(check-equal? (dst-PtoP '(0 0) '(3 4)) 5 "Triangle 3 4 5 failed")
(check-equal? (dst-PtoP '(0 0) '(6 8)) 10 "Triangle 6 8 10 failed")
(check-equal? (dst-PtoP '(0 0) '(5 12)) 13 "Triangle 5 12 13 failed")
(check-equal? (dst-PtoP '(0 0) '(9 40)) 41 "Triangle 9 40 41 failed")

(check-equal? (dst-PtoP '(2 1) '(5 5)) 5 "Triangle 3 4 5 (with translation) failed")

#|number-wrap|#
; inside range
(check-equal? (number-wrap 0 5 0) 0)
(check-equal? (number-wrap 0 5 3) 3)
(check-equal? (number-wrap 0 5 5) 5)

(check-equal? (number-wrap 2 5 3) 3)
(check-equal? (number-wrap 2 5 4) 4)

; below range
(check-equal? (number-wrap 2 5 1) 5)
(check-equal? (number-wrap 2 5 0) 4)
(check-equal? (number-wrap 2 5 -2) 2)

; above range
(check-equal? (number-wrap 2 5 6) 2)
(check-equal? (number-wrap 2 5 10) 2)

; zero range length
(check-equal? (number-wrap 0 0 0) 0)
(check-equal? (number-wrap 0 0 1) 0)
(check-equal? (number-wrap 0 0 -2) 0)

#|list-delete-n|#
; valid
(check-equal? (list-delete-n '(1 2 3) 0) '(2 3))
(check-equal? (list-delete-n '(1 2 3) 1) '(1 3))
(check-equal? (list-delete-n '(1 2 3) 2) '(1 2))

; invalid
(check-equal? (list-delete-n '(1 2 3) -1) '(1 2 3))
(check-equal? (list-delete-n '(1 2 3) 3) '(1 2 3))
; empty list
(check-equal? (list-delete-n '() 0) '())
(check-equal? (list-delete-n '() 2) '())

#|list-apply|#
(check-equal? (list-apply '(1 2 3) (lambda (x) (+ x 1))) '(2 3 4))
(check-equal? (list-apply '() (lambda (x) (+ x 1))) '())
(check-equal? (list-apply '() (lambda (x) (void))) '())

#|list-search-first|#
(check-equal? (list-search-first '(1 2 3) (lambda (x) (eq? x 1))) 1)
(check-equal? (list-search-first '(1 2 3) (lambda (x) (eq? x 0))) void)