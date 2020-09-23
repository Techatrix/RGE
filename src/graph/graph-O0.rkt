#lang racket

(provide (all-defined-out))

; Graph
(define (graph-add-node-O0 graph node) (error "No Implementation"))
(define (graph-delete-node-O0 graph id) (error "No Implementation"))

; Graph get
(define (graph-get-node-O0 graph id) (error "No Implementation"))
(define (graph-get-node-id-O0 graph id) (error "No Implementation"))
(define (graph-get-node-position-O0 graph id) (error "No Implementation"))
(define (graph-get-node-connections-O0 graph id) (error "No Implementation"))

; Graph set
(define (graph-set-node-O0 graph id node) (error "No Implementation"))
(define (graph-set-node-id-O0 graph id new-id) (error "No Implementation"))
(define (graph-set-node-position-O0 graph id new-pos) (error "No Implementation"))
(define (graph-set-node-connections-O0 graph id new-list-cons) (error "No Implementation"))

; Graph search
(define (graph-search-node-by-id-O0 graph id) (error "No Implementation"))
(define (graph-search-node-by-position-O0 graph pos) (error "No Implementation"))
(define (graph-search-node-by-connection-O0 graph con) (error "No Implementation"))
(define (graph-search-node-by-connections-O0 graph list-cons) (error "No Implementation"))


; Point add/delete
(define (node-add-connection-O0 node c) (error "No Implementation"))
(define (node-delete-connection-O0 node id) (error "No Implementation"))

; Node get/set
(define (node-get-connection-O0 node id) (error "No Implementation"))
(define (node-set-connection-O0 node id new-c) (error "No Implementation"))
