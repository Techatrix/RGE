#lang racket

(require math)

(provide (all-defined-out))

(define (timer-start) (current-inexact-milliseconds))

(define (timer-stop timer) (- (current-inexact-milliseconds) timer))

(define (time proc)
  (define timer (timer-start))
  (proc)
  (timer-stop timer))
