#lang racket

(require "../base/base.rkt")
(require "../../util/structures.rkt")

(require json)

(provide graph->jsexpr
         jsexpr->graph
         read-json-graph
         write-json-graph)

(define (vec2->jsexpr vec2)
  (hasheq 'x (vec2-x vec2)
          'y (vec2-y vec2)))

(define (connection->jsexpr connection)
  (hasheq 'id (connection-id connection)
          'weight (connection-weight connection)))


(define (connections->jsexpr connections)
  (cond [(empty? connections) '()]
        [else (cons (connection->jsexpr (car connections))
                    (connections->jsexpr (rest connections)))]))

(define (node->jsexpr node)
  (hasheq 'id (node-id node)
          'position (vec2->jsexpr (node-position node))
          'connections (connections->jsexpr (node-connections node)) ))

(define (nodes->jsexpr nodes)
  (cond [(empty? nodes) '()]
        [else (cons (node->jsexpr (car nodes))
                    (nodes->jsexpr (rest nodes)))]))

(define (graph->jsexpr graph)
  (hasheq 'nodes (nodes->jsexpr (graph-nodes graph))
          'root-node-id (graph-root-node-id graph)
          'goal-node-id (graph-goal-node-id graph)))


(define (jsexpr->vec2 hash)
  (vec2 (hash-ref hash 'x)
        (hash-ref hash 'y)))

(define (jsexpr->connection hash)
  (connection (hash-ref hash 'id)
              (hash-ref hash 'weight)))


(define (jsexpr->connections lst)
  (cond [(empty? lst) '()]
        [else (cons (jsexpr->connection (car lst))
                    (jsexpr->connections (rest lst)))]))

(define (jsexpr->node hash)
  (node (hash-ref hash 'id)
        (jsexpr->vec2 (hash-ref hash 'position))
        (jsexpr->connections (hash-ref hash 'connections))))

(define (jsexpr->nodes lst)
  (cond [(empty? lst) '()]
        [else (cons (jsexpr->node (car lst))
                    (jsexpr->nodes (rest lst)))]))

(define (jsexpr->graph hash)
  (graph (jsexpr->nodes (hash-ref hash 'nodes))
         (hash-ref hash 'root-node-id)
         (hash-ref hash 'goal-node-id)))


(define (read-json-graph path)
  (define in (open-input-file path #:mode 'binary))
  (define graph (jsexpr->graph (read-json in)))
  (close-input-port in)
  graph)

(define (write-json-graph path graph)
  (define out (open-output-file path #:mode 'binary #:exists 'replace))
  (write-json (graph->jsexpr graph) out)
  (close-output-port out))