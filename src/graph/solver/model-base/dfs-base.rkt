#lang racket

(require "base.rkt")
(require "../util/graph-state-disco.rkt")
(require "../util/graph-searcher.rkt")
(require "../util/queue.rkt")
(require "../../base/base-structures.rkt")
(require "../../../util/util.rkt")

(provide dfs)

(define (dfs graph searcher state-searcher root-node-id goal-node-id)
  (define state (graph-state-disco-build graph searcher state-searcher))
  (define-values (new-state found)
    (dfs-explore-node graph searcher state root-node-id root-node-id goal-node-id))
  
  (if (eq? found #t)
      (graph-state-disco->route new-state root-node-id goal-node-id)
      #f))

(define (dfs-explore-node graph searcher state origin-node-id node-id goal-node-id)
  (define new-state (graph-state-disco-node-discover state node-id origin-node-id))
  
  (cond [(eq? node-id goal-node-id) (values new-state #t)]
        [else (define connections (node-connections ((searcher-get searcher) graph node-id)))
              (dfs-explore-connections graph searcher new-state connections node-id goal-node-id)]))

(define (dfs-explore-connections graph searcher state connections node-id goal-node-id)
  (cond [(empty? connections) (values state #f)]
        [(graph-state-disco-get-node-found? state (connection-id (car connections)))
         (dfs-explore-connections graph searcher state (rest connections) node-id goal-node-id)]
        [else (define con-id (connection-id (car connections)))
         (define-values (new-state found)
                (dfs-explore-node graph searcher state node-id con-id goal-node-id))
              
              (if (eq? found #t)
                  (values new-state found)
                  (dfs-explore-connections
                   graph
                   new-state
                   (rest connections)
                   node-id
                   goal-node-id))]))