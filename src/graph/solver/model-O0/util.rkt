#lang racket
(require "../../base/base.rkt")

(provide (struct-out node-state)
         (struct-out graph-state)
         node-state-discover
         graph-state-build
         graph-state-search-node
         graph-state-discover-node
         graph-state->route)

(struct node-state (id is-discovered? discoverer-id) #:transparent)

(struct graph-state (nodes) #:transparent)

; node state
(define (node-state-discover _node-state discoverer-id)
  (node-state (node-state-id _node-state) #t discoverer-id))


; graph state
(define (graph-state-build graph)
  (graph-state (_graph-state-build (graph-nodes graph))))

(define (_graph-state-build nodes)
  (if (empty? nodes)
      '()
      (cons (node-state (node-id (car nodes)) #f #f) (_graph-state-build (rest nodes)))))


(define (graph-state-search-node _graph-state n)
  (_graph-state-search-node (graph-state-nodes _graph-state) n))

(define (_graph-state-search-node states n)
  (cond [(empty? states) void]
        [(eq? (node-state-id (car states)) n) (car states)]
        [else (_graph-state-search-node (rest states) n)]))


(define (graph-state-discover-node _graph-state n discoverer-id)
  (graph-state (_graph-state-discover-node (graph-state-nodes _graph-state) n discoverer-id)))

(define (_graph-state-discover-node states n discoverer-id)
  (cond [(empty? states) '()]
        [(eq? (node-state-id (car states)) n)
         (cons (node-state-discover (car states) discoverer-id) (rest states))]
        [else (cons (car states) (_graph-state-discover-node (rest states) n discoverer-id))]))

; graph-state->route
(define (graph-state->route graph-state root-node-id goal-node-id)
  (_graph-state->route graph-state root-node-id goal-node-id))

(define (_graph-state->route graph-state root-node-id current-node-id)
  (define state (graph-state-search-node graph-state current-node-id))
  (define discoverer-id (node-state-discoverer-id state))
  (cond [(eq? discoverer-id root-node-id) (list root-node-id current-node-id)]
        [else (append (_graph-state->route graph-state root-node-id discoverer-id)
                      (list current-node-id))]))