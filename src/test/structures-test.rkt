#lang racket/base

(require rackunit)
(require "../util/structures.rkt")

#|vec2|#
; vec2-eq?
(check-equal? (vec2-eq? (vec2 0 0) (vec2 0 0)) #t)
(check-equal? (vec2-eq? (vec2 3 4) (vec2 3 4)) #t)
(check-equal? (vec2-eq? (vec2 3 4) (vec2 4 3)) #f)

; vec2-add
(check-equal? (vec2-add (vec2 1 2) (vec2 3 4)) (vec2 4 6))
(check-equal? (vec2-add (vec2 3 0) (vec2 0 3)) (vec2 3 3))
(check-equal? (vec2-add (vec2 -1 -2) (vec2 3 4)) (vec2 2 2))
(check-equal? (vec2-add (vec2 -1 -2) (vec2 0 0)) (vec2 -1 -2))

; vec2-sub
(check-equal? (vec2-sub (vec2 1 2) (vec2 3 4)) (vec2 -2 -2))
(check-equal? (vec2-sub (vec2 3 0) (vec2 0 3)) (vec2 3 -3))
(check-equal? (vec2-sub (vec2 -1 -2) (vec2 3 4)) (vec2 -4 -6))
(check-equal? (vec2-sub (vec2 -1 -2) (vec2 0 0)) (vec2 -1 -2))

; vec2-mult
(check-equal? (vec2-mult (vec2 1 2) (vec2 3 4)) (vec2 3 8))
(check-equal? (vec2-mult (vec2 3 0) (vec2 0 3)) (vec2 0 0))

; vec2-div
(check-equal? (vec2-div (vec2 6 3) (vec2 2 1)) (vec2 3 3))
(check-equal? (vec2-div (vec2 4 8) (vec2 -2 -8)) (vec2 -2 -1))

; vec2-scalar
(check-equal? (vec2-scalar (vec2 3 4) 2) (vec2 6 8))
(check-equal? (vec2-scalar (vec2 3 4) -1) (vec2 -3 -4))
(check-equal? (vec2-scalar (vec2 4 3) 0) (vec2 0 0))

; vec2-dist
(check-equal? (vec2-dist (vec2 0 0) (vec2 3 4)) 5 "Triangle 3 4 5 failed")
(check-equal? (vec2-dist (vec2 0 0) (vec2 3 4)) 5 "Triangle 3 4 5 failed")
(check-equal? (vec2-dist (vec2 0 0) (vec2 6 8)) 10 "Triangle 6 8 10 failed")
(check-equal? (vec2-dist (vec2 0 0) (vec2 5 12)) 13 "Triangle 5 12 13 failed")
(check-equal? (vec2-dist (vec2 0 0) (vec2 9 40)) 41 "Triangle 9 40 41 failed")
(check-equal? (vec2-dist (vec2 2 1) (vec2 5 5)) 5 "Triangle 3 4 5 (with translation) failed")
