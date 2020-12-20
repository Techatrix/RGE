#lang racket

(require "base.rkt")
(require "../util/graph-state-disco.rkt")
(require "../util/graph-searcher.rkt")
(require "../util/queue.rkt")
(require "../../base/base-structures.rkt")
(require "../../../util/util.rkt")

(provide bfs)

; Breadth-first search
(define (bfs graph searcher state-searcher root-node-id goal-node-id)
  (define state
    (graph-state-disco-node-discover
     (graph-state-disco-build graph searcher state-searcher) root-node-id root-node-id))

  (define-values (new-state found)
    (bfs-call graph searcher (queue (list root-node-id)) state goal-node-id))
  
  (if found
      (graph-state-disco->route new-state root-node-id goal-node-id)
      #f))

(define (bfs-call graph searcher queue state goal-node-id)
  (cond [(queue-empty? queue) (values state #f)]
        [else (define-values (dequeueed-queue node-id) (queue-dequeue queue))
              (cond [(eq? node-id goal-node-id) (values state #t)]
                    [else
                     (define current-node
                       ((searcher-get searcher) (graph-nodes graph) (node node-id #f #f)))
                     (define connections (node-connections current-node))
                     (define-values
                       (new-queue new-state)
                       (bfs-explore-connections connections dequeueed-queue state node-id))
                     (bfs-call graph searcher new-queue new-state goal-node-id)])]))

(define (bfs-explore-connections connections queue state node-id)    
  (cond [(empty? connections) (values queue state)]
        [(cadr (node-state-data (graph-state-get-node
                                 state
                                 (connection-id (car connections)))))
         (bfs-explore-connections (rest connections) queue state node-id)]
        [else (define con-id (connection-id (car connections)))
              (define new_queue (queue-enqueue queue con-id))
              (define new_state (graph-state-disco-node-discover state con-id node-id))
              (bfs-explore-connections (rest connections) new_queue new_state node-id)]))
