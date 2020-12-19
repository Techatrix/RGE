#lang racket/base

(require "../../graph/graph.rkt")
(require rackunit)

(define con connection)

(let ([g (graph-set-nodes
          (graph-make)
          (list
           (node 0 (vec2 0 0) (list (con 1 2.0) (con 2 1.0)))
           (node 1 (vec2 0 0) (list (con 3 1.0)))
           (node 2 (vec2 0 0) (list (con 3 1.0)))
           (node 3 (vec2 0 0) (list )
                 )))])
  (check-equal? (graph-solver-dijkstra g 0 0 3) '(0 2 3))
  (check-equal? (graph-solver-dijkstra g 0 0 4) #f))

(let ([g (graph-set-nodes
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
           (node 12 (vec2 4.0 14.0) (list (con 0 7.0) (con 1 2.0) (con 2 3.0))) ; S
           ))])
  (check-equal? (graph-solver-dijkstra g 0 0 4) '(0 1 7 6 4)))