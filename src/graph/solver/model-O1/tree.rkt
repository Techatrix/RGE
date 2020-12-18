#lang racket

(provide (struct-out tree-node)
         tree-node-insert-value
         tree-node-remove-value
         tree-node-replace-value
         tree-node-search
         tree-node-search-min
         tree-node-map)

(struct tree-node (left right value) #:transparent)

(define (tree-node-insert-value tree value comp)
  (cond [(tree-node? tree)
         (define left (tree-node-left tree))
         (define right (tree-node-right tree))
         (define node-value (tree-node-value tree))
         
         (define new-tree-node (tree-node #f #f value))
         (if (comp value node-value)
             (if (tree-node? left) ; lower bound
                 ;  recursive add node to left
                 (tree-node (tree-node-insert-value left value comp)
                  right
                  node-value)
                 ; set node to left
                 (tree-node new-tree-node right node-value))
             
             (if (tree-node? right) ; upper bound
                 ;  recursive add node to right
                 (tree-node left
                  (tree-node-insert-value right value comp)
                  node-value)
                 ; set node to right
                 (tree-node left new-tree-node node-value)))]
        [else #f]))

(define (tree-node-remove-value tree value comp)
  (cond [(tree-node? tree)
         (define left (tree-node-left tree))
         (define right (tree-node-right tree))
         (define node-value (tree-node-value tree))
         
         (define l? (tree-node? left))
         (define r? (tree-node? right))
         
         (cond [(comp value node-value) ; element is in lower bound
                (tree-node
                 (tree-node-remove-value left value comp)
                 right
                 node-value)]
               [(comp node-value value) ; element is in upper bound
                (tree-node
                 left
                 (tree-node-remove-value right value comp)
                 node-value)]
               [else ; element is current tree
                     (cond [(and l? r?) ; two children
                            (define right-min-value (tree-node-search-min right comp))
                            (tree-node
                             left
                             (tree-node-remove-value right right-min-value)
                             right-min-value)]
                           [l? left] ; child: left
                           [r? right] ; child: right
                           [else #f])])] ; no children
        [else #f]))

(define (tree-node-replace-value tree old-value new-value comp)
  (define temp-tree (tree-node-remove-value tree old-value comp))
  (tree-node-insert-value temp-tree new-value comp))

(define (tree-node-search tree value comp)
  (define left (tree-node-left tree))
  (define right (tree-node-right tree))
  (define node-value (tree-node-value tree))
  
  (cond [(comp value node-value) (tree-node-search left value comp) ]
        [(comp node-value value) (tree-node-search right value comp)]
        [else node-value]))

(define (tree-node-search-min tree comp)
  (cond [(tree-node? tree)
         (define left (tree-node-left tree))
         (if (tree-node? left)
             (tree-node-search-min left comp)
             (tree-node-value tree))]
        [else (error "no minimal value inside empty tree")]))

(define (tree-node-map tree proc)
  (if (tree-node? tree)
      (tree-node
          (tree-node-map (tree-node-left tree) proc)
          (tree-node-map (tree-node-right tree) proc)
          (proc (tree-node-value tree)))
      #f))
