#lang racket

(require "node-base.rkt")
(require "base-structures.rkt")
(require "../../util/util.rkt")

(provide (all-defined-out))

; nodes delete
(define (nodes-delete-node nodes id)
  (cond [(empty? nodes) '()]
        [(eq? (node-id (car nodes)) id) (rest nodes)]
        [else (append (list (node-delete-connection (car nodes) id)) (nodes-delete-node (rest nodes) id))]))

; nodes apply
(define (nodes-apply-node nodes id proc)
  (cond [(empty? nodes) '()]
        [(eq? (node-id (car nodes)) id) (append (list (proc (car nodes))) (rest nodes))]
        [else (append (list (car nodes)) (nodes-apply-node (rest nodes) id proc))]))

; nodes sort
(define (sort-nodes nodes)
  (sort nodes (lambda (a b)
                (< (node-id a) (node-id b)))))

; nodes get valid id
(define (nodes-get-valid-id nodes counter)
  (cond [(empty? nodes) counter]
        [(eq? (node-id (car nodes)) counter) (nodes-get-valid-id (rest nodes) (add1 counter))]
        [else counter]))

; nodes search closest
(define (nodes-search-node-by-closest-position nodes pos)
  (cond [(empty? nodes) void]
        [else (define node1 (car nodes))
              (define node2 (nodes-search-node-by-closest-position (rest nodes) pos))
              (cond [(eq? node2 void) node1]
                    [else (define dist1 (dst-PtoP pos (node-position node1)))
                          (define dist2 (dst-PtoP pos (node-position node2)))
                          (cond [(< dist1 dist2) node1]
                                [else node2])])]))

; graph get valid id
(define (graph-get-valid-id graph)
  (nodes-get-valid-id (sort-nodes (graph-nodes graph)) 0))
