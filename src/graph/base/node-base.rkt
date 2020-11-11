#lang racket

(require "node-base-util.rkt")
(require "base-structures.rkt")
(require "../../util/util.rkt")

(provide (all-defined-out))

; Node get
(define (node-get-connection _node id)
  (list-search (node-connections _node) (lambda (con) (eq? (connection-id con) id))))

(define (node-has-connection? _node id)
  (not (not (node-get-connection _node id))))

; Node set
(define (node-set-id _node new-id)
  (node new-id (node-position _node) (node-connections _node)))
(define (node-set-position _node new-pos)
  (node (node-id _node) new-pos (node-connections _node)))
(define (node-set-connections _node new-list-cons)
  (node (node-id _node) (node-position _node) new-list-cons))

; Node add/delete
(define (node-add-connection _node new-con)
  (if (not (node-has-connection? _node (connection-id new-con)))
        (node-set-connections _node (append (node-connections _node) (list new-con)))
        _node))
(define (node-delete-connection _node id)
  (if (node-has-connection? _node id)
        (node-set-connections _node (connections-delete-connection (node-connections _node) id))
        _node))
