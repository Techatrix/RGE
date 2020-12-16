#lang racket

(require "../../../util/util.rkt")
(require "../../base/base.rkt")

(provide (struct-out node-state)
         (struct-out graph-state)
         graph-state-get-node
         graph-state-set-node)

(struct node-state (id data) #:transparent)

(struct graph-state (nodes) #:transparent)

(define (graph-state-add-node _graph-state id data)
  (graph-state (cons (node-state id data) (graph-state-nodes _graph-state))))

(define (graph-state-remove-node _graph-state id)
  (define proc
    (lambda (nodes id)
      (cond [(empty? nodes) '()]
            [(eq? (node-state-id (car nodes)) id) (rest nodes)]
            [else (cons (car nodes) (proc (rest nodes) id))])))
  
  (graph-state (proc (graph-state-nodes _graph-state id))))

(define (nodes-delete-node nodes id)
  (cond [(empty? nodes) '()]
        [(eq? (node-id (car nodes)) id) (nodes-delete-node (rest nodes) id)]
        [else (cons (node-delete-connection (car nodes) id)
                    (nodes-delete-node (rest nodes) id))]))


(define (graph-state-get-node _graph-state n)
  (list-search (graph-state-nodes _graph-state) (lambda (node) (eq? (node-state-id node) n))))

(define (graph-state-set-node _graph-state n node-state)
  (graph-state (list-replace (graph-state-nodes _graph-state)
                             (lambda (node) (eq? (node-state-id node) n))
                             node-state)))
