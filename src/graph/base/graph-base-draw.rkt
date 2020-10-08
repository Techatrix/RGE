#lang racket

(require "graph-base.rkt")
(require "node-base.rkt")
(require "base-structures.rkt")
(require "../../util/util.rkt")
(require "../../util/draw-util.rkt")

(provide draw-graph)

; draw graph
(define (draw-graph graph canvas-dc)
  (draw-nodes-connections graph (graph-nodes graph) canvas-dc)
  (draw-nodes-point (graph-nodes graph) canvas-dc))

; draw nodes point
(define (draw-nodes-point nodes canvas-dc)
  (cond [(empty? nodes)]
        [else (draw-node-point (car nodes) canvas-dc)
              (draw-nodes-point (rest nodes) canvas-dc)]))

(define (draw-node-point node canvas-dc)
  (draw-point canvas-dc (node-position node)))

; draw nodes connections
(define (draw-nodes-connections graph nodes canvas-dc)
  (cond [(empty? nodes)]
        [else (draw-node-connections graph (car nodes) canvas-dc)
              (draw-nodes-connections graph (rest nodes) canvas-dc)]))

(define (draw-node-connections graph node canvas-dc)
  (draw-connections graph node (node-connections node) canvas-dc))

(define (draw-connections graph node connections canvas-dc)
  (cond [(empty? connections)]
        [else (draw-connection graph node (car connections) canvas-dc)
              (draw-connections graph node (rest connections) canvas-dc)]))

(define (draw-connection graph node connection canvas-dc)
  (define pos1 (node-position node))
  (define pos2 (node-position (graph-search-node-by-id graph (connection-id connection))))
  (draw-arrow canvas-dc pos1 pos2))
