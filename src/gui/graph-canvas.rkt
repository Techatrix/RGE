#lang racket/gui

(require "../graph/base/base.rkt")
(require "../util/util.rkt")
(require "../util/draw-util.rkt")

(provide graph-canvas%)

(define graph-canvas%
  (class canvas%
    (init-field [tool-id 'none])

    (define graph (graph-make))

    (define mouse-pos (point 0 0))
    (define p-mouse-pos (point 0 0))
    (define delta-mouse-pos (point 0 0))
    (define last-selection-id void)
    
    (define/public (set-tool tool)
      (set! tool-id tool)
      (set! last-selection-id void))

    (define/public (get-graph) graph)

    (define/public (set-graph new-graph)
      (set! graph (if (eq? new-graph void) (graph-make) new-graph))
      (send this refresh))

    ; Graph View
    (define/private (view-get-translation)
      (define transform (send (send this get-dc) get-initial-matrix))
      (point (vector-ref transform 4) (vector-ref transform 5)))

    (define/private (view-get-scale)
      (define transform (send (send this get-dc) get-initial-matrix))
      (point (vector-ref transform 0) (vector-ref transform 3)))

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
      (define mx (point-x view-mouse-pos))
      (define my (point-y view-mouse-pos))

      (define translation (view-get-translation))
      (define xoff (point-x translation))
      (define yoff (point-y translation))

      ; xoff = (xoff-mx) * dx + mx;
      ; yoff = (yoff-my) * dy + my;
      (view-scale dx dy)
      (view-set-translation (+ (* (- xoff mx) dx) mx) (+ (* (- yoff my) dy) my))
      )

    (define/private (client->view pos)
      (apply-transform (send this get-dc) pos))

    ; Mouse position
    (define/private (get-mouse-position event)
      (point (send event get-x) (send event get-y)))

    (define/private (update-delta-mouse-pos event)
      (set! p-mouse-pos mouse-pos)
      (set! mouse-pos (get-mouse-position event))
      (set! delta-mouse-pos (point-sub mouse-pos p-mouse-pos)))

    (define/override (on-event event)
      (let ([type (send event get-event-type)])
        (cond [(not (eq? type void))
               (cond [(eq? type 'motion)
                      (update-delta-mouse-pos event)
                      (cond [(and (eq? tool-id 'move-node) (send event get-left-down)) ; move Node
                             (cond [(eq? last-selection-id void)
                                    (define node (graph-search-node-by-closest-position graph (client->view mouse-pos)))
                                    (cond [(and (not (eq? node void)) (< (dst-PtoP (client->view mouse-pos) (node-position node)) 25))
                                           (set! last-selection-id (node-id node))])]
                                   [else (define node-pos (graph-get-node-position graph last-selection-id))
                                         (set! graph (graph-set-node-position graph last-selection-id (point-add node-pos (point-div delta-mouse-pos (view-get-scale)))))])])
                      (cond [(send event get-middle-down)
                             (define delta (point-div delta-mouse-pos (view-get-scale)))
                             (view-translate (point-x delta) (point-y delta))])]

                     [(eq? type 'left-down) 
                      (cond [(eq? tool-id 'add-node) ; add Node
                             (set! graph (graph-add-node graph (client->view mouse-pos)))]
                            
                            [(eq? tool-id 'delete-node) ; delete Node
                             (define node (graph-search-node-by-closest-position graph (client->view mouse-pos)))
                             (cond [(and (not (eq? node void)) (< (dst-PtoP (client->view mouse-pos) (node-position node)) 25))
                                    (set! graph (graph-delete-node graph (node-id node)))])]

                            [(or (eq? tool-id 'add-connection) (eq? tool-id 'delete-connection)) ; add/delete Connection
                             (define node (graph-search-node-by-closest-position graph (client->view mouse-pos)))
                             (cond [(eq? last-selection-id void)
                                    (cond [(and (not (eq? node void)) (< (dst-PtoP (client->view mouse-pos) (node-position node)) 25))
                                           (set! last-selection-id (node-id node))])]
                                   [else (if (eq? tool-id 'add-connection)
                                             (set! graph (graph-set-node-add-connection graph last-selection-id (node-id node)))
                                             (set! graph (graph-set-node-delete-connection graph last-selection-id (node-id node))))
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
        (draw-graph graph dc))])

    (send (send this get-dc) set-smoothing 'smoothed)
    ))
