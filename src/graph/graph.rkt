#lang racket

(require "core/graph-base.rkt")
(require "intern/node-O0.rkt")
(require "intern/node-O2.rkt")
(require "intern/graph-O0.rkt")
(require "intern/graph-O2.rkt")

(provide (all-defined-out))

(define graph-O0%
  (class graph-base%
    (super-new)
    ; Graph make
    (define/override (graph-make) (graph-make-O0))

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
    (define/override (graph-set-node-add-connection graph id1 id2) (graph-set-node-add-connection-O0 graph id1 id2))
    (define/override (graph-set-node-delete-connection graph id1 id2) (graph-set-node-delete-connection-O0 graph id1 id2))
    
    ; Graph search
    (define/override (graph-search-node-by-id graph id) (graph-search-node-by-id-O0 graph id))
    (define/override (graph-search-node-by-position graph pos) (graph-search-node-by-position-O0 graph pos))
    (define/override (graph-search-node-by-connection graph con) (graph-search-node-by-connection-O0 graph con))
    (define/override (graph-search-node-by-connections graph list-cons) (graph-search-node-by-connections-O0 graph list-cons))

    ; Graph search comparison
    ; (define/override (graph-search-node-by-comparison-id graph choose-first?) (graph-search-node-by-comparison-id-O0 graph choose-first?))
    ; (define/override (graph-search-node-by-comparison-position graph choose-first?) (graph-search-node-by-comparison-position-O0 graph choose-first?))
    (define/override (graph-search-node-by-closest-position graph choose-first?) (graph-search-node-by-closest-position-O0 graph choose-first?))


    ; Node make
    (define/override (node-make id pos list-cons) (node-make-O0 id pos list-cons))

    ; Node get
    (define/override (node-get-id node) (node-get-id-O0 node))
    (define/override (node-get-position node) (node-get-position-O0 node))
    (define/override (node-get-connection node id) (node-get-connection-O0 node id))
    (define/override (node-get-connections node) (node-get-connections-O0 node))

    ; Node set
    (define/override (node-set-id node new-id) (node-set-id-O0 node new-id))
    (define/override (node-set-position node new-pos) (node-set-position-O0 node new-pos))
    (define/override (node-set-connections node new-list-cons) (node-set-connections-O0 node new-list-cons))

    ; Node add/delete
    (define/override (node-add-connection node c) (node-add-connection-O0 node c))
    (define/override (node-delete-connection node id) (node-delete-connection-O0 node id))

    ))

(define graph-O2%
  (class graph-base%
    (super-new)
    ; Graph make
    (define/override (graph-make) (graph-make-O2))

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
    (define/override (graph-set-node-add-connection graph id1 id2) (graph-set-node-add-connection-O2 graph id1 id2))
    (define/override (graph-set-node-delete-connection graph id1 id2) (graph-set-node-delete-connection-O2 graph id1 id2))
    
    ; Graph search
    (define/override (graph-search-node-by-id graph id) (graph-search-node-by-id-O2 graph id))
    (define/override (graph-search-node-by-position graph pos) (graph-search-node-by-position-O2 graph pos))
    (define/override (graph-search-node-by-connection graph con) (graph-search-node-by-connection-O2 graph con))
    (define/override (graph-search-node-by-connections graph list-cons) (graph-search-node-by-connections-O2 graph list-cons))

    ; Graph search comparison
    ; (define/override (graph-search-node-by-comparison-id graph choose-first?) (graph-search-node-by-comparison-id-O2 graph choose-first?))
    ; (define/override (graph-search-node-by-comparison-position graph choose-first?) (graph-search-node-by-comparison-position-O2 graph choose-first?))
    (define/override (graph-search-node-by-closest-position graph pos) (graph-search-node-by-closest-position-O2 graph pos))
    
    ; Node make
    (define/override (node-make id pos list-cons) (node-make-O2 id pos list-cons))

    ; Node get
    (define/override (node-get-id node) (node-get-id-O2 node))
    (define/override (node-get-position node) (node-get-position-O2 node))
    (define/override (node-get-connection node id) (node-get-connection-O2 node id))
    (define/override (node-get-connections node) (node-get-connections-O2 node))

    ; Node set
    (define/override (node-set-id node new-id) (node-set-id-O2 node new-id))
    (define/override (node-set-position node new-pos) (node-set-position-O2 node new-pos))
    (define/override (node-set-connections node new-list-cons) (node-set-connections-O2 node new-list-cons))

    ; Node add/delete
    (define/override (node-add-connection node c) (node-add-connection-O2 node c))
    (define/override (node-delete-connection node id) (node-delete-connection-O2 node id))
    
    ))