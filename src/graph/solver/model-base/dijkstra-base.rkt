#lang racket

(require "base.rkt")
(require "../util/graph-state-dijkstra.rkt")
(require "../util/graph-searcher.rkt")
(require "../util/queue.rkt")
(require "../../base/base-structures.rkt")
(require "../../../util/util.rkt")

(provide dijkstra)

(define (dijkstra graph searcher state-searcher root-node-id goal-node-id)
  (define state
    (graph-state-dijkstra-node-set-distance
     (graph-state-dijkstra-build graph searcher state-searcher) root-node-id 0.0))

  (define node-set ((searcher-list searcher)
                    ((searcher-map searcher) (graph-nodes graph) (lambda (node) (node-id node)))))
  
  (define-values (new-state found)
    (dijkstra-call graph searcher state node-set goal-node-id))

  (if found
      (graph-state-disco->route new-state root-node-id goal-node-id)
      #f))

(define (dijkstra-call graph searcher state node-set goal-node-id)
  (cond [(empty? node-set) (values state #f)]
        [else
         ; get Node in Q with min dist
         (define id (dijkstra-get-min-dist-node-id state node-set))
         
         (cond [(eq? id goal-node-id) (values state #t)]
               [else
                ; remove Node in Q from Q
                (define new-node-set (list-remove-eq node-set id))
         
                ; get new-state from dijkstra-update-state
                (define new-state (dijkstra-update-state graph searcher state new-node-set id))
         
                ; call dijkstra-call with new-state & new-node-set
                (dijkstra-call graph searcher new-state new-node-set goal-node-id)])]))

(define (dijkstra-get-min-dist-node-id state node-set)
  (foldr
   (lambda (id1 id2)
     (if (< (graph-state-dijkstra-node-get-distance state id1)
            (graph-state-dijkstra-node-get-distance state id2))
         id1
         id2)) (car node-set) node-set))

(define (dijkstra-update-state graph searcher _state node-set id)
  (define distance (graph-state-dijkstra-node-get-distance _state id))

  (define (proc state connections)
    (cond [(empty? connections) state]
          [(not (graph-state-dijkstra-node-get-previous state (connection-id (car connections))))
           (define c-id (connection-id (car connections)))
           (define alt-distance (+ distance (connection-weight (car connections))))
           (define old-distance (graph-state-dijkstra-node-get-distance state c-id))
           
           (proc
            (if (< alt-distance old-distance)
                     (graph-state-dijkstra-node-set-previous
                      (graph-state-dijkstra-node-set-distance state c-id alt-distance) c-id id)
                     state)
            (rest connections))]
          [else (proc state (rest connections))]))
  
  (proc _state (node-connections ((searcher-get searcher) (graph-nodes graph) (node id #f #f)))))