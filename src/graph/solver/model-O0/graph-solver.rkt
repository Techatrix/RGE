#lang racket

(require "graph-searcher.rkt")
(require "../../base/base.rkt")
(require (prefix-in solver: "../model-base/solver.rkt"))

(provide bfs
         dfs
         dfs-sp
         dijkstra
         a-star)

(define (bfs graph root-node-id goal-node-id)
  (solver:bfs graph searcher-graph-O0 searcher-state-O0 root-node-id goal-node-id))

(define (dfs graph root-node-id goal-node-id)
  (solver:dfs graph searcher-graph-O0 searcher-state-O0 root-node-id goal-node-id))

(define (dfs-sp graph root-node-id goal-node-id)
  (solver:dfs-sp graph searcher-graph-O0 searcher-state-O0 root-node-id goal-node-id))

(define (dijkstra graph root-node-id goal-node-id)
  (solver:dijkstra graph searcher-graph-O0 searcher-state-O0 root-node-id goal-node-id))

(define (a-star graph root-node-id goal-node-id [proc-dist vec2-dist])
  (solver:a-star graph searcher-graph-O0 searcher-state-O0 root-node-id goal-node-id proc-dist))
