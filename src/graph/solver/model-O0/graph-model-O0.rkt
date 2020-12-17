#lang racket

(require "graph-state.rkt")
(require "graph-state-disco.rkt")
(require "graph-state-dijkstra.rkt")
(require "queue.rkt")
(require "../../base/base.rkt")
(require "../../../util/util.rkt")

(provide bfs
         dfs
         dijkstra
         a-star)

; Breadth-first search
(define (bfs graph root-node-id goal-node-id)
  (define state
    (graph-state-disco-node-discover (graph-state-disco-build graph) root-node-id root-node-id))

  (define-values (new-state found)
    (bfs-call graph (queue (list root-node-id)) state goal-node-id))
  
  (if (eq? found #t)
      (graph-state-disco->route new-state root-node-id goal-node-id)
      #f))

(define (bfs-call graph queue state goal-node-id)
  (cond [(queue-empty? queue) (values state #f)]
        [else (define-values (dequeueed-queue node-id) (queue-dequeue queue))
              (define node (graph-get-node graph node-id))
              (cond [(eq? node-id goal-node-id) (values state #t)]
                    [else (define connections (graph-get-node-connections graph node-id))
                          (define-values
                            (new-queue new-state)
                            (bfs-explore-connections connections dequeueed-queue state node-id))
                          (bfs-call graph new-queue new-state goal-node-id)])]))

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

; Depth-first search
(define (dfs graph root-node-id goal-node-id)
  (define state (graph-state-disco-build graph))
  (define-values (new-state found)
    (dfs-explore-node graph state root-node-id root-node-id goal-node-id))
  
  (if (eq? found #t)
      (graph-state-disco->route new-state root-node-id goal-node-id)
      #f))

(define (dfs-explore-node graph state origin-node-id node-id goal-node-id)
  (define new-state (graph-state-disco-node-discover state node-id origin-node-id))
  
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
                  (dfs-explore-connections
                   graph
                   new-state
                   (rest connections)
                   node-id
                   goal-node-id))]))
; Dijkstra search
(define (dijkstra graph root-node-id goal-node-id)
  (define state
    (graph-state-dijkstra-node-set-distance (graph-state-dijkstra-build graph) root-node-id 0.0))

  (define node-set (foldl (lambda (node ids) (cons (node-id node) ids)) '() (graph-nodes graph)))
  
  (define-values (new-state found)
    (dijkstra-call graph state node-set goal-node-id))

  (if found
      (graph-state-disco->route new-state root-node-id goal-node-id)
      #f))

(define (dijkstra-call graph state node-set goal-node-id)
  (cond [(empty? node-set) (values state #f)]
        [else
         ; get Node in Q with min dist
         (define id (dijkstra-get-min-dist-node-id state node-set))
         
         (cond [(eq? id goal-node-id) (values state #t)]
               [else
                ; remove Node in Q from Q
                (define new-node-set (list-remove-eq node-set id))
         
                ; get new-state from dijkstra-update-state
                (define new-state (dijkstra-update-state graph state new-node-set id))
         
                ; call dijkstra-call with new-state & new-node-set
                (dijkstra-call graph new-state new-node-set goal-node-id)])]))

(define (dijkstra-get-min-dist-node-id state node-set)
  (foldr
   (lambda (id1 id2)
     (if (< (graph-state-dijkstra-node-get-distance state id1)
            (graph-state-dijkstra-node-get-distance state id2))
         id1
         id2)) (car node-set) node-set))

(define (dijkstra-update-state graph _state node-set id)
  (define distance (graph-state-dijkstra-node-get-distance _state id))

  (define (proc state connections)
    (cond [(empty? connections) state]
          [(not (list-search-eq node-set (connection-id (car connections))))
           (proc state (rest connections))]
          [else
           (define c-id (connection-id (car connections)))
           (define alt-distance (+ distance (connection-weight (car connections))))
           (define old-distance
             (graph-state-dijkstra-node-get-distance state c-id))
           
           (define new-state
             (cond [(< alt-distance old-distance)
                    (define temp-state (graph-state-dijkstra-node-set-distance state c-id alt-distance))
                    (graph-state-dijkstra-node-set-previous temp-state c-id id)]
                   [else state]))
           
           (proc new-state (rest connections))])
    )
  (proc _state (graph-get-node-connections graph id)))

; A-Star search
(define (a-star graph root-node-id goal-node-id)
  #f)