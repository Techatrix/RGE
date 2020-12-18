#lang racket

(require "../../base/base-structures.rkt")
(require "../../../util/util.rkt")
(require "../util/graph-searcher.rkt")
(require "../util/graph-state.rkt")

(provide searcher-O0
         searcher-state-O0)

(define (searcher-builder proc1 proc2)
  (searcher
   (lambda (data id) (list-search (proc1 data) (lambda (node) (eq? (proc2 node) id))))
   (lambda (data id value) (list-replace (proc1 data) (lambda (node) (eq? (proc2 node) id)) value))
   (lambda (data value) (cons value (proc1 data)))
   (lambda (data id) (list-remove (proc1 data) (lambda (node) (eq? (proc2 node) id))))
   (lambda (data proc) (map (lambda (node) (proc node)) (proc1 data)))))

(define searcher-O0 (searcher-builder graph-nodes node-id))
(define searcher-state-O0 (searcher-builder graph-state-nodes node-state-id))
