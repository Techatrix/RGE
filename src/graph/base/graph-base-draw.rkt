#lang racket

(require "graph-base.rkt")
(require "node-base.rkt")
(require "base-structures.rkt")
(require "../../util/util.rkt")
(require "../../util/color.rkt")
(require "../../util/draw-util.rkt")

(provide draw-graph
         node-size)

(define node-size 50.0)

; draw graph
(define (draw-graph graph canvas-dc selections dark-mode? draw-ids? draw-weights?)
  (define-values (c1 c2 c3)
    (if dark-mode?
        (values color-white color-dark-gray color-white)
        (values color-gray color-dark-gray color-black)))
  (define nodes (graph-nodes graph))
  
  (send canvas-dc set-pen c3 1 'solid)
  (send canvas-dc set-text-foreground c3)
  (draw-nodes-connections graph nodes canvas-dc draw-weights?)
  
  (send canvas-dc set-brush c1 'solid)
  (draw-nodes-point nodes canvas-dc c2 selections draw-ids?))

; draw nodes point
(define (draw-nodes-point nodes canvas-dc color selections draw-ids?)
  (cond [(empty? nodes)]
        [else (draw-node-point (car nodes) canvas-dc color selections draw-ids?)
              (draw-nodes-point (rest nodes) canvas-dc color selections draw-ids?)]))

(define (draw-node-point node canvas-dc color selections draw-ids?)
  (define pos (node-position node))
  
  (if (not (list-search-eq selections (node-id node)))
      (send canvas-dc set-pen color 1 'solid)
      (send canvas-dc set-pen color-red 2 'solid))

  (draw-point canvas-dc pos node-size)
  (when draw-ids?
    (define text (number->string (node-id node)))
    (define-values (w h a b) (send canvas-dc get-text-extent text))
    (send canvas-dc set-text-foreground color-black)
    (define text-pos (vec2-sub pos (vec2-scalar (vec2 w h) 0.5)))
    (send canvas-dc draw-text text (vec2-x text-pos) (vec2-y text-pos))))

; draw nodes connections
(define (draw-nodes-connections graph nodes canvas-dc draw-weights?)
  (cond [(empty? nodes)]
        [else (define position (node-position (car nodes)))
              (define connections (node-connections (car nodes)))
              (draw-node-connections graph position connections canvas-dc draw-weights?)
              (draw-nodes-connections graph (rest nodes) canvas-dc draw-weights?)]))

(define (draw-node-connections graph origin connections canvas-dc draw-weights?)
  (cond [(empty? connections)]
        [else (draw-connection graph origin (car connections) canvas-dc draw-weights?)
              (draw-node-connections graph origin (rest connections) canvas-dc draw-weights?)]))

(define (draw-connection graph origin connection canvas-dc draw-weights?)
  (define target (node-position (graph-search-node-by-id graph (connection-id connection))))
  (draw-arrow canvas-dc origin target)
  (when draw-weights?
    (define text (number->string (connection-weight connection)))
    (define text-pos (get-weight-position origin target 15))
    (define-values (w h a b) (send canvas-dc get-text-extent text))
    (define centered-text-pos (vec2-sub text-pos (vec2-scalar (vec2 w h) 0.5)))
    (send canvas-dc draw-text text (vec2-x centered-text-pos) (vec2-y centered-text-pos))))


(define (get-weight-position pos1 pos2 m)
  (define pos3 (vec2-sub pos2 pos1))
  (define a (/ (vec2-length pos3) 2))
  (cond [(zero? a) pos1]
        [else 
         (define alpha (atan (/ m a)))
         (define beta (+ (atan (- (vec2-y pos3)) (vec2-x pos3)) (/ pi 2)))
         (define gamma (+ alpha beta))
         (define l (sqrt (+ (* a a) (* m m))))
         (vec2-add (vec2-scalar (vec2 (sin gamma) (cos gamma)) l) pos1)]))
