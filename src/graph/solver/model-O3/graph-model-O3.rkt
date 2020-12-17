#lang racket

(require "../../util/graph-ffi.rkt")

(provide bfs
         dfs
         dijkstra
         a-star)

(define (bfs graph root-node-id goal-node-id)
  (ffi:graphSolve graph root-node-id goal-node-id 0 3))

(define (dfs graph root-node-id goal-node-id)
  (ffi:graphSolve graph root-node-id goal-node-id 1 3))

(define (dijkstra graph root-node-id goal-node-id)
  (ffi:graphSolve graph root-node-id goal-node-id 2 3))

(define (a-star graph root-node-id goal-node-id)
  (ffi:graphSolve graph root-node-id goal-node-id 3 3))