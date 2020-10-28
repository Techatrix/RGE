#lang racket/gui

(require "../util/util.rkt")
(require "../util/draw-util.rkt")

(provide view-canvas%)

(define view-canvas%
  (class canvas%
    (super-new)
    
    (define/public (get-translation)
      (define transform (send (send this get-dc) get-initial-matrix))
      (vec2 (vector-ref transform 4) (vector-ref transform 5)))

    (define/public (get-scale)
      (define transform (send (send this get-dc) get-initial-matrix))
      (vec2 (vector-ref transform 0) (vector-ref transform 3)))

    (define/public (set-translation dx dy)
      (define m (send (send this get-dc) get-initial-matrix))
      (define new-m
        (vector (vector-ref m 0)
                (vector-ref m 1)
                (vector-ref m 2)
                (vector-ref m 3) dx dy))
      (send (send this get-dc) set-initial-matrix new-m)
      (send this refresh))

    (define/public (set-scale x-scale y-scale)
      (define m (send (send this get-dc) get-initial-matrix))
      (define new-m
        (vector x-scale
                (vector-ref m 1)
                (vector-ref m 2)
                y-scale
                (vector-ref m 4)
                (vector-ref m 5)))
      (send (send this get-dc) set-initial-matrix new-m)
      (send this refresh))
    
    (define/public (translate dx dy)
      (send (send this get-dc) transform (vector 1 0 0 1 dx dy))
      (send this refresh))

    (define/public (scale x-scale y-scale)
      (send (send this get-dc) transform (vector x-scale 0 0 y-scale 0 0))
      (send this refresh))

    (define/public (zoom pos delta)
      (define mx (vec2-x pos))
      (define my (vec2-y pos))

      (define translation (get-translation))
      (define xoff (vec2-x translation))
      (define yoff (vec2-y translation))

      (define s (vec2-x (get-scale)))
      (define limited-delta 
        (cond [(> (* s delta) 2) (/ 2 s)]
              [(< (* s delta) 0.25) (/ 0.25 s)]
              [else delta]))

      (scale limited-delta limited-delta)

      ; xoff = (xoff-mx) * delta + mx
      ; yoff = (yoff-my) * delta + my
      (define dx (+ (* (- xoff mx) limited-delta) mx))
      (define dy (+ (* (- yoff my) limited-delta) my))
      (set-translation dx dy))))
