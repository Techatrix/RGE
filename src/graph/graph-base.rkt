#lang racket

(require "graph-O0.rkt") ; racket with recursion
; (require "graph-O1.rkt") ; racket without recursion
(require "graph-O2.rkt") ; typed racket
; (require "graph-O3.rkt") ; racket FFI C

(provide graph-base%)

(define graph-base%
  (class object%
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
    
    ; Graph search
    (abstract graph-search-node-by-id)
    (abstract graph-search-node-by-position)
    (abstract graph-search-node-by-connection)
    (abstract graph-search-node-by-connections)
    
    
    ; Node add/delete
    (abstract node-add-connection)
    (abstract node-delete-connection)

    ; Node get/set
    (abstract node-get-connection)
    (abstract node-set-connection)
    
    (super-new)))