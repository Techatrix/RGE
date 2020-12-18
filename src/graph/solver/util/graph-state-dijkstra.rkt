#lang racket

(require "../../../util/util.rkt")
(require "../../base/base-structures.rkt")
(require "graph-state-disco.rkt")

(provide node-state-dijkstra-get-distance
         node-state-dijkstra-get-previous
         graph-state-dijkstra-node-get-distance
         graph-state-dijkstra-node-get-previous
         node-state-dijkstra-set-distance
         node-state-dijkstra-set-previous
         graph-state-dijkstra-node-set-distance
         graph-state-dijkstra-node-set-previous
         graph-state-dijkstra->route
         (all-from-out "graph-state-disco.rkt"))

(define (node-state-dijkstra-get-distance node-state)
  (car (node-state-data node-state)))
(define (node-state-dijkstra-get-previous node-state)
  (cadr (node-state-data node-state)))
(define (graph-state-dijkstra-node-get-distance graph-state n)
  (node-state-dijkstra-get-distance (graph-state-get-node graph-state n)))
(define (graph-state-dijkstra-node-get-previous graph-state n)
  (node-state-dijkstra-get-previous (graph-state-get-node graph-state n)))

(define (node-state-dijkstra-set-distance _node-state distance)
  (node-state (node-state-id _node-state) (list-replace-n (node-state-data _node-state) 0 distance)))
(define (node-state-dijkstra-set-previous _node-state previous)
  (node-state (node-state-id _node-state) (list-replace-n (node-state-data _node-state) 1 previous)))
(define (graph-state-dijkstra-node-set-distance graph-state n distance)
  (graph-state-set-node
   graph-state
   n
   (node-state-dijkstra-set-distance (graph-state-get-node graph-state n) distance)))
(define (graph-state-dijkstra-node-set-previous graph-state n previous)
  (graph-state-set-node
   graph-state
   n
   (node-state-dijkstra-set-previous (graph-state-get-node graph-state n) previous)))

(define (graph-state-dijkstra->route graph-state root-node-id goal-node-id)
  (graph-state-disco->route graph-state root-node-id goal-node-id))
