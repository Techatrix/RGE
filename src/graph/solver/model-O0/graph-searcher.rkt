#lang racket

(require "../../base/base-structures.rkt")
(require "../util/graph-searcher.rkt")
(require "../util/graph-state.rkt")

(provide searcher-graph-O0
         searcher-state-O0)

(define (get-comp proc) (lambda (v1 v2) (eq? (proc v1) (proc v2))))

(define (list-search-comp lst v [proc eq?])
  (cond [(empty? lst) #f]
        [(proc v (car lst)) (car lst)]
        [else (list-search-comp (rest lst) v proc)]))

(define (list-replace-comp lst old-value new-value [proc eq?])
  (cond [(empty? lst) '()]
        [else (cons (if (proc old-value (car lst)) new-value (car lst))
                    (list-replace-comp (rest lst) old-value new-value proc))]))

(define (list-remove-comp lst v [proc eq?])
  (cond [(empty? lst) '()]
        [(proc v (car lst)) (list-remove-comp (rest lst) v proc)]
        [else (cons (car lst) (list-remove-comp (rest lst) v proc))]))

(define (searcher-builder-O0 proc-get-value)
  (searcher
   (lambda (data value [proc proc-get-value])
     (list-search-comp data value (get-comp proc)))
   (lambda (data old-value new-value [proc proc-get-value])
     (list-replace-comp data old-value new-value (get-comp proc)))
   (lambda (data value [proc proc-get-value])
     (cons value data))
   (lambda (data value [proc proc-get-value])
     (list-remove-comp data value (get-comp proc)))
   (lambda (data proc)
     (map (lambda (node) (proc node)) data))
   (lambda (data) data)))

(define searcher-graph-O0 (searcher-builder-O0 node-id))
(define searcher-state-O0 (searcher-builder-O0 node-state-id))