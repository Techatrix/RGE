#lang racket

(require "../../base/base.rkt")
(require "graph-state.rkt")

(provide graph-state-disco-build
         node-state-disco-discover
         graph-state-disco-node-discover
         graph-state-disco->route)

(define (node-state-disco-discover _node-state discoverer-id)
  (node-state (node-state-id _node-state) (list #t discoverer-id)))

(define (graph-state-disco-build graph)
  (graph-state (_graph-state-disco-build (graph-nodes graph))))

(define (_graph-state-disco-build nodes)
  (if (empty? nodes)
      '()
      (cons (node-state (node-id (car nodes)) (list #f #f))
            (_graph-state-disco-build (rest nodes)))))

(define (graph-state-disco-node-discover graph-state n discoverer-id)
  (define state (graph-state-get-node graph-state n))
  (graph-state-set-node graph-state n (node-state-disco-discover state discoverer-id)))

(define (graph-state-disco->route graph-state root-node-id goal-node-id)
  (define state (graph-state-get-node graph-state goal-node-id))
  (define discoverer-id (cadr (node-state-data state)))
  (cond [(not discoverer-id) (error "Invalid graph-state")]
        [(eq? discoverer-id root-node-id) (list root-node-id goal-node-id)]
        [else (append (graph-state-disco->route graph-state root-node-id discoverer-id)
                      (list goal-node-id))]))
