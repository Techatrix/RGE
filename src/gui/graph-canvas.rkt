#lang racket/gui
(require "../graph/graph.rkt")

(provide graph-canvas%)

(define graph-canvas%
  (class canvas%
    (init-field [tool-id 'none]
                [graph-model-level 0])


    (define graph (new graph-O0%))
    (define graph-model '())
    
    (define/public (set-tool tool) ; TODO: check
      (set! tool-id tool))
    (define/public (set-model-level level) ; TODO: check
      (set! graph-model-level level)) ; TODO: model convert


    (define/override (on-event event)
      (let ([type (send event get-event-type)])
        (cond [(eq? type 'left-down) (writeln "Mouse-down")]
              [(eq? type 'left-up) (writeln "Mouse-up")]
              [(eq? type 'motion) (void)])))
    
    (define/override (on-char event)
      (writeln "Key-down"))
    
    (super-new
     [paint-callback
      (lambda (canvas dc)
        (writeln "Canvas draw"))]
     )
    ))