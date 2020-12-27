#lang racket

(require "../../../util/util.rkt")
(require "graph-state-disco.rkt")

(provide (all-defined-out)
         (all-from-out "graph-state-disco.rkt"))

(define (node-state-a-star-get-previous node-state)
  (car (node-state-data node-state)))
(define (node-state-a-star-get-gscore node-state)
  (cadr (node-state-data node-state)))
(define (node-state-a-star-get-fscore node-state)
  (caddr (node-state-data node-state)))
(define (graph-state-a-star-node-get-previous graph-state id)
  (node-state-a-star-get-previous (graph-state-get-node graph-state id)))
(define (graph-state-a-star-node-get-gscore graph-state id)
  (node-state-a-star-get-gscore (graph-state-get-node graph-state id)))
(define (graph-state-a-star-node-get-fscore graph-state id)
  (node-state-a-star-get-fscore (graph-state-get-node graph-state id)))

(define (node-state-a-star-set-previous _node-state previous)
  (node-state (node-state-id _node-state) (list-replace-n (node-state-data _node-state) 0 previous)))
(define (node-state-a-star-set-gscore _node-state gscore)
  (node-state (node-state-id _node-state) (list-replace-n (node-state-data _node-state) 1 gscore)))
(define (node-state-a-star-set-fscore _node-state fscore)
  (node-state (node-state-id _node-state) (list-replace-n (node-state-data _node-state) 2 fscore)))
(define (graph-state-a-star-node-set-previous graph-state id previous)
  (graph-state-set-node graph-state id
                        (node-state-a-star-set-previous
                         (graph-state-get-node graph-state id) previous)))
(define (graph-state-a-star-node-set-gscore graph-state id gscore)
  (graph-state-set-node graph-state id
                        (node-state-a-star-set-gscore
                         (graph-state-get-node graph-state id) gscore)))
(define (graph-state-a-star-node-set-fscore graph-state id fscore)
  (graph-state-set-node graph-state id
                        (node-state-a-star-set-fscore
                         (graph-state-get-node graph-state id) fscore)))
