#lang racket

(provide dst-PtoP)


; return √(x2-x1)²+(y2-y1)²
(define (dst-PtoP x1 y1 x2 y2) (sqrt (+ (expt (- x2 x1) 2) (expt (- y2 y1) 2))))