#lang typed/racket

(provide (all-defined-out))

(struct connection ([id : Integer]))
(struct point ([x : Real] [y : Real]))
(struct node ([id : Integer] [pos : point] [connections : (Listof connection)]))

; Node get
(: node-get-id-O2 (-> node Void))
(define (node-get-id-O2 node) (error "No Implementation"))

(: node-get-position-O2 (-> node Void))
(define (node-get-position-O2 node) (error "No Implementation"))

(: node-get-connections-O2 (-> node Void))
(define (node-get-connections-O2 node) (error "No Implementation"))

; Node set
(: node-set-id-O2 (-> node Integer node))
(define (node-set-id-O2 node new-id) (error "No Implementation"))

(: node-set-position-O2 (-> node point node))
(define (node-set-position-O2 node new-pos) (error "No Implementation"))

(: node-set-connections-O2 (-> node (Listof connection) node))
(define (node-set-connections-O2 node new-list-cons) (error "No Implementation"))

; Node add/delete
(: node-add-connection-O2 (-> node connection node))
(define (node-add-connection-O2 node c) (error "No Implementation") node)

(: node-delete-connection-O2 (-> node Integer node))
(define (node-delete-connection-O2 node id) (error "No Implementation") node)