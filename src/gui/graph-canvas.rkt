#lang racket/gui
(require "../graph/graph.rkt")
(require "../graph/graph-draw-O0.rkt")
(require "../util.rkt")

(provide graph-canvas%)

(define graph-canvas%
  (class canvas%
    (init-field [tool-id 'none]
                [model-level 0])

    (define model (new graph-O0%))
    (define data (list '() 'var1 'var2))

    (define last-selection-id 'none)
    
    (define/public (set-tool tool) ; TODO: check
      (set! tool-id tool)
      (set! last-selection-id 'none))
    (define/public (set-model-level level) ; TODO: check
      (set! model-level level)) ; TODO: model convert

    (define/private (get-mouse-position event)
      (list (send event get-x) (send event get-y)))

    (define/override (on-event event)
      (let ([type (send event get-event-type)])
        (cond [(not (eq? type 'none))
               (cond [(eq? type 'left-down) 
                      (cond [(eq? tool-id 'add-node)
                             (set! data (send model graph-add-node data (get-mouse-position event)))
                             (send this refresh)]
                            
                            [(eq? tool-id 'delete-node)
                             (define node (send model graph-search-node-by-closest-position data (get-mouse-position event)))
                             (cond [(and (not (eq? node void)) (< (dst-PtoP (get-mouse-position event) (send model node-get-position node)) 25))
                                    (set! data (send model graph-delete-node data (send model node-get-id node)))])]

                            [(or (eq? tool-id 'add-connection) (eq? tool-id 'delete-connection))
                             (define node (send model graph-search-node-by-closest-position data (get-mouse-position event)))
                             (cond [(eq? last-selection-id 'none)
                                    (cond [(and (not (eq? node void)) (< (dst-PtoP (get-mouse-position event) (send model node-get-position node)) 25))
                                           (set! last-selection-id (send model node-get-id node))])]
                                   [else (if (eq? tool-id 'add-connection)
                                             (set! data (send model graph-set-node-add-connection data last-selection-id (send model node-get-id node)))
                                             (set! data (send model graph-set-node-delete-connection data last-selection-id (send model node-get-id node))))]
                                   )
                             (writeln last-selection-id)
                             ]
                            [(eq? tool-id 'move-node)])
                      (writeln data)
                      (send this refresh)]
                     [(eq? type 'left-up) (void)]
                     [(eq? type 'motion) (void)])
               ])))

    (define/override (on-char event)
      (writeln "Key-down"))
    
    (super-new
     [paint-callback
      (lambda (canvas dc)
        (draw-graph data dc))])
    
    (send (send this get-dc) set-smoothing 'smoothed)
    ))