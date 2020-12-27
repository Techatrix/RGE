#lang racket

(require "base.rkt")
(require "../util/graph-state-a-star.rkt")
(require "../util/graph-searcher.rkt")
(require "../util/queue.rkt")
(require "../../base/base.rkt")
(require "../../../util/util.rkt")

(provide a-star)

(define (a-star graph searcher state-searcher root-node-id goal-node-id [proc-dist vec2-dist])
  (define goal-node ((searcher-get searcher) (graph-nodes graph) (node goal-node-id #f #f)))
  (cond [(not goal-node) #f]
        [else
         (define goal-node-position (node-position goal-node))
  
         (define h
           (lambda (id)
             (define pos (node-position ((searcher-get searcher) (graph-nodes graph) (node id #f #f))))
             (proc-dist goal-node-position pos)))
  
         (define state
           (graph-state-a-star-node-set-fscore
            (graph-state-a-star-node-set-gscore
             (graph-state-a-star-build graph searcher state-searcher)
             root-node-id
             0.0)
            root-node-id
            (h root-node-id)))
         
         (define node-set (list root-node-id))
         
         (define-values (new-state found)
           (a-star-call graph searcher state node-set goal-node-id h))
         
         (if found
             (graph-state-disco->route new-state root-node-id goal-node-id)
             #f)]))

(define (a-star-call graph searcher state node-set goal-node-id h)
  (cond [(empty? node-set) (values state #f)]
        [else
         ; get Node in Q with min fscore
         (define id (a-star-get-min-fscore-node-id state node-set))
         
         (cond [(eq? id goal-node-id) (values state #t)]
               [else
                ; remove Node in Q from Q
                (define new-node-set (list-remove-eq node-set id))
         
                ; get new-state & newer-node-set from a-star-update-state
                (define-values (new-state newer-node-set)
                  (a-star-update-state graph searcher state new-node-set id h))
         
                ; call a-star-call with new-state & newer-node-set
                (a-star-call graph searcher new-state newer-node-set goal-node-id h)])]))

(define (a-star-get-min-fscore-node-id state node-set)
  (foldr
   (lambda (id1 id2)
     (if (< (graph-state-a-star-node-get-fscore state id1)
            (graph-state-a-star-node-get-fscore state id2))
         id1
         id2)) (car node-set) node-set))

(define (a-star-update-state graph searcher _state _node-set id h)
  (define distance (graph-state-a-star-node-get-gscore _state id))

  (define (proc state node-set connections)
    (cond [(empty? connections) (values state node-set)]
          [else
           (define c-id (connection-id (car connections)))
           (define tentative-gscore (+ distance (connection-weight (car connections))))
           (define old-gscore (graph-state-a-star-node-get-gscore state c-id))

           (cond [(< tentative-gscore old-gscore)
                  (define fscore (+ tentative-gscore (h c-id)))
                  (define new-node-state
                    (node-state-a-star-set-fscore
                     (node-state-a-star-set-gscore
                      (node-state-a-star-set-previous
                       (graph-state-get-node state c-id) id) tentative-gscore) fscore))
                  (proc (graph-state-set-node state c-id new-node-state)
                        (cons c-id node-set)
                        (rest connections))]
                 [else (proc state node-set (rest connections))])]))
  
  (proc _state _node-set
        (node-connections ((searcher-get searcher) (graph-nodes graph) (node id #f #f)))))