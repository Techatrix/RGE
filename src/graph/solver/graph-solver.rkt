#lang racket

(require "../util/graph-model-convert.rkt")
(require (prefix-in O0: "model-O0/graph-model-O0.rkt"))
(require (prefix-in O1: "model-O1/graph-model-O1.rkt"))
(require (prefix-in O2: "model-O2/graph-model-O2.rkt"))
(require (prefix-in O3: "model-O3/graph-model-O3.rkt"))

(provide graph-solver-bfs
         graph-solver-dfs
         graph-solver-dijkstra
         graph-solver-a-star)

(define (graph-solver graph level root-node-id goal-node-id proc-O0 proc-O1 proc-O2 proc-O3)
  (define solver (case level
                   [(0) proc-O0]
                   [(1) proc-O1]
                   [(2) proc-O2]
                   [(3) proc-O3]))
  (solver (graph-model-convert graph level) root-node-id goal-node-id))

(define (graph-solver-bfs graph level root-node-id goal-node-id)
  (graph-solver graph level root-node-id goal-node-id O0:bfs void void void))
(define (graph-solver-dfs graph level root-node-id goal-node-id)
  (graph-solver graph level root-node-id goal-node-id O0:dfs void void void))
(define (graph-solver-dijkstra graph level root-node-id goal-node-id)
  (graph-solver graph level root-node-id goal-node-id O0:dijkstra void void void))
(define (graph-solver-a-star graph level root-node-id goal-node-id)
  (graph-solver graph level root-node-id goal-node-id O0:a-star void void void))
