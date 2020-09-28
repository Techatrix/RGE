#lang racket

(provide (all-defined-out))

; Node get
(define (node-get-id-O0 node) (car node))
(define (node-get-position-O0 node) (cadr node))
(define (node-get-connections-O0 node) (caddr node))

; Node set
(define (node-set-id-O0 node new-id) (list new-id (cadr node) (caddr node)))
(define (node-set-position-O0 node new-pos) (list (car node) new-pos (caddr node)))
(define (node-set-connections-O0 node new-list-cons) (list (car node) (cadr node) new-list-cons))

; Node add/delete
(define (node-add-connection-O0 node new-con)
  (node-set-connections-O0 node (append (node-get-connections-O0 node) (list new-con))))

(define (node-delete-connection-O0 node id) (error "No Implementation"))