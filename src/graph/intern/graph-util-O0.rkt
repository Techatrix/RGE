#lang racket

(require "node-O0.rkt")
(require "../../util/util.rkt")

(provide (all-defined-out))

; nodes delete
(define (nodes-delete-node-O0 nodes id)
  (cond [(empty? nodes) '()]
        [(eq? (car (car nodes)) id) (rest nodes)]
        [else (append (list (node-delete-connection-O0 (car nodes) id)) (nodes-delete-node-O0 (rest nodes) id))]))

; graph set nodes
(define (graph-set-nodes-O0 graph nodes)
  (append (list nodes) (rest graph)))

; nodes apply
(define (nodes-apply-node-O0 nodes id proc)
  (cond [(empty? nodes) '()]
        [(eq? (node-get-id-O0 (car nodes)) id) (append (list (proc (car nodes))) (rest nodes))]
        [else (append (list (car nodes)) (nodes-apply-node-O0 (rest nodes) id proc))]))

; nodes sort
(define (sort-nodes-O0 nodes)
  (sort nodes (lambda (p1 p2)
                (< (car p1) (car p2)))))

; nodes get valid id
(define (nodes-get-valid-id-O0 nodes counter)
  (cond [(empty? nodes) counter]
        [(eq? (car (car nodes)) counter) (nodes-get-valid-id-O0 (rest nodes) (add1 counter))]
        [else counter]))

; nodes search closest
(define (nodes-search-node-by-closest-position-O0 nodes pos)
  (cond [(empty? nodes) void]
        [else (define node1 (car nodes))
              (define node2 (nodes-search-node-by-closest-position-O0 (rest nodes) pos))
              (cond [(eq? node2 void) node1]
                    [else (define dist1 (dst-PtoP pos (second node1)))
                          (define dist2 (dst-PtoP pos (second node2)))
                          (cond [(< dist1 dist2) node1]
                                [else node2])])]))

; graph get valid id
(define (graph-get-valid-id-O0 graph)
  (nodes-get-valid-id-O0 (sort-nodes-O0 (car graph)) 0))
