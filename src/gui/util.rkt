#lang racket

(require "../graph/graph.rkt")
(require "../util/util.rkt")

(provide graph-set-weights
         graph-calculate-weights
         graph-nodes-get-center
         nodes-get-center
         graph-nodes-get-extend
         nodes-get-extend
         nodes-get-selection)

(define (graph-set-weights _graph proc)
  (graph (map (lambda (node)
                (node-set-connections
                 node
                 (map (lambda (con)
                        (connection (connection-id con) (proc node con)))
                      (node-connections node))))
              (graph-nodes _graph))))

(define (graph-calculate-weights _graph)
  (graph-set-weights
   _graph
   (lambda (node con)
     (define origin (node-position node))
     (define target (graph-get-node-position _graph (connection-id con)))
     (/ (round (/ (vec2-dist origin target) 5)) 10))))

(define (graph-nodes-get-center _graph)
  (nodes-get-center (graph-nodes _graph)))

(define (nodes-get-center nodes)
  (define-values (min-x min-y max-x max-y) (nodes-get-extend nodes +inf.0 +inf.0 -inf.0 -inf.0))
  (vec2 (/ (+ min-x max-x) 2) (/ (+ min-y max-y) 2)))

(define (graph-nodes-get-extend _graph)
  (define nodes (graph-nodes _graph))
  (define-values (min-x min-y max-x max-y) (nodes-get-extend nodes +inf.0 +inf.0 -inf.0 -inf.0))
  (values min-x min-y (- max-x min-x) (- max-y min-y)))

(define (nodes-get-extend nodes min-x min-y max-x max-y)
  (cond [(empty? nodes) (values min-x min-y max-x max-y)]
        [else (define p (node-position (car nodes)))
              (nodes-get-extend
               (rest nodes)
               (min min-x (- (vec2-x p) 30))
               (min min-y (- (vec2-y p) 30))
               (max max-x (+ (vec2-x p) 30))
               (max max-y (+ (vec2-y p) 30)))]))

(define (nodes-get-selection nodes rect-pos rect-size circle-r)
  (cond [(empty? nodes) '()]
        [(rect-circle-intersect? rect-pos rect-size (node-position (car nodes)) circle-r)
         (cons (node-id (car nodes)) (nodes-get-selection (rest nodes) rect-pos rect-size circle-r))]
        [else (nodes-get-selection (rest nodes) rect-pos rect-size circle-r)]))
