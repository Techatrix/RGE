#lang racket

(provide dst-PtoP)
(provide add-point)
(provide sub-point)
(provide delete-n)
(provide number-wrap)
(provide list-search-first)

(define (dst-PtoP pos1 pos2) (sqrt (+ (expt (- (car pos1) (car pos2)) 2) (expt (- (cadr pos1) (cadr pos2)) 2))))

(define (add-point p1 p2)
  (list (+ (car p1) (car p2)) (+ (cadr p1) (cadr p2))))

(define (sub-point p1 p2)
  (list (- (car p1) (car p2)) (- (cadr p1) (cadr p2))))

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