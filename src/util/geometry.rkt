#lang racket

(require "structures.rkt")

(provide (all-defined-out))

(define (rect-get-points rect)
  (define a (car rect))
  (define b (cadr rect))
  (values
   (min (vec2-x a) (vec2-x b))
   (max (vec2-x a) (vec2-x b))
   (min (vec2-y a) (vec2-y b))
   (max (vec2-y a) (vec2-y b))))

; point inside circle?
(define (point-in-circle? point circle-pos circle-r)
  (< (vec2-dist point circle-pos) circle-r))

; point inside rectangle?
(define (point-in-rectangle? point rect-pos rect-size)
  (define-values (px py rx1 ry1 rx2 ry2)
    (values
     (vec2-x point)
     (vec2-y point)
     (vec2-x rect-pos)
     (vec2-y rect-pos)
     (+ (vec2-x rect-pos) (vec2-x rect-size))
     (+ (vec2-y rect-pos) (vec2-y rect-size))))

  (define x? (and (> px rx1) (< px rx2)))
  (define y? (and (> py ry1) (< py ry2)))
  
  (and x? y?))

; line <-> circle intersect
(define (line-circle-intersect? circle-pos circle-r p1 p2)
  #f)

; rectangle <-> circle intersect
(define (rect-circle-intersect? rect-pos rect-size circle-pos circle-r)
  (define A (vec2 0 0))
  (define B (vec2 0 0))
  (define C (vec2 0 0))
  (define D (vec2 0 0))
  (or (point-in-rectangle? circle-pos rect-pos rect-size)
      ; (line-circle-intersect? circle-pos circle-r A B)
      ; (line-circle-intersect? circle-pos circle-r B C)
      ; (line-circle-intersect? circle-pos circle-r C D)
      ; (line-circle-intersect? circle-pos circle-r D A)
      ))
