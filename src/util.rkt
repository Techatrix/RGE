#lang racket

(provide dst-PtoP)
(provide draw-line)
(provide draw-arrow)
(provide delete-n)
(provide number-wrap)

(define l 25)
(define a 0.5)

(define (dst-PtoP pos1 pos2) (sqrt (+ (expt (- (car pos1) (car pos2)) 2) (expt (- (cadr pos1) (cadr pos2)) 2))))

(define (draw-line dc pos1 pos2) (send dc draw-line (car pos1) (cadr pos1) (car pos2) (cadr pos2)))

(define (draw-arrow dc pos1 pos2)
  (draw-line dc pos1 pos2)
  #|
  (define dy (- y2 y1))
  (define dx (- x2 x1))
  (define beta (atan (/ dy dx)))
  (define r (- (dst-PtoP pos1 pos2) l))
  
  (draw-line dc x2 y2 (+ x1 (* (cos (+ beta a)) r)) (+ y1 (* (sin (+ beta a)) r)))
  (draw-line dc x2 y2 (+ x1 (* (cos (- beta a)) r)) (+ y1 (* (sin (- beta a)) r)))
  (draw-line dc x2 y2 (* (cos (- beta 5)) 5) (* (sin (- beta 5)) 5)
  |#
  )

(define (delete-n l n)
  (cond [(empty? l) '()]
        [(eq? n 0) (rest l)]
        [else (append (list (car l)) (delete-n (rest l) (- n 1)))]))


(define (number-wrap min-n max-n number)
  (cond [(< number min-n) (- max-n (modulo (abs (+ (- number min-n) 1)) (max (+ (- max-n min-n) 1) 1)))]
        [(> number max-n) (+ min-n (modulo (- number max-n 1) (max (+ (- max-n min-n) 1) 1)))]
        [else number]))