#lang racket

(require "base-structures.rkt")

(provide (all-defined-out))

(define (connections-delete-connection connections id)
  (cond [(empty? connections) '()]
        [(eq? (connection-id (car connections)) id) (rest connections)]
        [else (append (list (car connections)) (connections-delete-connection (rest connections) id))]))