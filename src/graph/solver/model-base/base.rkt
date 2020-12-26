#lang racket

(require "../util/graph-state.rkt")
(require "../util/graph-searcher.rkt")
(require "../../base/base-structures.rkt")

(provide (all-defined-out))

(define (graph-state-disco-build graph searcher state-searcher)
  (graph-state
   ((searcher-map searcher) (graph-nodes graph)
     (lambda (node)
       (node-state (node-id node) (list #f))))
   state-searcher))

(define (graph-state-dijkstra-build graph searcher state-searcher)
  (graph-state
   ((searcher-map searcher) (graph-nodes graph)
     (lambda (node)
       (node-state (node-id node) (list #f +inf.0))))
   state-searcher))

(define (graph-state-a-star-build graph searcher state-searcher)
  (graph-state
   ((searcher-map searcher) (graph-nodes graph)
     (lambda (node)
       (node-state (node-id node) (list #f +inf.0 +inf.0))))
   state-searcher))
