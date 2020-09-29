#lang racket/gui

(require "../graph/graph.rkt")
(require "../graph/intern/graph-draw-O0.rkt") ; TEMP
(require "../util/util.rkt")

(provide graph-canvas%)

(define graph-canvas%
  (class canvas%
    (init-field [tool-id 'none]
                [model-level 0])

    (define model (new graph-O0%))
    (define data (send model graph-make))

    (define mouse-pos (list 0 0))
    (define p-mouse-pos (list 0 0))
    (define delta-mouse-pos (list 0 0))
    (define last-selection-id void)
    
    (define/public (set-tool tool)
      (set! tool-id tool)
      (set! last-selection-id void))

    (define/public (set-model-level level)
      (set! model-level level))

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
                      (cond [(and (eq? tool-id 'move-node) (send event get-left-down)) ; move Node
                             (cond [(eq? last-selection-id void)
                                    (define node (send model graph-search-node-by-closest-position data mouse-pos))
                                    (cond [(and (not (eq? node void)) (< (dst-PtoP mouse-pos (send model node-get-position node)) 25))
                                           (set! last-selection-id (send model node-get-id node))])]
                                   [else (define node-pos (send model graph-get-node-position data last-selection-id))
                                         (set! data (send model graph-set-node-position data last-selection-id (add-point node-pos delta-mouse-pos)))])])]
                     [(eq? type 'left-down) 
                      (cond [(eq? tool-id 'add-node) ; add Node
                             (set! data (send model graph-add-node data mouse-pos))
                             (send this refresh)]
                            
                            [(eq? tool-id 'delete-node) ; delete Node
                             (define node (send model graph-search-node-by-closest-position data mouse-pos))
                             (cond [(and (not (eq? node void)) (< (dst-PtoP mouse-pos (send model node-get-position node)) 25))
                                    (set! data (send model graph-delete-node data (send model node-get-id node)))])]

                            [(or (eq? tool-id 'add-connection) (eq? tool-id 'delete-connection)) ; add/delete Connection
                             (define node (send model graph-search-node-by-closest-position data mouse-pos))
                             (cond [(eq? last-selection-id void)
                                    (cond [(and (not (eq? node void)) (< (dst-PtoP mouse-pos (send model node-get-position node)) 25))
                                           (set! last-selection-id (send model node-get-id node))])]
                                   [else (if (eq? tool-id 'add-connection)
                                             (set! data (send model graph-set-node-add-connection data last-selection-id (send model node-get-id node)))
                                             (set! data (send model graph-set-node-delete-connection data last-selection-id (send model node-get-id node))))])])]
                     [(eq? type 'left-up) (cond [(eq? tool-id 'move-node) (set! last-selection-id void)])])
               (send this refresh)])))

    (define/override (on-char event) (void))
    
    (super-new
     [paint-callback
      (lambda (canvas dc)
        (draw-graph data dc))])
    
    (send (send this get-dc) set-smoothing 'smoothed)
    ))