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

    (define mouse-pos (list 0 0))
    (define p-mouse-pos (list 0 0))
    (define delta-mouse-pos (list 0 0))
    (define last-selection-id void)
    
    (define/public (set-tool tool) ; TODO: check
      (set! tool-id tool)
      (set! last-selection-id void))
    (define/public (set-model-level level) ; TODO: check
      (set! model-level level)) ; TODO: model convert

    (define/private (get-mouse-position event)
      (list (send event get-x) (send event get-y)))

    (define/private (update-delta-mouse-pos event)
      (set! p-mouse-pos mouse-pos)
      (set! mouse-pos (get-mouse-position event))
      (set! delta-mouse-pos (sub-point mouse-pos p-mouse-pos)))

    (define/override (on-event event)
      (let ([type (send event get-event-type)])
        (cond [(not (eq? type void))
               (cond [(eq? type 'motion)
                      (update-delta-mouse-pos event)
                      (cond [(and (eq? tool-id 'move-node) (send event get-left-down))
                             (define node (send model graph-search-node-by-closest-position data mouse-pos))
                             (cond [(not (eq? node void))
                                    (if (eq? last-selection-id void)
                                        (cond [(< (dst-PtoP mouse-pos (send model node-get-position node)) 25)
                                               (set! last-selection-id (send model node-get-id node))
                                               ])
                                        (set! data (send model graph-set-node-position data (send model node-get-id node) (add-point (send model node-get-position node) delta-mouse-pos)))
                                        )])
                             ])]
                     [(eq? type 'left-down) 
                      (cond [(eq? tool-id 'add-node)
                             (set! data (send model graph-add-node data mouse-pos))
                             (send this refresh)]
                            
                            [(eq? tool-id 'delete-node)
                             (define node (send model graph-search-node-by-closest-position data mouse-pos))
                             (cond [(and (not (eq? node void)) (< (dst-PtoP mouse-pos (send model node-get-position node)) 25))
                                    (set! data (send model graph-delete-node data (send model node-get-id node)))])]

                            [(or (eq? tool-id 'add-connection) (eq? tool-id 'delete-connection))
                             (define node (send model graph-search-node-by-closest-position data mouse-pos))
                             (cond [(eq? last-selection-id void)
                                    (cond [(and (not (eq? node void)) (< (dst-PtoP mouse-pos (send model node-get-position node)) 25))
                                           (set! last-selection-id (send model node-get-id node))])]
                                   [else (if (eq? tool-id 'add-connection)
                                             (set! data (send model graph-set-node-add-connection data last-selection-id (send model node-get-id node)))
                                             (set! data (send model graph-set-node-delete-connection data last-selection-id (send model node-get-id node))))])]
                            )]
                     [(eq? type 'left-up) (set! last-selection-id void)])
               (send this refresh)])))

    (define/override (on-char event)
      (writeln "Key-down"))
    
    (super-new
     [paint-callback
      (lambda (canvas dc)
        (draw-graph data dc))])
    
    (send (send this get-dc) set-smoothing 'smoothed)
    ))