#lang racket

(require "base.rkt")
(require "../util/graph-state-disco.rkt")
(require "../util/graph-searcher.rkt")
(require "../util/queue.rkt")
(require "../../base/base-structures.rkt")

(provide bfs)

; Breadth-first search
(define (bfs graph searcher state-searcher root-node-id goal-node-id)
  ; State:     discoverer 
  ; root-node: root-node-id ('discovered by itself')
  ; rest:      -1
  (define state
    (graph-state-disco-set-node-discover-id
     (graph-state-disco-build graph searcher state-searcher) root-node-id root-node-id))

  ; call internal algorithm loop
  (define-values (new-state found)
    (bfs-call graph searcher (queue (list root-node-id)) state goal-node-id))
  
  ; reconstruct path if solution is found
  (if found
      (graph-state-disco->route new-state root-node-id goal-node-id)
      #f))

; dequeues one node from the node-set and explores it
(define (bfs-call graph searcher queue state goal-node-id)
  (cond [(queue-empty? queue) (values state #f)] ; return no solution if the queue is empty
        [else ; dequeue one node from the queue
         (define-values (dequeueed-queue node-id) (queue-dequeue queue))
         (cond [(eq? node-id goal-node-id) (values state #t)] ; return solution if the node is the goal
               [else
                (define current-node
                  ((searcher-get searcher) (graph-nodes graph) (node node-id #f #f)))
                ; get all connections of the current node
                (define connections (node-connections current-node))
                (define-values
                  (new-queue new-state)
                  (bfs-explore-connections connections dequeueed-queue state node-id))
                ; recursive call
                (bfs-call graph searcher new-queue new-state goal-node-id)])]))

; updates the state and queue based on the connections of the given node
(define (bfs-explore-connections connections queue state node-id)
  (cond [(empty? connections) (values queue state)]
        [; if the connection's node has not been discovered
         (not (graph-state-disco-get-node-discover-id state (connection-id (car connections))))
         (define con-id (connection-id (car connections)))
         (define new_queue (queue-enqueue queue con-id))
         ; update the state
         (define new_state (graph-state-disco-set-node-discover-id state con-id node-id))
         ; explorer the rest of the connections
         (bfs-explore-connections (rest connections) new_queue new_state node-id)]
        [else (bfs-explore-connections (rest connections) queue state node-id)]))
