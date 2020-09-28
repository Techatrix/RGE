#lang racket

(require "graph-util-O0.rkt")
(require "node-O0.rkt")

(provide (all-defined-out))

; Graph
(define (graph-add-node-O0 graph point)
  (graph-set-nodes-O0 graph (nodes-add-node-O0 (car graph) (list (graph-get-valid-id-O0 graph) point '()))))

(define (graph-delete-node-O0 graph id)
  (graph-set-nodes-O0 graph (nodes-delete-node-O0 (car graph) id)))

; Graph get
(define (graph-get-node-O0 graph id) (error "No Implementation"))
(define (graph-get-node-id-O0 graph id) (error "No Implementation"))
(define (graph-get-node-position-O0 graph id) (error "No Implementation"))
(define (graph-get-node-connections-O0 graph id) (error "No Implementation"))

; Graph set
(define (graph-set-node-O0 graph id node) (graph-set-nodes-O0 graph (nodes-apply-node-O0 (car graph) id (lambda (node) node))))
(define (graph-set-node-id-O0 graph id new-id) (graph-set-nodes-O0 graph (nodes-apply-node-O0 (car graph) id (lambda (node) (node-set-id-O0 node id)))))
(define (graph-set-node-position-O0 graph id new-pos) (graph-set-nodes-O0 graph (nodes-apply-node-O0 (car graph) id (lambda (node) (node-set-position-O0 node new-pos)))))
(define (graph-set-node-connections-O0 graph id new-list-cons) (graph-set-nodes-O0 graph (nodes-apply-node-O0 (car graph) id (lambda (node) (node-set-connections-O0 node new-list-cons)))))
(define (graph-set-node-add-connection-O0 graph id1 id2) (graph-set-nodes-O0 graph (nodes-apply-node-O0 (car graph) id1 (lambda (node) (node-add-connection-O0 node (list id2))))))
(define (graph-set-node-delete-connection-O0 graph id1 id2) (graph-set-nodes-O0 graph (nodes-apply-node-O0 (car graph) id1 (lambda (node) (node-delete-connection-O0 node id2)))))

; Graph search
(define (graph-search-node-by-id-O0 graph id) (nodes-search-node (car graph) (lambda (node) (eq? (node-get-id-O0 node) id))))
(define (graph-search-node-by-position-O0 graph pos) (error "No Implementation"))
(define (graph-search-node-by-connection-O0 graph con) (error "No Implementation"))
(define (graph-search-node-by-connections-O0 graph list-cons) (error "No Implementation"))

; Graph search comparison
;(define (graph-search-node-by-comparison-id-O0 graph choose-first?) (error "No Implementation"))
;(define (graph-search-node-by-comparison-position-O0 graph choose-first?) (error "No Implementation"))
(define (graph-search-node-by-closest-position-O0 graph pos) (nodes-search-node-by-closest-position-O0 (car graph) pos))
