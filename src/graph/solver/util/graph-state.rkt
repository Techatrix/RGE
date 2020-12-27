#lang racket

(require "graph-searcher.rkt")

(provide (struct-out node-state)
         (struct-out graph-state)
         graph-state-set-nodes
         graph-state-get-node
         graph-state-set-node)

(struct node-state (id data) #:transparent)

(struct graph-state (nodes searcher) #:transparent)

(define (graph-state-set-nodes state nodes)
  (graph-state nodes (graph-state-searcher state)))

(define (graph-state-add-node state id data)
  (graph-state-set-nodes state
                         ((searcher-add (graph-state-searcher state))
                          (graph-state-nodes state) (node-state id data))))

(define (graph-state-remove-node state id)
  (graph-state-set-nodes state
                         ((searcher-remove (graph-state-searcher state))
                          (graph-state-nodes state) (node-state id #f))))

(define (graph-state-get-node state id)
  ((searcher-get (graph-state-searcher state)) (graph-state-nodes state) (node-state id #f)))

(define (graph-state-set-node state id _node-state)
  (graph-state-set-nodes state
                         ((searcher-set (graph-state-searcher state))
                          (graph-state-nodes state) (node-state id #f) _node-state)))
