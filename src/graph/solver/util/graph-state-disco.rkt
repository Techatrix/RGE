#lang racket

(require "../../base/base-structures.rkt")
(require "graph-state.rkt")

(provide node-state-disco-discover
         graph-state-disco-get-node-found?
         graph-state-disco-get-node-discover-id
         graph-state-disco-node-discover
         graph-state-disco->route
         (all-from-out "graph-state.rkt"))


(define (node-state-disco-discover _node-state discoverer-id)
  (node-state (node-state-id _node-state) (list #t discoverer-id)))

(define (graph-state-disco-get-node-found? graph-state id)
  (car (node-state-data (graph-state-get-node graph-state id))))

(define (graph-state-disco-get-node-discover-id graph-state id)
  (cadr (node-state-data (graph-state-get-node graph-state id))))

(define (graph-state-disco-node-discover graph-state id discoverer-id)
  (define state (graph-state-get-node graph-state id))
  (graph-state-set-node graph-state id (node-state-disco-discover state discoverer-id)))

(define (graph-state-disco->route graph-state root-node-id goal-node-id)
  (define state (graph-state-get-node graph-state goal-node-id))
  (define discoverer-id (cadr (node-state-data state)))
  (cond [(not discoverer-id) (error "Invalid graph-state")]
        [(eq? discoverer-id root-node-id) (list root-node-id goal-node-id)]
        [else (append (graph-state-disco->route graph-state root-node-id discoverer-id)
                      (list goal-node-id))]))
