#lang racket

(require "graph-O0.rkt")
(require "node-O0.rkt")
(require "../../util/util.rkt")
(require "../../util/draw-util.rkt")

(provide draw-graph)

; draw graph
(define (draw-graph graph canvas-dc)
  (draw-nodes-connections graph (car graph) canvas-dc)
  (draw-nodes-point (car graph) canvas-dc))

; draw nodes point
(define (draw-nodes-point nodes canvas-dc)
  (cond [(empty? nodes)]
        [else (draw-node-point (car nodes) canvas-dc)
              (draw-nodes-point (rest nodes) canvas-dc)]))

(define (draw-node-point node canvas-dc)
  (draw-point canvas-dc (node-get-position-O0 node)))

; draw nodes connections
(define (draw-nodes-connections graph nodes canvas-dc)
  (cond [(empty? nodes)]
        [else (draw-node-connections graph (car nodes) canvas-dc)
              (draw-nodes-connections graph (rest nodes) canvas-dc)]))

(define (draw-node-connections graph node canvas-dc)
  (draw-connections graph node (node-get-connections-O0 node) canvas-dc))

(define (draw-connections graph node connections canvas-dc)
  (cond [(empty? connections)]
        [else (draw-connection graph node (car connections) canvas-dc)
              (draw-connections graph node (rest connections) canvas-dc)]))

(define (draw-connection graph node connection canvas-dc)
  (define pos1 (node-get-position-O0 node))
  (define pos2 (node-get-position-O0 (graph-search-node-by-id-O0 graph (car connection))))
  (draw-arrow canvas-dc pos1 pos2))