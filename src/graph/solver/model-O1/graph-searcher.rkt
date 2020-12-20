#lang racket

(require "../../base/base-structures.rkt")
(require "../util/graph-searcher.rkt")
(require "../util/graph-state.rkt")
(require "tree.rkt")

(provide searcher-graph-O1
         searcher-state-O1)

(define (get-comp proc) (lambda (v1 v2) (< (proc v1) (proc v2))))

(define (searcher-builder-O1 proc-get-value)
  (searcher
   (lambda (data value [proc proc-get-value])
     (tree-node-search data value (get-comp proc)))
   (lambda (data old-value new-value [proc proc-get-value])
     (tree-node-replace-value data old-value new-value (get-comp proc)))
   (lambda (data value [proc proc-get-value])
     (tree-node-insert-value data value (get-comp proc)))
   (lambda (data value [proc proc-get-value])
     (tree-node-remove-value data value (get-comp proc)))
   (lambda (data proc)
     (tree-node-map data proc))
   (lambda (data) (tree-node->list data))))

(define searcher-graph-O1 (searcher-builder-O1 node-id))
(define searcher-state-O1 (searcher-builder-O1 node-state-id))
