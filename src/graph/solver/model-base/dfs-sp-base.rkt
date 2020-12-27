#lang racket

(require "base.rkt")
(require "../util/graph-state-disco.rkt")
(require "../util/graph-searcher.rkt")
(require "../../base/base.rkt")

(provide dfs-sp)

(struct dfs-result (found distance disco))

(define (dfs-sp graph searcher state-searcher root-node-id goal-node-id)
  ; State:     discoverer 
  ; root-node: root-node-id ('discovered by itself')
  ; rest:      -1
  (define state (graph-state-disco-build graph searcher state-searcher))
  
  ; call internal algorithm loop
  (define result
    (dfs-sp-explore-node graph searcher state root-node-id root-node-id goal-node-id 0))
  
  ; reconstruct path if solution is found
  (if (dfs-result-found result)
      (graph-state-disco->route (dfs-result-disco result) root-node-id goal-node-id)
      #f))

(define (dfs-sp-explore-node graph searcher state origin-node-id node-id goal-node-id distance)
  ; mark the current node as discovered
  (define new-state (graph-state-disco-set-node-discover-id state node-id origin-node-id))
  
  (cond [(eq? node-id goal-node-id) (dfs-result #t distance new-state)]
        [else
         ; get all connections of the current node
         (define connections
           (node-connections ((searcher-get searcher) (graph-nodes graph) (node node-id #f #f))))
         ; explores all connections of the current node
         (dfs-sp-explore-connections
          graph searcher new-state
          connections node-id goal-node-id
          distance (dfs-result #f +inf.0 #f))]))

; explores all connections of a node and returns the best solution
(define (dfs-sp-explore-connections graph searcher state connections node-id goal-node-id distance current-state)
  (cond [(empty? connections) current-state]
        [; if the connection's node has not been discovered
         (not (graph-state-disco-get-node-discover-id state (connection-id (car connections))))
         (define con-id (connection-id (car connections)))
         (define new-state
           (dfs-sp-explore-node
            graph searcher state node-id con-id goal-node-id
            (+ distance (connection-weight (car connections)))))
         
         ; explore the connection's node
         (dfs-sp-explore-connections
          graph searcher state (rest connections) node-id goal-node-id distance
          ; if a solution has been found
          ; return the new solution if it is better than the current one(if there is one)
          (if (and (dfs-result-found new-state) 
                   (or (not (dfs-result-found current-state)) 
                       (< (dfs-result-distance new-state) (dfs-result-distance current-state))))
              new-state
              current-state))]
        [else 
         (dfs-sp-explore-connections ; explore the rest of the connections
          graph searcher state (rest connections) node-id goal-node-id distance current-state)]))
