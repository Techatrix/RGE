#lang racket

(require "graph-O0.rkt")
(require "node-O0.rkt")
(require "../../util/util.rkt")
(require "../../util/draw-util.rkt")

(provide (rename-out [draw-graph-O0 graph-draw-O0]))

; draw graph
(define (draw-graph-O0 graph canvas-dc)
  (draw-nodes-connections-O0 graph (car graph) canvas-dc)
  (draw-nodes-point-O0 (car graph) canvas-dc))

; draw nodes point
(define (draw-nodes-point-O0 nodes canvas-dc)
  (cond [(empty? nodes)]
        [else (draw-node-point-O0 (car nodes) canvas-dc)
              (draw-nodes-point-O0 (rest nodes) canvas-dc)]))

(define (draw-node-point-O0 node canvas-dc)
  (draw-point canvas-dc (node-get-position-O0 node)))

; draw nodes connections
(define (draw-nodes-connections-O0 graph nodes canvas-dc)
  (cond [(empty? nodes)]
        [else (draw-node-connections-O0 graph (car nodes) canvas-dc)
              (draw-nodes-connections-O0 graph (rest nodes) canvas-dc)]))

(define (draw-node-connections-O0 graph node canvas-dc)
  (draw-connections-O0 graph node (node-get-connections-O0 node) canvas-dc))

(define (draw-connections-O0 graph node connections canvas-dc)
  (cond [(empty? connections)]
        [else (draw-connection-O0 graph node (car connections) canvas-dc)
              (draw-connections-O0 graph node (rest connections) canvas-dc)]))

(define (draw-connection-O0 graph node connection canvas-dc)
  (define pos1 (node-get-position-O0 node))
  (define pos2 (node-get-position-O0 (graph-search-node-by-id-O0 graph (car connection))))
  (draw-arrow canvas-dc pos1 pos2))
