#lang racket

(require "graph-state.rkt")

(provide (all-defined-out)
         (all-from-out "graph-state.rkt"))

(define (node-state-disco-get-node-discover-id node-state)
  (car (node-state-data node-state)))
(define (graph-state-disco-get-node-discover-id graph-state id)
  (node-state-disco-get-node-discover-id (graph-state-get-node graph-state id)))

(define (node-state-disco-set-node-discover-id _node-state discoverer-id)
  (node-state (node-state-id _node-state) (list discoverer-id)))
(define (graph-state-disco-set-node-discover-id graph-state id discoverer-id)
  (graph-state-set-node graph-state id
                        (node-state-disco-set-node-discover-id
                         (graph-state-get-node graph-state id) discoverer-id)))

; parse disco to route
(define (graph-state-disco->route graph-state root-node-id goal-node-id)
  (cond [(eq? root-node-id goal-node-id) (list root-node-id)]
        [else
         (define discoverer-id (graph-state-disco-get-node-discover-id graph-state goal-node-id))
         (cond [(not discoverer-id) (error "Invalid graph-state")]
               [else (append (graph-state-disco->route graph-state root-node-id discoverer-id)
                             (list goal-node-id))])]))
