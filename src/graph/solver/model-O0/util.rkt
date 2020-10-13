#lang racket

(provide (except-out (all-defined-out)
                     _graph-state-discover-node))

(struct node-state (is-discovered? discoverer-id) #:transparent)

(struct graph-state (nodes) #:transparent)

(define (graph-get-route _graph-state) _graph-state)


(define (graph-state-build n)
  (graph-state (build-list n (lambda (x) (node-state #f #f)))))

(define (graph-state-discover-node _graph-state pos state)
  (graph-state (_graph-state-discover-node (graph-state-nodes _graph-state) pos state 0)))

(define (_graph-state-discover-node nodes pos state n)
  (cond [(empty? nodes) '()]
        [(eq? pos n) (cons state (rest nodes))]
        [else (cons (car nodes) (_graph-state-discover-node (rest nodes) pos state (+ n 1)))]))
