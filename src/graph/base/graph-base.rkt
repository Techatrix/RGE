#lang racket

(require "graph-base-util.rkt")
(require "node-base.rkt")
(require "base-structures.rkt")
(require "../../util/util.rkt")

(provide (all-defined-out))

; Graph make
(define (graph-make) (graph (list)))

; Graph add/delete
(define (graph-add-node _graph data)
  (define new-node (if (vec2? data) (node (graph-get-valid-id _graph) data '()) data))
  (graph (append (graph-nodes _graph) (list new-node))))

(define (graph-add-node-pc _graph position connections)
  (graph (append (graph-nodes _graph)
                 (list (node (graph-get-valid-id _graph) position connections)))))

(define (graph-delete-node _graph id)
  (graph (nodes-delete-node (graph-nodes _graph) id)))

; Graph get
(define (graph-get-node _graph id) (graph-search-node-by-id _graph id))
(define (graph-get-node-id _graph id) (node-id (graph-search-node-by-id _graph id)))
(define (graph-get-node-position _graph id) (node-position (graph-search-node-by-id _graph id)))
(define (graph-get-node-connections _graph id) (node-connections (graph-search-node-by-id _graph id)))

(define (graph-has-connection _graph id1 id2)
  (define node (graph-get-node _graph id1))
  (node-has-connection? node id2))

; Graph set
(define (graph-set-node _graph id node)
  (graph (nodes-apply-node (graph-nodes _graph) id
                           (lambda (node) node))))

(define (graph-set-node-id _graph id new-id)
  (graph (nodes-apply-node (graph-nodes _graph) id
                           (lambda (node) (node-set-id node id)))))

(define (graph-set-node-position _graph id new-pos)
  (graph (nodes-apply-node (graph-nodes _graph) id
                           (lambda (node) (node-set-position node new-pos)))))

(define (graph-set-node-connections _graph id new-list-cons)
  (graph (nodes-apply-node (graph-nodes _graph) id
                           (lambda (node) (node-set-connections node new-list-cons)))))

(define (graph-set-node-add-connection _graph id1 id2)
  (graph (nodes-apply-node (graph-nodes _graph) id1
                           (lambda (node) (node-add-connection node (connection id2 1.0))))))

(define (graph-set-node-delete-connection _graph id1 id2)
  (graph (nodes-apply-node (graph-nodes _graph) id1
                           (lambda (node) (node-delete-connection node id2)))))

(define (graph-set-nodes-add-connection _graph id)
  (graph (list-apply (graph-nodes _graph) (lambda (node) (node-add-connection node id)))))

(define (graph-set-nodes-delete-connection _graph id)
  (graph (list-apply (graph-nodes _graph) (lambda (node) (node-delete-connection node id)))))

  
; Graph search
(define (graph-search-node-by-id _graph id)
  (list-search (graph-nodes _graph)
               (lambda (node) (eq? (node-id node) id))))

(define (graph-search-node-by-position _graph pos) (error "No Implementation"))
(define (graph-search-node-by-connection _graph con) (error "No Implementation"))
(define (graph-search-node-by-connections _graph list-cons) (error "No Implementation"))

; Graph search comparison
;(define (graph-search-node-by-comparison-id graph choose-first?) (error "No Implementation"))
;(define (graph-search-node-by-comparison-position graph choose-first?) (error "No Implementation"))
(define (graph-search-node-by-closest-position _graph pos)
  (nodes-search-node-by-closest-position (graph-nodes _graph) pos))
