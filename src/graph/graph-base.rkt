#lang racket

(require "graph-O0.rkt") ; racket with recursion
; (require "graph-O1.rkt") ; racket without recursion
(require "graph-O2.rkt") ; typed racket
; (require "graph-O3.rkt") ; racket FFI C

(provide graph-base%)

(define graph-base%
  (class object%
    ; Graph make
    (abstract graph-make)

    ; Graph add/delete
    (abstract graph-add-node)
    (abstract graph-delete-node)
    
    ; Graph get
    (abstract graph-get-node)
    (abstract graph-get-node-id)
    (abstract graph-get-node-position)
    (abstract graph-get-node-connections)
    
    ; Graph set
    (abstract graph-set-node)
    (abstract graph-set-node-id)
    (abstract graph-set-node-position)
    (abstract graph-set-node-connections)
    (abstract graph-set-node-add-connection)
    (abstract graph-set-node-delete-connection)
    
    ; Graph search
    (abstract graph-search-node-by-id)
    (abstract graph-search-node-by-position)
    (abstract graph-search-node-by-connection)
    (abstract graph-search-node-by-connections)

    ; Graph search comparison
    ;(abstract graph-search-node-by-comparison-id)
    ;(abstract graph-search-node-by-comparison-position)
    (abstract graph-search-node-by-closest-position)

    ; Node make
    (abstract node-make)

    ; Node get
    (abstract node-get-id)
    (abstract node-get-position)
    (abstract node-get-connection)
    (abstract node-get-connections)

    ; Node set
    (abstract node-set-id)
    (abstract node-set-position)
    (abstract node-set-connections)
    
    ; Node add/delete
    (abstract node-add-connection)
    (abstract node-delete-connection)
    
    (super-new)))