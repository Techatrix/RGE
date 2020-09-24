#lang racket
; (require "../util.rkt")

(provide draw-graph)


(define (draw-node node canvas-dc)
  (send canvas-dc draw-ellipse (second node) (third node) 50 50))

(define (draw-nodes nodes canvas-dc)
  (cond [(empty? nodes)]
        [else (draw-node (car nodes) canvas-dc)
              (draw-nodes (rest nodes) canvas-dc)]))

(define (draw-graph graph canvas-dc)
  (draw-nodes (car graph) canvas-dc)
  (writeln "draw-graph"))
