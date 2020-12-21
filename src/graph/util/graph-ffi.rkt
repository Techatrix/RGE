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
