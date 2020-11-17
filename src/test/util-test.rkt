#lang racket/base

(require rackunit)
(require "../util/util.rkt")

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

#|list-apply|#
(check-equal? (list-apply '(1 2 3) (lambda (x) (+ x 1))) '(2 3 4))
(check-equal? (list-apply '() (lambda (x) (+ x 1))) '())
(check-equal? (list-apply '() (lambda (x) (void))) '())

#|list-search|#
; list-search-eq
(check-equal? (list-search-eq (list 1 2 3) 2) 2)
(check-equal? (list-search-eq (list 3 2 1) 3) 3)
(check-equal? (list-search-eq (list 2 3 1) 0) #f)

; list-search
(check-equal? (list-search (list 1 2 3) (lambda (x) (eq? x 2))) 2)
(check-equal? (list-search (list 2 3 1) (lambda (x) (not (eq? x 2)))) 3)

; list-search-ref
(check-equal? (list-search-ref (list 1 2 3) (lambda (x) (eq? x 2))) 1)
(check-equal? (list-search-ref (list 3 2 1) (lambda (x) (eq? x 3))) 0)
(check-equal? (list-search-ref (list 2 1 3) (lambda (x) (eq? x 3))) 2)
(check-equal? (list-search-ref (list 2 1 3) (lambda (x) (eq? x 5))) #f)

#|list-remove|#
; list-remove-eq
(check-equal? (list-remove-eq (list 1 2 3) 2) (list 1 3))
(check-equal? (list-remove-eq (list 1 2 3) 1) (list 2 3))
(check-equal? (list-remove-eq (list 3 2 1) 4) (list 3 2 1))
(check-equal? (list-remove-eq '() 1) '())
; list-remove
(check-equal? (list-remove (list 1 2 2 3) (lambda (x) (eq? x 2))) (list 1 3))
(check-equal? (list-remove (list 2 3 2 1) (lambda (x) (not (eq? x 2)))) (list 2 2))
(check-equal? (list-remove '() (lambda (x) #t)) '())
; list-remove-n
(check-equal? (list-remove-n (list 1 2 3) 0) (list 2 3))
(check-equal? (list-remove-n (list 1 2 3) 2) (list 1 2))
(check-equal? (list-remove-n (list 1 2 3) 3) (list 1 2 3))
(check-equal? (list-remove-n '() 1) '())
; list-remove-last
(check-equal? (list-remove-last (list 1 2 3)) (list 1 2))
(check-equal? (list-remove-last (list 3 2 1)) (list 3 2))
(check-equal? (list-remove-last '()) '())