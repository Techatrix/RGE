#lang racket

(require "../../../util/util.rkt")
(require "graph-state-disco.rkt")

(provide (all-defined-out)
         (all-from-out "graph-state-disco.rkt"))

(define (node-state-dijkstra-get-previous node-state)
  (car (node-state-data node-state)))
(define (node-state-dijkstra-get-distance node-state)
  (cadr (node-state-data node-state)))
(define (graph-state-dijkstra-node-get-previous graph-state id)
  (node-state-dijkstra-get-previous (graph-state-get-node graph-state id)))
(define (graph-state-dijkstra-node-get-distance graph-state id)
  (node-state-dijkstra-get-distance (graph-state-get-node graph-state id)))

(define (node-state-dijkstra-set-previous _node-state previous)
  (node-state (node-state-id _node-state) (list-replace-n (node-state-data _node-state) 0 previous)))
(define (node-state-dijkstra-set-distance _node-state distance)
  (node-state (node-state-id _node-state) (list-replace-n (node-state-data _node-state) 1 distance)))
(define (graph-state-dijkstra-node-set-previous graph-state id previous)
  (graph-state-set-node graph-state id
                        (node-state-dijkstra-set-previous
                         (graph-state-get-node graph-state id) previous)))
(define (graph-state-dijkstra-node-set-distance graph-state id distance)
  (graph-state-set-node graph-state id
                        (node-state-dijkstra-set-distance
                         (graph-state-get-node graph-state id) distance)))
