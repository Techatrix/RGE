#lang racket

(require "structures.rkt")
(require "geometry.rkt")

(provide (all-from-out "structures.rkt")
         (all-from-out "geometry.rkt"))

(provide (all-defined-out))

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
(define (list-search-eq l v)
  (list-search l (lambda (e) (eq? v e))))

(define (list-search l proc)
  (cond [(empty? l) #f]
        [(proc (car l)) (car l)]
        [else (list-search (rest l) proc)]))

(define (list-search-ref l proc n)
  (cond [(empty? l) #f]
        [(proc (car l)) n]
        [else (list-search-ref (rest l) proc (+ n 1))]))

; list remove
(define (list-remove-eq l v)
  (list-remove l (lambda (e) (eq? v e))))

(define (list-remove l proc)
  (cond [(empty? l) '()]
        [(proc (car l)) (rest l)]
        [else (cons (car l) (list-remove (rest l) proc))]))

; list removes element at position n
(define (list-remove-n l n)
  (cond [(empty? l) '()]
        [(zero? n) (rest l)]
        [else (cons (car l) (list-remove-n (rest l) (- n 1)))]))

; list remove last element
(define (list-remove-last l)
  (cond [(null? (cdr l)) '()]
        [else (cons (car l) (list-remove-last (cdr l)))]))

(define (list-for-recur v lst proc)
  (cond [(empty? lst) v]
        [else (list-for-recur (proc v (car lst)) (rest lst) proc)]))
