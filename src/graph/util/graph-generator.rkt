#lang racket

(require "../base/base.rkt")
(require "../../util/util.rkt")

(provide graph-generate-linear
         graph-generate-star
         graph-generate-tree
         graph-generate-random
         graph-generate
         graph-generate-options)

(define (graph-generate-linear node-count is-circular?)
  (define distance 100)
  (define weight (/ distance 50))

  (define a 120.0)
  (define b 35.0)
  (define step 0.4)

  (define (get-position i)
    (cond [is-circular?
           (define istep (* i step))
           (define abistep (+ a (* b istep)))
           (vec2 (* abistep (cos istep))
                 (* abistep (sin istep)))]
          [else (vec2 (* i distance) 0)]))
  
  (define (proc last-node i) 
    (cond [(eq? i node-count) (list last-node)]
          [else
           ; create new-node
           (define new-node (node i (get-position i) '()))
           ; add connection (last node -> new-node) to last-node
           (define updated-last-node (node-add-connection last-node (connection i weight)))
           ; append last-node to (recrusive call with new-node as last-node)
           (cons updated-last-node (proc new-node (+ i 1)))]))

  (if (> node-count 0)
      (graph-set-nodes
       (graph-make)
       (proc (node 0 (get-position 0) '()) 1))
      (graph-make)))

(define (graph-generate-star degree depth) #f)
(define (graph-generate-tree degree depth)
  #|
  (define (proc root-node dth) 
    (cond [(zero? dth) '()]
          [else
           (define (proc2 deg)
             (cond [(zero? deg) '()]
                   [else
                    (define root-pos (node-position root-node))
                    (define nn (node (+ (* dth depth) deg)
                                     (vec2-add root-pos (vec2 (* (- deg 1) 50) 50))
                                     (list)))
                    (append (proc nn (- dth 1))
                     (proc2 (- deg 1)))]))
           (cons root-node (proc2 degree))]))

  (define nodes (proc (node 0 (vec2 0 0) (list)) depth))
  (graph-set-nodes
   (graph-make)
   nodes)
  |#
  #f
  )


(define (graph-generate-random node-count connection-probability radius)
  (define (get-position)
    (define a (* (random) 2 pi))
    (define r (* radius 50 (sqrt (random))))
    (vec2 (* r (cos a))
          (* r (sin a))))
  
  (define (proc i) 
    (cond [(zero? i) '()]
          [else (cons (node i (get-position) (list)) (proc (- i 1)))]))
  
  (graph-set-nodes
   (graph-make)
   (proc node-count)))

(define graph-generate-options
  (make-weak-hasheq
   '([linear-node-count . 50]
     [linear-circular-layout . #f]
     [star-degree . 3]
     [star-depth . 3]
     [tree-degree . 3]
     [tree-depth . 3]
     [random-node-count . 50]
     [random-connection-probability . 1]
     [random-radius . 20])))

(define (graph-generate type)
  (define hash graph-generate-options)
  (case type
    [(linear) (graph-generate-linear (hash-ref hash 'linear-node-count)
                                     (hash-ref hash 'linear-circular-layout))]
    [(star) (graph-generate-star (hash-ref hash 'star-degree)
                                 (hash-ref hash 'star-depth))]
    [(tree) (graph-generate-tree (hash-ref hash 'tree-degree)
                                 (hash-ref hash 'tree-depth))]
    [(random) (graph-generate-random (hash-ref hash 'random-node-count)
                                     (hash-ref hash 'random-connection-probability)
                                     (hash-ref hash 'random-radius))]))