#lang typed/racket

(provide (all-defined-out))

(struct connection ([id : Integer]))
(struct point ([x : Real] [y : Real]))
(struct node ([id : Integer] [pos : point] [connections : (Listof connection)]))
(struct graph ([points : (Listof node)]))

; Graph add/delete
(: graph-add-node-O2 (-> graph node graph))
(define (graph-add-node-O2 graph node) (error "No Implementation") graph)

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

; Graph search node
(: graph-search-node-by-id-O2 (-> graph Integer node))
(define (graph-search-node-by-id-O2 graph id) (error "No Implementation"))

(: graph-search-node-by-position-O2 (-> graph point node))
(define (graph-search-node-by-position-O2 graph pos) (error "No Implementation"))

(: graph-search-node-by-connection-O2 (-> graph connection node))
(define (graph-search-node-by-connection-O2 graph con) (error "No Implementation"))

(: graph-search-node-by-connections-O2 (-> graph (Listof connection) node))
(define (graph-search-node-by-connections-O2 graph list-cons) (error "No Implementation"))


; Node add/delete
(: node-add-connection-O2 (-> node connection node))
(define (node-add-connection-O2 node c) (error "No Implementation") node)

(: node-delete-connection-O2 (-> node Integer node))
(define (node-delete-connection-O2 node id) (error "No Implementation") node)

; Node get/set
(: node-get-connection-O2 (-> node Integer connection))
(define (node-get-connection-O2 node id) (error "No Implementation"))

(: node-set-connection-O2 (-> node Integer connection node))
(define (node-set-connection-O2 node id new-c) (error "No Implementation"))




