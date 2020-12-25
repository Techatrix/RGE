#lang racket

(provide (except-out (all-defined-out)
                     vec2-math-opt))

(struct vec2 (x y) #:transparent)

(define (vec2-eq? v1 v2) (and (eq? (vec2-x v1) (vec2-x v2))
                              (eq? (vec2-y v1) (vec2-y v2))))

(define (vec2-math-opt opt v1 v2)
  (vec2 (opt (vec2-x v1) (vec2-x v2))
        (opt (vec2-y v1) (vec2-y v2))))

(define (vec2-add v1 v2) (vec2-math-opt + v1 v2))
(define (vec2-sub v1 v2) (vec2-math-opt - v1 v2))
(define (vec2-mult v1 v2) (vec2-math-opt * v1 v2))
(define (vec2-div v1 v2) (vec2-math-opt / v1 v2))

(define (vec2-scalar v scalar) (vec2 (* (vec2-x v) scalar) (* (vec2-y v) scalar)))
(define (vec2-dot v1 v2) (+ (* (vec2-x v1) (vec2-x v2)) (* (vec2-y v1) (vec2-y v2))))

(define (vec2-dist v1 v2) (vec2-length (vec2-sub v2 v1)))
(define (vec2-length v) (sqrt (+ (expt (vec2-x v) 2) (expt (vec2-y v) 2))))
(define (vec2-norm v) (vec2-scalar v (/ 1 (vec2-length v))))

(define (vec2-angle v1 v2) (acos (/ (abs (vec2-dot v1 v2)) (* (vec2-length v1) (vec2-length v2)))))
(define (vec2-rotate v a) (vec2 (- (* (vec2-x v) (cos a)) (* (vec2-y v) (sin a)))
                                (+ (* (vec2-x v) (sin a)) (* (vec2-y v) (cos a)))))

(define (vec2-sum v) (+ (vec2-x v) (vec2-y v)))
(define (vec2-pow2 v) (vec2-mult v v))
