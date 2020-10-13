#lang racket

(require "structures.rkt")

(provide (all-from-out "structures.rkt"))

(provide (all-defined-out))

(define (delete-n l n)
  (cond [(empty? l) '()]
        [(eq? n 0) (rest l)]
        [else (cons (car l) (delete-n (rest l) (- n 1)))]))

(define (number-wrap min-n max-n number)
  (cond [(< number min-n)
         (define a (abs (+ (- number min-n) 1)))
         (define b (max (+ (- max-n min-n) 1) 1))
         (- max-n (modulo a b))]
        [(> number max-n)
         (define a (- number max-n 1))
         (define b (max (+ (- max-n min-n) 1) 1))
         (+ min-n (modulo a b))]
        [else number]))


; list apply
(define (list-apply l proc)
  (cond [(empty? l) '()]
        [else (cons (proc (car l)) (list-apply (rest l) proc))]))

; list search
(define (list-search-first l proc)
  (cond [(empty? l) (error "not found")]
        [(proc (car l)) (car l)]
        [else (list-search-first (rest l) proc)]))

; list remove last element
(define (list-remove-last l)
  (cond [(null? (cdr l)) '()]
        [else (cons (car l) (list-remove-last (cdr l)))]))