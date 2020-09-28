#lang typed/racket

(require "node-O2.rkt")

(provide (all-defined-out))

(struct graph ([points : (Listof node)]))

; Graph add/delete
(: graph-add-node-O2 (-> graph point graph))
(define (graph-add-node-O2 graph point) (error "No Implementation") graph)

(: graph-delete-node-O2 (-> graph Integer graph))
(define (graph-delete-node-O2 graph id) (error "No Implementation") graph)

; Graph get
(: graph-get-node-O2 (-> graph Integer node))
(define (graph-get-node-O2 graph id) (error "No Implementation") (node 0 (point 0 0) (list (connection 0))))

(: graph-get-node-id-O2 (-> graph Integer Integer))
(define (graph-get-node-id-O2 graph id) (error "No Implementation") id)

(: graph-get-node-position-O2 (-> graph Integer point))
(define (graph-get-node-position-O2 graph id) (error "No Implementation") (point 0 0))

(: graph-get-node-connections-O2 (-> graph Integer (Listof connection)))
(define (graph-get-node-connections-O2 graph id) (error "No Implementation") (list (connection 0)))

; Graph set
(: graph-set-node-O2 (-> graph Integer node graph))
(define (graph-set-node-O2 graph id node) (error "No Implementation") graph)

(: graph-set-node-id-O2 (-> graph Integer Integer graph))
(define (graph-set-node-id-O2 graph id new-id) (error "No Implementation") graph)

(: graph-set-node-position-O2 (-> graph Integer point graph))
(define (graph-set-node-position-O2 graph id new-pos) (error "No Implementation") graph)

(: graph-set-node-connections-O2 (-> graph Integer (Listof connection) graph))
(define (graph-set-node-connections-O2 graph id new-list-cons) (error "No Implementation") graph)

(: graph-set-node-add-connection-O2 (-> graph Integer Integer graph))
(define (graph-set-node-add-connection-O2 graph id1 id2) (error "No Implementation") graph)

(: graph-set-node-delete-connection-O2 (-> graph Integer Integer graph))
(define (graph-set-node-delete-connection-O2 graph id1 id2) (error "No Implementation") graph)

; Graph search node
(: graph-search-node-by-id-O2 (-> graph Integer node))
(define (graph-search-node-by-id-O2 graph id) (error "No Implementation"))

(: graph-search-node-by-position-O2 (-> graph point node))
(define (graph-search-node-by-position-O2 graph pos) (error "No Implementation"))

(: graph-search-node-by-connection-O2 (-> graph connection node))
(define (graph-search-node-by-connection-O2 graph con) (error "No Implementation"))

(: graph-search-node-by-connections-O2 (-> graph (Listof connection) node))
(define (graph-search-node-by-connections-O2 graph list-cons) (error "No Implementation"))

; Graph search comparison
; (: graph-search-node-by-comparison-id-O2 (-> graph (-> Integer Integer Boolean) node))
; (define (graph-search-node-by-comparison-id-O2 graph choose-first?) (error "No Implementation"))

; (: graph-search-node-by-comparison-position-O2 (-> graph (-> point point point Boolean) node))
; (define (graph-search-node-by-comparison-position-O2 graph choose-first?) (error "No Implementation"))

(: graph-search-node-by-closest-position-O2 (-> graph point node))
(define (graph-search-node-by-closest-position-O2 graph pos) (error "No Implementation"))

