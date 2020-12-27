#lang racket

(require "base.rkt")
(require "../util/graph-state-disco.rkt")
(require "../util/graph-searcher.rkt")
(require "../../base/base-structures.rkt")

(provide dfs)

(define (dfs graph searcher state-searcher root-node-id goal-node-id)
  ; State:     discoverer 
  ; root-node: root-node-id ('discovered by itself')
  ; rest:      -1
  (define state (graph-state-disco-build graph searcher state-searcher))
  
  ; call internal algorithm loop
  (define-values (new-state found)
    (dfs-explore-node graph searcher state root-node-id root-node-id goal-node-id))
  
  ; reconstruct path if solution is found
  (if found
      (graph-state-disco->route new-state root-node-id goal-node-id)
      #f))

(define (dfs-explore-node graph searcher state origin-node-id node-id goal-node-id)
  ; mark the current node as discovered
  (define new-state (graph-state-disco-set-node-discover-id state node-id origin-node-id))
  
  (cond [(eq? node-id goal-node-id) (values new-state #t)] ; return solution if the node is the goal
        [else
         ; get all connections of the current node
         (define connections
           (node-connections ((searcher-get searcher) (graph-nodes graph) (node node-id #f #f))))
         ; explores all connections of the current node
         (dfs-explore-connections graph searcher new-state connections node-id goal-node-id)]))

; explores all connections of a node
(define (dfs-explore-connections graph searcher state connections node-id goal-node-id)
  (cond [(empty? connections) (values state #f)] ; return no solution if there are no more connections
        [; if the connection's node has not been discovered
         (not (graph-state-disco-get-node-discover-id state (connection-id (car connections))))
         (define con-id (connection-id (car connections)))
         ; explore the connection's node
         (define-values (new-state found)
           (dfs-explore-node graph searcher state node-id con-id goal-node-id))
         ; if a solution has been found
         (if (eq? found #t)
             (values new-state found) ; return it
             (dfs-explore-connections ; else: explore the rest of the connections
              graph searcher new-state (rest connections) node-id goal-node-id))]
        [else ; explore the rest of the connections
         (dfs-explore-connections graph searcher state (rest connections) node-id goal-node-id)]))
