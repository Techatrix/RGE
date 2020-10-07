#lang racket/gui

(require "../graph/graph.rkt")
(require "../graph/intern/graph-draw-O0.rkt") ; TEMP
(require "../util/util.rkt")
(require "../util/draw-util.rkt")

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

    (define/public (get-data) data)

    (define/public (set-data new-data)
      (set! data (if (eq? new-data void) (send model graph-make) new-data))
      (send this refresh))

    ; Graph View
    (define/private (view-get-translation)
      (define transform (send (send this get-dc) get-initial-matrix))
      (list (vector-ref transform 4) (vector-ref transform 5)))

    (define/private (view-get-scale)
      (define transform (send (send this get-dc) get-initial-matrix))
      (list (vector-ref transform 0) (vector-ref transform 3)))

    (define/private (view-translate dx dy)
      (send (send this get-dc) transform (vector 1 0 0 1 dx dy)))

    (define/private (view-scale dx dy)
      (send (send this get-dc) transform (vector dx 0 0 dy 0 0)))
    
    (define/private (view-set-translation dx dy)
      (define m (send (send this get-dc) get-initial-matrix))
      (define new-m (vector (vector-ref m 0) (vector-ref m 1) (vector-ref m 2) (vector-ref m 3) dx dy))
      (send (send this get-dc) set-initial-matrix new-m))

    (define/private (view-zoom dx dy)
      (define view-mouse-pos (client->view mouse-pos))
      (define mx (car view-mouse-pos))
      (define my (cadr view-mouse-pos))

      (define translation (view-get-translation))
      (define xoff (car translation))
      (define yoff (cadr translation))

      ; xoff = (xoff-mx) * dx + mx;
      ; yoff = (yoff-my) * dy + my;
      (view-scale dx dy)
      (view-set-translation (+ (* (- xoff mx) dx) mx) (+ (* (- yoff my) dy) my))
      )

    (define/private (client->view pos)
      (apply-transform (send this get-dc) pos))

    ; Mouse position
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
                                    (define node (send model graph-search-node-by-closest-position data (client->view mouse-pos)))
                                    (cond [(and (not (eq? node void)) (< (dst-PtoP (client->view mouse-pos) (send model node-get-position node)) 25))
                                           (set! last-selection-id (send model node-get-id node))])]
                                   [else (define node-pos (send model graph-get-node-position data last-selection-id))
                                         (set! data (send model graph-set-node-position data last-selection-id (add-point node-pos (div-point delta-mouse-pos (view-get-scale)))))])])
                      (cond [(send event get-middle-down)
                             (define delta (div-point delta-mouse-pos (view-get-scale)))
                             (view-translate (car delta) (cadr delta))])]

                     [(eq? type 'left-down) 
                      (cond [(eq? tool-id 'add-node) ; add Node
                             (set! data (send model graph-add-node data (client->view mouse-pos)))]
                            
                            [(eq? tool-id 'delete-node) ; delete Node
                             (define node (send model graph-search-node-by-closest-position data (client->view mouse-pos)))
                             (cond [(and (not (eq? node void)) (< (dst-PtoP (client->view mouse-pos) (send model node-get-position node)) 25))
                                    (set! data (send model graph-delete-node data (send model node-get-id node)))])]

                            [(or (eq? tool-id 'add-connection) (eq? tool-id 'delete-connection)) ; add/delete Connection
                             (define node (send model graph-search-node-by-closest-position data (client->view mouse-pos)))
                             (cond [(eq? last-selection-id void)
                                    (cond [(and (not (eq? node void)) (< (dst-PtoP (client->view mouse-pos) (send model node-get-position node)) 25))
                                           (set! last-selection-id (send model node-get-id node))])]
                                   [else (if (eq? tool-id 'add-connection)
                                             (set! data (send model graph-set-node-add-connection data last-selection-id (send model node-get-id node)))
                                             (set! data (send model graph-set-node-delete-connection data last-selection-id (send model node-get-id node))))
                                         (set! last-selection-id void)])])]
                     [(eq? type 'left-up) (cond [(eq? tool-id 'move-node) (set! last-selection-id void)])])
               (send this refresh)])))

    (define/override (on-char event)
      (define key-code (send event get-key-code))
      (cond [(or (eq? key-code 'wheel-up) (eq? key-code 'wheel-down))
             (if (eq? key-code 'wheel-up)
                 (view-zoom 1.1 1.1)
                 (view-zoom (/ 1 1.1) (/ 1 1.1)))
             (send (send this get-dc) translate 0 0)
             (send this refresh)]))
    
    (super-new
     [paint-callback
      (lambda (canvas dc)
        (send dc set-pen (make-object color% 255 255 255) 1 'solid)
        (send dc draw-line 0 0 0 10000)
        (send dc draw-line 0 0 10000 0)
        (draw-graph data dc))])

    (send (send this get-dc) set-smoothing 'smoothed)
    ))
