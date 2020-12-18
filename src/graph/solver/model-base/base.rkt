#lang racket

(require "../util/graph-state.rkt")
(require "../util/graph-searcher.rkt")
(require "../../base/base-structures.rkt")

(provide graph-state-disco-build
         graph-state-dijkstra-build)

(define (graph-state-disco-build graph searcher state-searcher)
  (graph-state
   ((searcher-map searcher) graph
     (lambda (node)
       (node-state (node-id node) (list #f #f))))
   state-searcher))

(define (graph-state-dijkstra-build graph searcher state-searcher)
  (graph-state
   ((searcher-map searcher) graph
     (lambda (node)
       (node-state (node-id node) (list +inf.0 #f))))
   state-searcher))
