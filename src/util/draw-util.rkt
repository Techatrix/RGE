#lang racket

(require "util.rkt")
(require "structures.rkt")

(provide apply-transform)
(provide draw-point)
(provide draw-line)
(provide draw-arrow)

(define node-size 50)
(define arrow-length 75)
(define arrow-angle 0.5)


(define (apply-transform dc pos)
  (define transform (send dc get-initial-matrix))

  (define x-pos (point-x pos))
  (define y-pos (point-y pos))
  (define dx-pos (vector-ref transform 4))
  (define dy-pos (vector-ref transform 5))
  (define x-scale (vector-ref transform 0))
  (define y-scale (vector-ref transform 3))

  (point (/ (- x-pos dx-pos) x-scale) (/ (- y-pos dy-pos) y-scale)))

(define (draw-point dc pos)
  (send dc draw-ellipse (- (point-x pos) (/ node-size 2)) (- (point-y pos) (/ node-size 2)) node-size node-size))

(define (draw-line dc pos1 pos2) (send dc draw-line (point-x pos1) (point-y pos1) (point-x pos2) (point-y pos2)))

(define (draw-arrow dc pos1 pos2)
  (draw-line dc pos1 pos2)

  (define delta (point-sub pos2 pos1))
  (cond [(eq? (point-x delta) 0)
         (define alpha (- arrow-angle (/ pi 2)))

         (define dx (* arrow-length (sin alpha)))
         (define dy (* arrow-length (cos alpha)))

         (draw-line dc pos2 (point-add pos2 (point dx dy)))
         ]
        [else (define beta (atan (/ (- 0 (point-y delta)) (point-x delta))))
              (define alpha1 (- (+ arrow-angle beta) (/ pi 2)))

              (define dx1 (* arrow-length (sin alpha1)))
              (define dy1 (* arrow-length (cos alpha1)))

              (draw-line dc pos2 (point-add pos2 (point dx1 dy1)))

              (define alpha2 (- beta arrow-angle (/ pi 2)))

              (define dx2 (* arrow-length (sin alpha2)))
              (define dy2 (* arrow-length (cos alpha2)))

              (draw-line dc pos2 (point-add pos2 (point dx2 dy2)))
              ]))