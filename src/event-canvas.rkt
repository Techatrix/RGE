#lang racket/gui
(provide event-canvas%)

(define event-canvas%
  (class canvas%
    (init-field [mouse-event-callback void]
                [mouse-down-event-callback void]
                [mouse-up-event-callback void]
                [mouse-motion-event-callback void]
                [key-event-callback void])
    
    (define/override (on-event event)
      (let ([type (send event get-event-type)])
        (mouse-event-callback event)
        (cond [(eq? type 'left-down) (mouse-down-event-callback event)]
              [(eq? type 'left-up) (mouse-up-event-callback event)]
              [(eq? type 'motion) (mouse-motion-event-callback event)])))
    
    (define/override (on-char event)
      (key-event-callback event))
    
    (super-new)
    ))