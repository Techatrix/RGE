#lang racket

(require "util.rkt")
(require "structures.rkt")

(provide apply-transform)
(provide draw-point)
(provide draw-line)
(provide draw-arrow)

(define (apply-transform dc pos)
  (define t (send dc get-initial-matrix))

  (define delta-pos (vec2 (vector-ref t 4) (vector-ref t 5)))
  (define scale (vec2 (vector-ref t 0) (vector-ref t 3)))

  (define result (vec2-div (vec2-sub pos delta-pos) scale))
  (vec2 (exact-round (vec2-x result)) (exact-round (vec2-y result))))

(define (draw-point dc pos size)
  (send dc draw-ellipse (- (vec2-x pos) (/ size 2)) (- (vec2-y pos) (/ size 2)) size size))

(define (draw-line dc pos1 pos2)
  (send dc draw-line (vec2-x pos1) (vec2-y pos1) (vec2-x pos2) (vec2-y pos2)))

(define (draw-arrow dc pos1 pos2)
  (define AB (vec2-sub pos2 pos1))
  (define l (vec2-length AB))
  (when (< 30 l)
        (define arrow-length (/ 80 (+ 1 (exp (+ (* (/ -1 100) l) 2)))))
        (define arrow-angle (/ pi 6))

        (define origin (vec2-add pos1 (vec2-scalar (vec2-norm AB) 30)))
        (define target (vec2-add pos1 (vec2-scalar (vec2-norm AB) (- l 30))))
        (define dir1 (vec2-scalar (vec2-norm (vec2-rotate AB (- pi arrow-angle))) arrow-length))
        (define dir2 (vec2-scalar (vec2-norm (vec2-rotate AB (+ pi arrow-angle))) arrow-length))

        (draw-line dc origin target)
        (draw-line dc target (vec2-add target dir1))
        (draw-line dc target (vec2-add target dir2))))