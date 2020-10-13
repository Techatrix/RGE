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

  (vec2-div (vec2-sub pos delta-pos) scale))

(define (draw-point dc pos size)
  (send dc draw-ellipse (- (vec2-x pos) (/ size 2)) (- (vec2-y pos) (/ size 2)) size size))

(define (draw-line dc pos1 pos2)
  (send dc draw-line (vec2-x pos1) (vec2-y pos1) (vec2-x pos2) (vec2-y pos2)))

(define (draw-arrow dc pos1 pos2)
  (define arrow-length 50)
  (define arrow-angle 0.5)
  (draw-line dc pos1 pos2)

  (define delta (vec2-sub pos2 pos1))
  (cond [(eq? (vec2-x delta) 0)
         (define alpha (- arrow-angle (/ pi 2)))

         (define dx (* arrow-length (sin alpha)))
         (define dy (* arrow-length (cos alpha)))

         (draw-line dc pos2 (vec2-add pos2 (vec2 dx dy)))
         ]
        [else (define beta (atan (/ (- (vec2-y delta)) (vec2-x delta))))
              (define alpha1 (- (+ arrow-angle beta) (/ pi 2)))

              (define dx1 (* arrow-length (sin alpha1)))
              (define dy1 (* arrow-length (cos alpha1)))

              (draw-line dc pos2 (vec2-add pos2 (vec2 dx1 dy1)))

              (define alpha2 (- beta arrow-angle (/ pi 2)))

              (define dx2 (* arrow-length (sin alpha2)))
              (define dy2 (* arrow-length (cos alpha2)))

              (draw-line dc pos2 (vec2-add pos2 (vec2 dx2 dy2)))
              ]))