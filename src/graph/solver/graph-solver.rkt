#lang racket

(require "../base/base.rkt")
(require "../util/graph-model-convert.rkt")
(require (prefix-in O0: "model-O0/graph-solver.rkt")
         (prefix-in O1: "model-O1/graph-solver.rkt")
         (prefix-in O2: "model-O2/graph-solver.rkt")
         (prefix-in O3: "model-O3/graph-solver.rkt"))

(provide graph-solver-bfs
         graph-solver-bfs-sp
         graph-solver-dfs
         graph-solver-dfs-sp
         graph-solver-dijkstra
         graph-solver-a-star)

(define (graph-solver graph level root-node-id goal-node-id O0 O1 O2 O3)
  (define solver (case level [(0) O0] [(1) O1] [(2) O2] [(3) O3]))
  (solver (graph-model-convert graph level) root-node-id goal-node-id))

(define (graph-solver-bfs graph level root-node-id goal-node-id)
  (graph-solver graph level root-node-id goal-node-id O0:bfs O1:bfs void O3:bfs))
(define (graph-solver-bfs-sp graph level root-node-id goal-node-id)
  (graph-solver graph level root-node-id goal-node-id O0:bfs-sp O1:bfs-sp void O3:bfs-sp))
(define (graph-solver-dfs graph level root-node-id goal-node-id)
  (graph-solver graph level root-node-id goal-node-id O0:dfs O1:dfs void O3:dfs))
(define (graph-solver-dfs-sp graph level root-node-id goal-node-id)
  (graph-solver graph level root-node-id goal-node-id O0:dfs-sp O1:dfs-sp void O3:dfs-sp))
(define (graph-solver-dijkstra graph level root-node-id goal-node-id)
  (graph-solver graph level root-node-id goal-node-id O0:dijkstra O1:dijkstra void O3:dijkstra))
(define (graph-solver-a-star graph level root-node-id goal-node-id [proc-dist vec2-dist])
  (define solver (case level [(0) O0:a-star] [(1) O1:a-star] [(2) void] [(3) O3:a-star]))
  (solver (graph-model-convert graph level) root-node-id goal-node-id proc-dist))