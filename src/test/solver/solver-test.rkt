#lang racket/base

(require "../../graph/graph.rkt")
(require rackunit)

(provide graph-solver-test-suite)

(define g1
  (let ([con connection])
    (graph-set-nodes
     (graph-make)
     (list
      (node 0 (vec2 0 0) (list (con 1 2.0) (con 2 1.0)))
      (node 1 (vec2 0 0) (list (con 3 1.0)))
      (node 2 (vec2 0 0) (list (con 3 1.0)))
      (node 3 (vec2 0 0) (list ))))))

(define g2
  (let ([con connection])
    (graph-set-nodes
     (graph-make)
     (list
      (node 0 (vec2 0.0 8.8) (list (con 1 3.0) (con 3 4.0) (con 12 7.0))) ; A
      (node 1 (vec2 4.0 8.0) (list (con 0 3.0) (con 3 4.0) (con 7 1.0) (con 12 2.0))) ; B
      (node 2 (vec2 12.0 12.0) (list (con 11 2.0) (con 12 3.0))) ; C
      (node 3 (vec2 0.8 5.6) (list (con 0 4.0) (con 1 4.0) (con 5 5.0))) ; D
      (node 4 (vec2 10.4 0.0) (list (con 6 2.0) (con 10 5.0))) ; E
      (node 5 (vec2 1.6 3.2) (list (con 3 5.0) (con 7 3.0))) ; F
      (node 6 (vec2 6.4 2.4) (list (con 4 2.0) (con 7 2.0))) ; G
      (node 7 (vec2 4.0 4.8) (list (con 1 1.0) (con 5 3.0) (con 6 2.0))) ; H
      (node 8 (vec2 11.6 6.0) (list (con 9 6.0) (con 10 4.0) (con 11 4.0))) ; I
      (node 9 (vec2 15.6 5.6) (list (con 8 6.0) (con 10 4.0) (con 11 4.0))) ; J
      (node 10 (vec2 12.8 3.2) (list (con 4 5.0) (con 8 4.0) (con 9 4.0))) ; K
      (node 11 (vec2 13.6 9.6) (list (con 2 2.0) (con 8 4.0) (con 9 4.0))) ; L
      (node 12 (vec2 4.0 14.0) (list (con 0 7.0) (con 1 2.0) (con 2 3.0))))))) ; S

(define graph-tests
  (list
   (list g1 '( (0 3 (0 2 3))))
   (list g2 '( (0 4 (0 1 7 6 4))))))

(define (agol-id->agol-name id)
  (list-ref '("BFS" "BFS-SP" "DFS" "DFS-SP" "Dijkstra" "A-Star") id))
(define (agol-id->force-exspect? id)
  (list-ref '(#f #t #f #t #t #t) id))
(define (model-id->model-name id)
  (list-ref '("Racket" "Racket Optimized" "Racket Typed" "FFI" ) id))

(define (agol-id->agol-proc id)
  (list-ref (list
             graph-solver-bfs
             graph-solver-bfs-sp
             graph-solver-dfs
             graph-solver-dfs-sp
             graph-solver-dijkstra
             graph-solver-a-star) id))


(define (create-check agol model)
  (define solver (agol-id->agol-proc agol))
  
  (for ([graph-test-entry graph-tests])
       (define graph (car graph-test-entry))
       (define test (cadr graph-test-entry))
       (for ([test-entry test])
            (define root-node-id (car test-entry))
            (define goal-node-id (cadr test-entry))
            (define exspect (caddr test-entry))
            
            (define result (solver graph model root-node-id goal-node-id))
            
            (check-true (list? result))
            (when (agol-id->force-exspect? agol)
                  (check-equal? result exspect)))))

(define (create-test-case agol model)
  (test-case
    (format "~a"
            (model-id->model-name model))
    (create-check agol model)))

(define (create-test-suite agol)
  (test-suite
   (format "~a Tests" (agol-id->agol-name agol))
   (create-test-case agol 0) ; Racket
   (create-test-case agol 1) ; Racket Optimized
   (create-test-case agol 3) ; FFI
   ))

(define graph-solver-test-suite
  (test-suite
   "Graph Solver Tests"
   (create-test-suite 0) ; BFS
   (create-test-suite 1) ; BFS-SP
   (create-test-suite 2) ; DFS
   (create-test-suite 3) ; DFS-SP
   (create-test-suite 4) ; Dijkstra
   (create-test-suite 5) ; A-Star
   ))