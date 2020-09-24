#lang racket

(require "graph-base.rkt")
(require "graph-O0.rkt")
(require "graph-O2.rkt")

(provide (all-defined-out))

(define graph-O0%
  (class graph-base%
    (super-new)
    ; Graph add/delete
    (define/override (graph-add-node graph point) (graph-add-node-O0 graph point))
    (define/override (graph-delete-node graph id) (graph-delete-node-O0 graph id))
    
    ; Graph get
    (define/override (graph-get-node graph id) (graph-get-node-O0 graph id))
    (define/override (graph-get-node-id graph id) (graph-get-node-id-O0 graph id))
    (define/override (graph-get-node-position graph id) (graph-get-node-position-O0 graph id))
    (define/override (graph-get-node-connections graph id) (graph-get-node-connections-O0 graph id))
    
    ; Graph set
    (define/override (graph-set-node graph id node) (graph-set-node-O0 graph id node))
    (define/override (graph-set-node-id graph id new-id) (graph-set-node-id-O0 graph id new-id))
    (define/override (graph-set-node-position graph id new-pos) (graph-set-node-position-O0 graph id new-pos))
    (define/override (graph-set-node-connections graph id new-list-cons) (graph-set-node-connections-O0 graph id new-list-cons))
    
    ; Graph search
    (define/override (graph-search-node-by-id graph id) (graph-search-node-by-id-O0 graph id))
    (define/override (graph-search-node-by-position graph pos) (graph-search-node-by-position-O0 graph pos))
    (define/override (graph-search-node-by-connection graph con) (graph-search-node-by-connection-O0 graph con))
    (define/override (graph-search-node-by-connections graph list-cons) (graph-search-node-by-connections-O0 graph list-cons))
    
    
    ; Node add/delete
    (define/override (node-add-connection node c) (node-add-connection-O0 node c))
    (define/override (node-delete-connection node id) (node-delete-connection-O0 node id))

    ; Node get/set
    (define/override (node-get-connection node id) (node-get-connection-O0 node id))
    (define/override (node-set-connection node id new-c) (node-set-connection-O0 node id new-c))

    ))

(define graph-O2%
  (class graph-base%
    (super-new)
    ; Graph add/delete
    (define/override (graph-add-node graph point) (graph-add-node-O2 graph point))
    (define/override (graph-delete-node graph id) (graph-delete-node-O2 graph id))
    
    ; Graph get
    (define/override (graph-get-node graph id) (graph-get-node-O2 graph id))
    (define/override (graph-get-node-id graph id) (graph-get-node-id-O2 graph id))
    (define/override (graph-get-node-position graph id) (graph-get-node-position-O2 graph id))
    (define/override (graph-get-node-connections graph id) (graph-get-node-connections-O2 graph id))
    
    ; Graph set
    (define/override (graph-set-node graph id node) (graph-set-node-O2 graph id node))
    (define/override (graph-set-node-id graph id new-id) (graph-set-node-id-O2 graph id new-id))
    (define/override (graph-set-node-position graph id new-pos) (graph-set-node-position-O2 graph id new-pos))
    (define/override (graph-set-node-connections graph id new-list-cons) (graph-set-node-connections-O2 graph id new-list-cons))
    
    ; Graph search
    (define/override (graph-search-node-by-id graph id) (graph-search-node-by-id-O2 graph id))
    (define/override (graph-search-node-by-position graph pos) (graph-search-node-by-position-O2 graph pos))
    (define/override (graph-search-node-by-connection graph con) (graph-search-node-by-connection-O2 graph con))
    (define/override (graph-search-node-by-connections graph list-cons) (graph-search-node-by-connections-O2 graph list-cons))
    
    
    ; Node add/delete
    (define/override (node-add-connection node c) (node-add-connection-O2 node c))
    (define/override (node-delete-connection node id) (node-delete-connection-O2 node id))

    ; Node get/set
    (define/override (node-get-connection node id) (node-get-connection-O2 node id))
    (define/override (node-set-connection node id new-c) (node-set-connection-O2 node id new-c))
    
    ))