#lang racket

(require "../../util/graph-ffi.rkt")

(provide bfs
         dfs
         dfs-sp
         dijkstra
         a-star)

(define (solve-result-response->symbol response)
  (case response
    [(0) 'success]
    [(1) 'error]
    [(2) 'no-path]
    [(3) 'invalid-root]
    [(4) 'invalid-goal]
    [(5) 'invalid-solve-mode]
    [(6) 'invalid-searcher-mode]))

(define (solve-result->route solve-result)
  (define response (ffi:graphSolveResultResponse solve-result))
  (if (zero? response)
      (ffi:graphSolveResultPath solve-result)
      (solve-result-response->symbol response)))

(define (bfs graph root-node-id goal-node-id)
  (solve-result->route (ffi:graphSolve graph root-node-id goal-node-id 0 3)))

(define (dfs graph root-node-id goal-node-id)
  (solve-result->route (ffi:graphSolve graph root-node-id goal-node-id 1 3)))

(define (dfs-sp graph root-node-id goal-node-id)
  (solve-result->route (ffi:graphSolve graph root-node-id goal-node-id 2 3)))

(define (dijkstra graph root-node-id goal-node-id)
  (solve-result->route (ffi:graphSolve graph root-node-id goal-node-id 3 3)))

(define (a-star graph root-node-id goal-node-id)
  (solve-result->route (ffi:graphSolve graph root-node-id goal-node-id 4 3)))