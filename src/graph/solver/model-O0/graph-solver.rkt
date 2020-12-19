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
  (solver:bfs graph searcher-O0 searcher-state-O0 root-node-id goal-node-id))

(define (dfs graph root-node-id goal-node-id)
  (solver:dfs graph searcher-O0 searcher-state-O0 root-node-id goal-node-id))

(define (dfs-sp graph root-node-id goal-node-id)
  (solver:dfs-sp graph searcher-O0 searcher-state-O0 root-node-id goal-node-id))

(define (dijkstra graph root-node-id goal-node-id)
  (solver:dijkstra graph searcher-O0 searcher-state-O0 root-node-id goal-node-id))

(define (a-star graph root-node-id goal-node-id)
  (solver:a-star graph searcher-O0 searcher-state-O0 root-node-id goal-node-id))
