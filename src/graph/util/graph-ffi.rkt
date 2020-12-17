#lang racket

(require (prefix-in ffi: "../../lib/ffi-curses.rkt"))
(require "../base/base.rkt")

(provide (all-from-out "../../lib/ffi-curses.rkt")
         (prefix-out ffi: graph->ffi-graph))

(define (graph->ffi-graph graph)
  (define nodes (graph-nodes graph))

  (define ids (map (lambda (node) (node-id node)) nodes))
  
  (define positions
    (map (lambda (node)
           (define pos (node-position node))
           (list
            (exact->inexact (vec2-x pos))
            (exact->inexact (vec2-y pos)))) nodes))
  
  (define connectionCounts (map (lambda (node) (length (node-connections node))) nodes))
  
  (define connections
    (map (lambda (node)
           (define connections (node-connections node))
           (map (lambda (connection)
                  (list
                   (inexact->exact (connection-id connection))
                   (exact->inexact (connection-weight connection)))) connections)) nodes))
  #|
  (displayln ids)
  (displayln positions)
  (displayln connectionCounts)
  (displayln connections)
  |#
  
  (ffi:graphMake
   ids
   positions
   connectionCounts
   connections))

#|
(when ffi:is-available
      (define graph1
        (ffi:graphMake
         '( 0 1 2 3)
         '( (0.0 0.0) (0.0 0.0) (0.0 0.0) (0.0 0.0) )
         '( 2 1 1 0)
         '( ( (1 2.0) (2 1.0) )
            ( (3 1.0) )
            ( (3 1.0) )
            ()
            )))
      
      (define graph2
        (ffi:graphMake
         '( 0 1 2 3 4 5 6 7 8 9 10 11 12)
         '( (0.0 2.2) (1.05 1.95) (3.0 3.0) (0.2 1.4)
            (2.6 0.0) (0.4 0.8) (1.6 0.6) (1.0 1.2)
            (2.9 1.5) (3.9 1.4) (3.2 0.6) (3.4 2.4)
            (1.0 3.5) )
         '( 3 4 2 3 2 2 2 3 3 3 3 3 3)
         '( ( (1 3.0) (3 4.0) (12 7.0) ) ; A
            ( (0 3.0) (3 4.0) (7 1.0) (12 2.0) ) ; B
            ( (11 2.0) (12 3.0) ) ; C
            ( (0 4.0) (1 4.0) (5 5.0) ) ; D
            ( (6 2.0) (10 5.0) ) ; E
            ( (3 5.0) (7 3.0) ) ; F
            ( (4 2.0) (7 2.0) ) ; G
            ( (1 1.0) (5 3.0) (6 2.0) ) ; H
            ( (9 6.0) (10 4.0) (11 4.0) ) ; I
            ( (8 6.0) (10 4.0) (11 4.0) ) ; J
            ( (4 5.0) (8 4.0) (9 4.0) ) ; K
            ( (2 2.0) (8 4.0) (9 4.0) ) ; L
            ( (0 7.0) (1 2.0) (2 3.0) ) ; S
            )))
      
      (displayln (ffi:printGraph graph2))
      
      (define result (ffi:graphSolve graph2 0 4 2 3))
      
      (ffi:graphSolveResultIsFound result)
      (ffi:graphSolveResultPathSize result)
      (ffi:graphSolveResultPath result)
      )
|#
