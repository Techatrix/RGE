#lang racket

(provide (all-defined-out))

(define (connections-delete-connection-O0 connections id)
  (cond [(empty? connections) '()]
        [(eq? (car (car connections)) id) (rest connections)]
        [else (append (list (car connections)) (connections-delete-connection-O0 (rest connections) id))]))