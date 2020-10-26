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
(define (list-apply lst proc)
  (if (empty? lst)
      '()
      (cons (proc (car lst)) (list-apply (rest lst) proc))))

; list search
(define (list-search-eq lst v)
  (list-search lst (lambda (e) (eq? v e))))

(define (list-search lst proc)
  (cond [(empty? lst) #f]
        [(proc (car lst)) (car lst)]
        [else (list-search (rest lst) proc)]))

(define (list-search-ref lst proc [n 0])
  (cond [(empty? lst) #f]
        [(proc (car lst)) n]
        [else (list-search-ref (rest lst) proc (+ n 1))]))

; list remove
(define (list-remove-eq lst v)
  (list-remove lst (lambda (e) (eq? v e))))

(define (list-remove lst proc)
  (cond [(empty? lst) '()]
        [(proc (car lst)) (rest lst)]
        [else (cons (car lst) (list-remove (rest lst) proc))]))

; list removes element at position n
(define (list-remove-n lst n)
  (cond [(empty? lst) '()]
        [(zero? n) (rest lst)]
        [else (cons (car lst) (list-remove-n (rest lst) (- n 1)))]))

; list remove last element
(define (list-remove-last lst)
  (cond [(null? (cdr lst)) '()]
        [else (cons (car lst) (list-remove-last (cdr lst)))]))

(define (list-for-recur v lst proc)
  (cond [(empty? lst) v]
        [else (list-for-recur (proc v (car lst)) (rest lst) proc)]))

(define (list-append-new lst1 lst2)
  (cond [(empty? lst2) lst1]
        [(not (list-search-eq lst1 (car lst2)))
         (cons (car lst2) (list-append-new lst1 (rest lst2)))]
        [else (list-append-new lst1 (rest lst2))]))