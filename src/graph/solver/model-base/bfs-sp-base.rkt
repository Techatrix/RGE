#lang racket

(require "base.rkt")
(require "../util/graph-state-dijkstra.rkt")
(require "../util/graph-searcher.rkt")
(require "../../base/base-structures.rkt")
; (require "../../../util/util.rkt")
(require "../util/queue.rkt")

(provide bfs-sp)

(define (bfs-sp graph searcher state-searcher root-node-id goal-node-id)
  ; State:     previous distance of every node
  ; root-node: #f       0.0
  ; rest:      #f       +inf
  (define state
    (graph-state-dijkstra-node-set-distance
      (graph-state-dijkstra-build graph searcher state-searcher) root-node-id 0.0))
  
  ; queue of nodes that need to be explored
  (define qqueue (queue (list root-node-id)))
  
  ; call internal algorithm loop
  (define-values (new-state found)
    (bfs-sp-call graph searcher state qqueue goal-node-id))

  ; reconstruct path if solution is found
  (if found
      (graph-state-disco->route new-state root-node-id goal-node-id)
      #f))

; extracts one node from the queue and explores it
(define (bfs-sp-call graph searcher state queue goal-node-id)
  (cond [(queue-empty? queue) (values state #t)] ; return the state if the queue is empty
        [else
         ; dequeue one node from the queue
         (define-values (dequeueed-queue id) (queue-dequeue queue))
         
         ; get the new state & queue from bfs-sp-update-state
         (define-values (new-state new-queue)
           (bfs-sp-update-state graph searcher state dequeueed-queue id))
         
         ; continue exploring with the new state and queue
         (bfs-sp-call graph searcher new-state new-queue goal-node-id)]))

(define (bfs-sp-update-state graph searcher _state _queue id)
  ; distance from the root node to the given node
  (define distance (graph-state-dijkstra-node-get-distance _state id))

  ; loop over all connections
  (define (proc state queue connections)
    (cond [(empty? connections) (values state queue)]
          [else
           (define c-id (connection-id (car connections)))
           (define alt-distance (+ distance (connection-weight (car connections))))
           (define old-distance (graph-state-dijkstra-node-get-distance state c-id))

           ; if the new distance is better than the current one
           (cond [(< alt-distance old-distance)
                  (proc
                   (graph-state-dijkstra-node-set-previous
                    (graph-state-dijkstra-node-set-distance state c-id alt-distance) c-id id)
                   (queue-enqueue queue c-id)
                   (rest connections))]
                 [else
                  (proc state queue (rest connections))])]))
  
  ; call the loop with the connections of the given node
  (proc
   _state
   _queue
   (node-connections ((searcher-get searcher) (graph-nodes graph) (node id #f #f)))))
