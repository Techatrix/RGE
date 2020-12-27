#lang racket

(require "base.rkt")
(require "../util/graph-state-dijkstra.rkt")
(require "../util/graph-searcher.rkt")
(require "../../base/base-structures.rkt")
(require "../../../util/util.rkt")

(provide dijkstra)

(define (dijkstra graph searcher state-searcher root-node-id goal-node-id)
  ; State:     previous distance of every node
  ; root-node: -1       0.0
  ; rest:      -1       +inf
  (define state
    (graph-state-dijkstra-node-set-distance
     (graph-state-dijkstra-build graph searcher state-searcher) root-node-id 0.0))

  ; list of nodes that need to be explored
  ; contains all nodes
  (define node-set ((searcher-list searcher)
                    ((searcher-map searcher) (graph-nodes graph) (lambda (node) (node-id node)))))
  
  ; call internal algorithm loop
  (define-values (new-state found)
    (dijkstra-call graph searcher state node-set goal-node-id))

  ; reconstruct path if solution is found
  (if found
      (graph-state-disco->route new-state root-node-id goal-node-id)
      #f))

; extracts one node from the node-set and explores it
(define (dijkstra-call graph searcher state node-set goal-node-id)
  (cond [(empty? node-set) (values state #f)] ; return no solution if the node-set is empty
        [else
         ; get Node in Q with min dist
         (define id (dijkstra-get-min-dist-node-id state node-set))
         
         (cond [(eq? id goal-node-id) (values state #t)]
               [else
                ; remove Node in the queue from the queue
                (define new-node-set (list-remove-eq node-set id))
         
                ; get the new state from dijkstra-update-state
                (define new-state (dijkstra-update-state graph searcher state new-node-set id))
         
                ; continue exploring with the new state and node-set
                (dijkstra-call graph searcher new-state new-node-set goal-node-id)])]))

; linear search to find the node with the lowest distance
(define (dijkstra-get-min-dist-node-id state node-set)
  (foldl
   (lambda (id1 id2)
     (if (< (graph-state-dijkstra-node-get-distance state id1)
            (graph-state-dijkstra-node-get-distance state id2))
         id1
         id2)) (car node-set) node-set))

(define (dijkstra-update-state graph searcher _state node-set id)
  ; distance from the root node to the given node
  (define distance (graph-state-dijkstra-node-get-distance _state id))

  ; loop over all connections
  (define (proc state connections)
    (cond [(empty? connections) state]
          [; if the connection's node has not been discovered
           (not (graph-state-dijkstra-node-get-previous state (connection-id (car connections))))
           (define c-id (connection-id (car connections)))
           (define alt-distance (+ distance (connection-weight (car connections))))
           (define old-distance (graph-state-dijkstra-node-get-distance state c-id))
           
           ; if the new distance is better than the current one
           (proc
            (if (< alt-distance old-distance)
                ; update the state based on the new path
                (graph-state-dijkstra-node-set-previous
                 (graph-state-dijkstra-node-set-distance state c-id alt-distance) c-id id)
                state)
            (rest connections))]
          [else (proc state (rest connections))]))
  
  ; call the loop with the connections of the given node
  (proc _state (node-connections ((searcher-get searcher) (graph-nodes graph) (node id #f #f)))))