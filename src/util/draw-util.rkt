#lang racket

(require "util.rkt")

(provide apply-transform)
(provide draw-point)
(provide draw-line)
(provide draw-arrow)

(define node-size 50)
(define arrow-length 75)
(define arrow-angle 0.5)


(define (apply-transform dc pos)
  (define transform (send dc get-initial-matrix))

  (define x-pos (car pos))
  (define y-pos (cadr pos))
  (define dx-pos (vector-ref transform 4))
  (define dy-pos (vector-ref transform 5))
  (define x-scale (vector-ref transform 0))
  (define y-scale (vector-ref transform 3))

  (list (/ (- x-pos dx-pos) x-scale) (/ (- y-pos dy-pos) y-scale)))

(define (draw-point dc pos)
  (send dc draw-ellipse (- (car pos) (/ node-size 2)) (- (cadr pos) (/ node-size 2)) node-size node-size))

(define (draw-line dc pos1 pos2) (send dc draw-line (car pos1) (cadr pos1) (car pos2) (cadr pos2)))

(define (draw-arrow dc pos1 pos2)
  (draw-line dc pos1 pos2)

  (define delta (sub-point pos2 pos1))
  (cond [(eq? (car delta) 0)
         (define alpha (- arrow-angle (/ pi 2)))

         (define dx (* arrow-length (sin alpha)))
         (define dy (* arrow-length (cos alpha)))

         (draw-line dc pos2 (add-point pos2 (list dx dy)))
         ]
        [else (define beta (atan (/ (- 0 (cadr delta)) (car delta))))
              (define alpha1 (- (+ arrow-angle beta) (/ pi 2)))

              (define dx1 (* arrow-length (sin alpha1)))
              (define dy1 (* arrow-length (cos alpha1)))

              (draw-line dc pos2 (add-point pos2 (list dx1 dy1)))

              (define alpha2 (- beta arrow-angle (/ pi 2)))

              (define dx2 (* arrow-length (sin alpha2)))
              (define dy2 (* arrow-length (cos alpha2)))

              (draw-line dc pos2 (add-point pos2 (list dx2 dy2)))
              ]))