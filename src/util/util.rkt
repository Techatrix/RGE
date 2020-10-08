#lang racket

(require "structures.rkt")

(provide (all-from-out "structures.rkt"))

(provide (all-defined-out))

(define (dst-PtoP pos1 pos2) (sqrt (+ (expt (- (point-x pos1) (point-x pos2)) 2) (expt (- (point-y pos1) (point-y pos2)) 2))))

(define (point-math-opt opt p1 p2)
  (point (opt (point-x p1) (point-x p2)) (opt (point-y p1) (point-y p2))))

(define (point-add p1 p2) (point-math-opt + p1 p2))
(define (point-sub p1 p2) (point-math-opt - p1 p2))
(define (point-mult p1 p2) (point-math-opt * p1 p2))
(define (point-div p1 p2) (point-math-opt / p1 p2))

(define (delete-n l n)
  (cond [(empty? l) '()]
        [(eq? n 0) (rest l)]
        [else (append (list (car l)) (delete-n (rest l) (- n 1)))]))

(define (number-wrap min-n max-n number)
  (cond [(< number min-n) (- max-n (modulo (abs (+ (- number min-n) 1)) (max (+ (- max-n min-n) 1) 1)))]
        [(> number max-n) (+ min-n (modulo (- number max-n 1) (max (+ (- max-n min-n) 1) 1)))]
        [else number]))


; list apply
(define (list-apply l proc)
  (cond [(empty? l) '()]
        [else (append (list (proc (car l))) (list-apply (rest l) proc))]))

; list search
(define (list-search-first l proc)
  (cond [(empty? l) void]
        [(proc (car l)) (car l)]
        [else (list-search-first (rest l) proc)]))