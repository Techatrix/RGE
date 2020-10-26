#lang racket

(require "node-base.rkt")
(require "base-structures.rkt")
(require "../../util/util.rkt")

(provide (all-defined-out))

; nodes delete
(define (nodes-delete-node nodes id)
  (cond [(empty? nodes) '()]
        [(eq? (node-id (car nodes)) id) (nodes-delete-node (rest nodes) id)]
        [else (cons (node-delete-connection (car nodes) id) (nodes-delete-node (rest nodes) id))]))

(define (nodes-delete-connection nodes id)
  (if (empty? nodes)
      '()
      (cons (node-delete-connection (car nodes) id) (nodes-delete-connection (rest nodes) id))))

; nodes apply
(define (nodes-apply-node nodes id proc)
  (cond [(empty? nodes) '()]
        [(eq? (node-id (car nodes)) id) (cons (proc (car nodes)) (rest nodes))]
        [else (cons (car nodes) (nodes-apply-node (rest nodes) id proc))]))

; nodes search closest
(define (nodes-search-node-by-closest-position nodes pos)
  (cond [(empty? nodes) (void)]
        [else (define node1 (car nodes))
              (define node2 (nodes-search-node-by-closest-position (rest nodes) pos))
              (cond [(void? node2) node1]
                    [else (define dist1 (vec2-dist pos (node-position node1)))
                          (define dist2 (vec2-dist pos (node-position node2)))
                          (cond [(< dist1 dist2) node1]
                                [else node2])])]))

; graph get valid id
(define (graph-get-valid-id graph)
  (define nodes (graph-nodes graph))
  (define l (build-list (+ (length nodes) 1) (lambda (id) (nodes-contain-id nodes id))))

  (list-search-ref l (lambda (x) (not x))))

(define (nodes-contain-id nodes id)
  (cond [(empty? nodes) #f]
        [(eq? (node-id (car nodes)) id) #t]
        [else (nodes-contain-id (rest nodes) id)]))
