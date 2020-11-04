#lang racket

(require "graph-state.rkt")
(require "queue.rkt")
(require "../../base/base.rkt")
(require "../../../util/util.rkt")

(provide bfs
         dfs)

; Breadth-first search
(define (bfs graph root-node-id goal-node-id)
  (define state (graph-state-build graph))
  (define new-state (graph-state-discover-node state root-node-id root-node-id))
  
  (define result (bfs-call graph (queue (list root-node-id)) new-state goal-node-id))
  (if (not (eq? result 'no-path))
      (graph-state->route result root-node-id goal-node-id)
      'no-path))

(define (bfs-call graph queue state goal-node-id)
  (cond [(queue-empty? queue) 'no-path]
        [else (define-values (dequeueed-queue node-id) (queue-dequeue queue))
              (define node (graph-get-node graph node-id))
              (cond [(eq? node-id goal-node-id) state]
                    [else (define connections (graph-get-node-connections graph node-id))
                          (define-values
                            (new-queue new-state)
                            (bfs-explore-connections connections dequeueed-queue state node-id))
                          (bfs-call graph new-queue new-state goal-node-id)])]))

(define (bfs-explore-connections connections queue state node-id)    
  (cond [(empty? connections) (values queue state)]
        [(node-state-is-discovered? (graph-state-search-node
                                     state
                                     (connection-id (car connections))))
         (bfs-explore-connections (rest connections) queue state node-id)]
        [else (define con-id (connection-id (car connections)))
              (define new_queue (queue-enqueue queue con-id))
              (define new_state (graph-state-discover-node state con-id node-id))
              (bfs-explore-connections (rest connections) new_queue new_state node-id)]))

; Depth-first search
(define (dfs graph root-node-id goal-node-id)
  (define state (graph-state-build graph))
  (define-values (new-state found)
    (dfs-explore-node graph state root-node-id root-node-id goal-node-id))
  
  (if (eq? found #t)
      (graph-state->route new-state root-node-id goal-node-id)
      'no-path))

(define (dfs-explore-node graph state origin-node-id node-id goal-node-id)
  (define new-state (graph-state-discover-node state node-id origin-node-id))
  
  (cond [(eq? node-id goal-node-id) (values new-state #t)]
        [else (define connections (graph-get-node-connections graph node-id))
              (dfs-explore-connections graph new-state connections node-id goal-node-id)]))

(define (dfs-explore-connections graph state connections node-id goal-node-id)
  (cond [(empty? connections) (values state #f)]
        [else (define con-id (connection-id (car connections)))
              (define-values (new-state found)
                (dfs-explore-node graph state node-id con-id goal-node-id))
              
              (if (eq? found #t)
                  (values new-state found)
                  (dfs-explore-connections graph
                                           new-state
                                           (rest connections)
                                           node-id
                                           goal-node-id))]))