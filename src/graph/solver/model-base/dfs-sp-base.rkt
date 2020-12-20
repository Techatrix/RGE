#lang racket

(require "base.rkt")
(require "../util/graph-state-disco.rkt")
(require "../util/graph-searcher.rkt")
(require "../util/queue.rkt")
(require "../../base/base-structures.rkt")
(require "../../../util/util.rkt")

(require "../../base/base.rkt")
(require "../model-O0/graph-searcher.rkt")

(provide dfs-sp)

(struct dfs-result (found distance disco))

(define (dfs-sp graph searcher state-searcher root-node-id goal-node-id)
  (define state (graph-state-disco-build graph searcher state-searcher))
  (define result
    (dfs-sp-explore-node graph searcher state root-node-id root-node-id goal-node-id 0))
  
  (if (dfs-result-found result)
      (graph-state-disco->route (dfs-result-disco result) root-node-id goal-node-id)
      #f))

(define (dfs-sp-explore-node graph searcher state origin-node-id node-id goal-node-id distance)
  (define new-state (graph-state-disco-node-discover state node-id origin-node-id))
  
  (cond [(eq? node-id goal-node-id) (dfs-result #t distance new-state)]
        [else
         (define connections
           (node-connections ((searcher-get searcher) (graph-nodes graph) (node node-id #f #f))))
         (dfs-sp-explore-connections
                graph searcher new-state
                connections node-id goal-node-id
                distance (dfs-result #f +inf.0 #f))]))

(define (dfs-sp-explore-connections
         graph searcher state connections node-id goal-node-id distance current-state)
  (cond [(empty? connections) current-state]
        [(graph-state-disco-get-node-found? state (connection-id (car connections)))
         (dfs-sp-explore-connections
          graph searcher state (rest connections) node-id goal-node-id distance current-state)]
        [else (define con-id (connection-id (car connections)))
              (define new-state
                (dfs-sp-explore-node
                 graph searcher state node-id con-id goal-node-id
                 (+ distance (connection-weight (car connections)))))
              
              (dfs-sp-explore-connections
               graph searcher state (rest connections) node-id goal-node-id distance
               (if (and (dfs-result-found new-state)
                        (or (not (dfs-result-found current-state))
                            (< (dfs-result-distance new-state) (dfs-result-distance current-state))))
                   new-state
                   current-state))]))
