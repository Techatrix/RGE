#lang racket

(require "../../base/base-structures.rkt")
(require "../util/graph-searcher.rkt")
(require "../util/graph-state.rkt")
(require "tree.rkt")

(provide searcher-O1
         searcher-state-O1)

(define (searcher-builder proc1 proc2 proc3)
  (define comp
    (lambda (node1 node2)
      (< (proc2 node1) (proc2 node2))))
  (searcher
   (lambda (data id) (tree-node-search (proc1 data) (proc3 id) comp))
   (lambda (data id value) (tree-node-replace-value (proc1 data) (proc3 id) value comp))
   (lambda (data value) (tree-node-insert-value (proc1 data) value comp))
   (lambda (data id) (tree-node-remove-value (proc1 data) (proc3 id) comp))
   (lambda (data proc) (tree-node-map (proc1 data) proc))))

(define searcher-O1
  (searcher-builder graph-nodes node-id (lambda (id) (node id #f #f))))
(define searcher-state-O1
  (searcher-builder graph-state-nodes node-state-id (lambda (id) (node-state id '()))))
