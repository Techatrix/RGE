#lang racket

(require "util.rkt")
(require "../../base/base.rkt")
(require "../../../util/util.rkt")

(provide bfs
         dfs)

; Breadth-first search
(define (bfs graph root-node-id goal-node-id)
  (define state (graph-state-build (length (graph-nodes graph))))
  (define new-state (graph-state-discover-node state root-node-id (node-state #t root-node-id)))
  (graph-get-route (bfs-call graph (list root-node-id) new-state goal-node-id)))

(define (bfs-call graph queue state goal-node-id)
  (cond [(empty? queue) 'no-path]
        [else 
         (define node (graph-get-node graph (last queue)))
         (define id (node-id node))
         (define dequeueed-list (list-remove-last queue))
         (cond [(eq? id goal-node-id) state]
               [else (define connections (graph-get-node-connections graph id))
                     (define-values
                       (new-queue new-state)
                       (bfs-explore-connections connections dequeueed-list state id))
                     (bfs-call graph new-queue new-state goal-node-id)])]))

(define (bfs-explore-connections connections queue state node-id)    
  (cond [(empty? connections) (values queue state)]
        [(node-state-is-discovered? (list-ref (graph-state-nodes state)
                                              (connection-id (car connections))))
         (bfs-explore-connections (rest connections) queue state node-id)]
        [else (define con-id (connection-id (car connections)))
              (define new_queue (cons con-id queue))
              (define new_state (graph-state-discover-node state con-id (node-state #t node-id)))
              (bfs-explore-connections (rest connections) new_queue new_state node-id)]))

; Depth-first search
(define (dfs graph root-node-id goal-node-id)
  (define state (graph-state-build (length (graph-nodes graph))))
  (graph-get-route (dfs-explore-node graph state root-node-id goal-node-id)))

(define (dfs-explore-node graph state node-id goal-node-id)
  (define new-state (graph-state-discover-node state node-id (node-state #t node-id)))
  (define connections (graph-get-node-connections graph node-id))
  (dfs-explore-connections graph new-state connections node-id goal-node-id))

(define (dfs-explore-connections graph state connections node-id goal-node-id)
  (cond [(or (empty? connections) (eq? (connection-id (car connections)) goal-node-id)) state]
        [else (define con-id (connection-id (car connections))) 
              (define result (dfs-explore-node graph state con-id goal-node-id))
              (if (node? result)
                  result
                  (dfs-explore-connections graph result (rest connections) node-id goal-node-id))]))
