#lang racket

(require "base.rkt")
(require "../util/graph-state-a-star.rkt")
(require "../util/graph-searcher.rkt")
(require "../../base/base.rkt")
(require "../../../util/util.rkt")

(provide a-star)

(define (a-star graph searcher state-searcher root-node-id goal-node-id [proc-dist vec2-dist])
  (define goal-node ((searcher-get searcher) (graph-nodes graph) (node goal-node-id #f #f)))
  (cond [(not goal-node) #f]
        [else
         (define goal-node-position (node-position goal-node))

         ; define a-star heuristic function based on the given distance function
         (define h
           (lambda (id)
             (define pos (node-position ((searcher-get searcher) (graph-nodes graph) (node id #f #f))))
             (proc-dist goal-node-position pos)))

         ; State:     previous g-score & f-score of every node
         ; root-node: -1       0.0       h(root-node)
         ; rest:      -1       +inf      +inf
         (define state
           (graph-state-a-star-node-set-fscore
            (graph-state-a-star-node-set-gscore
             (graph-state-a-star-build graph searcher state-searcher)
             root-node-id
             0.0)
            root-node-id
            (h root-node-id)))

         ; list of nodes that need to be explored
         ; contains the root-node
         (define node-set (list root-node-id))
         
         ; call internal algorithm loop
         (define-values (new-state found)
           (a-star-call graph searcher state node-set goal-node-id h))

         ; reconstruct path if solution is found
         (if found
             (graph-state-disco->route new-state root-node-id goal-node-id)
             #f)]))

; extracts one node from the node-set and explores it
(define (a-star-call graph searcher state node-set goal-node-id h)
  (cond [(empty? node-set) (values state #f)] ; return no solution if the node-set is empty
        [else
         ; get Node in Q with min f-score
         (define id (a-star-get-min-fscore-node-id state node-set))
         
         (cond [(eq? id goal-node-id) (values state #t)]
               [else
                ; remove Node in the queue from the queue
                (define new-node-set (list-remove-eq node-set id))
         
                ; get the new state & node-set from a-star-update-state
                (define-values (new-state newer-node-set)
                  (a-star-update-state graph searcher state new-node-set id h))
         
                ; continue exploring with the new state and node-set
                (a-star-call graph searcher new-state newer-node-set goal-node-id h)])]))

; linear search to find the node with the lowest f-score
(define (a-star-get-min-fscore-node-id state node-set)
  (foldl
   (lambda (id1 id2)
     (if (< (graph-state-a-star-node-get-fscore state id1)
            (graph-state-a-star-node-get-fscore state id2))
         id1
         id2)) (car node-set) node-set))

; updates the state and node-set based on the connections of the given node
(define (a-star-update-state graph searcher _state _node-set id h)
  ; distance from the root node to the given node
  (define distance (graph-state-a-star-node-get-gscore _state id))

  ; loop over all connections
  (define (proc state node-set connections)
    (cond [(empty? connections) (values state node-set)]
          [else
           (define c-id (connection-id (car connections)))
           (define tentative-gscore (+ distance (connection-weight (car connections))))
           (define old-gscore (graph-state-a-star-node-get-gscore state c-id))

           ; if the new found score is better than the current one
           (cond [(< tentative-gscore old-gscore)
                  (define fscore (+ tentative-gscore (h c-id)))
                  ; update the state based on the new path
                  (define new-node-state
                    (node-state-a-star-set-fscore
                     (node-state-a-star-set-gscore
                      (node-state-a-star-set-previous
                       (graph-state-get-node state c-id) id) tentative-gscore) fscore))
                  (proc (graph-state-set-node state c-id new-node-state)
                        (cons c-id node-set)
                        (rest connections))]
                 [else (proc state node-set (rest connections))])]))
  
  ; call the loop with the connections of the given node
  (proc _state _node-set
        (node-connections ((searcher-get searcher) (graph-nodes graph) (node id #f #f)))))