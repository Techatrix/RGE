#lang racket

(require "../../base/base.rkt")
(require "tree.rkt")

(provide node-compare-by-id
         graph->binary-graph)

(define (node-compare-by-id node1 node2)
  (< (node-id node1) (node-id node2)))

(define (graph->binary-graph graph)
  (define nodes (graph-nodes graph))
  (define tree
    (cond [(empty? nodes) #f]
          [else
           (define sorted-nodes (sort nodes node-compare-by-id))
           (define root-node (list-ref sorted-nodes (floor (/ (length sorted-nodes) 2))))
           (define root-node-id (node-id root-node))
           (define root-tree-node (tree-node #f #f root-node))
           
           (foldl
            (lambda (node tree)
              (if (eq? root-node-id (node-id node))
                  tree
                  (tree-node-insert-value tree node node-compare-by-id)))
            root-tree-node sorted-nodes)]))
  (graph-set-nodes
   graph
   tree))