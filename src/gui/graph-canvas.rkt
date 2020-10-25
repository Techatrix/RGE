#lang racket/gui

(require "../graph/base/base.rkt")
(require "../util/util.rkt")
(require "../util/draw-util.rkt")
(require "util.rkt")

(require "../graph/solver/graph-solver.rkt")

(provide graph-canvas%)

(define graph-canvas%
  (class canvas%
    (init-field [tool-id 'none]
                [graph (graph-make)]
                [root-node-id #f]
                [goal-node-id #f]
                [draw-axis? #t]
                [draw-grid? #t]
                [draw-node-ids #f]
                [draw-node-weights #t])

    (define mouse-pos (vec2 0 0))
    (define p-mouse-pos (vec2 0 0))
    
    (define last-selection-id (void))
    (define selection-box (list (vec2 0 0) (vec2 0 0)))
    (define selections '())
    (define selecting? #f)
    (define copy-node (void))

    ; getter
    (define/public (get-graph) graph)
    (define/public (get-root-node-id) root-node-id)
    (define/public (get-goal-node-id) goal-node-id)

    ; setter
    (define/public (set-tool tool)
      (set! tool-id tool)
      (set! last-selection-id (void)))

    (define/public (set-graph new-graph)
      (set! graph (if (void? new-graph) (graph-make) new-graph))
      ; (displayln graph)
      (send this refresh))

    (define/private (set-selections new-selections)
      (set! selections new-selections)
      (send this refresh))

    (define/public (set-root-node-id new-root-node-id)
      (set! root-node-id new-root-node-id)
      (send this refresh))
    (define/public (set-goal-node-id new-goal-node-id)
      (set! goal-node-id new-goal-node-id)
      (send this refresh))

    (define/public (set-draw-axis _draw-axis)
      (set! draw-axis? _draw-axis)
      (send this refresh))

    (define/public (set-draw-grid _draw-grid)
      (set! draw-grid? _draw-grid)
      (send this refresh))

    (define/public (set-draw-node-ids draw-node-ids?)
      (set! draw-node-ids draw-node-ids?)
      (send this refresh))

    (define/public (set-draw-node-weights draw-node-weights?)
      (set! draw-node-weights draw-node-weights?)
      (send this refresh))

    (define/public (reset-graph)
      (set! copy-node (void))
      (set! root-node-id (void))
      (set! goal-node-id (void))
      (set-graph (graph-make)))
    
    ; Graph View
    (define/private (view-get-translation)
      (define transform (send (send this get-dc) get-initial-matrix))
      (vec2 (vector-ref transform 4) (vector-ref transform 5)))

    (define/private (view-get-scale)
      (define transform (send (send this get-dc) get-initial-matrix))
      (vec2 (vector-ref transform 0) (vector-ref transform 3)))

    (define/private (view-set-translation dx dy)
      (define m (send (send this get-dc) get-initial-matrix))
      (define new-m
        (vector (vector-ref m 0)
                (vector-ref m 1)
                (vector-ref m 2)
                (vector-ref m 3) dx dy))
      (send (send this get-dc) set-initial-matrix new-m))

    (define/private (view-set-scale x-scale y-scale)
      (define m (send (send this get-dc) get-initial-matrix))
      (define new-m
        (vector x-scale
                (vector-ref m 1)
                (vector-ref m 2)
                y-scale
                (vector-ref m 4)
                (vector-ref m 5)))
      (send (send this get-dc) set-initial-matrix new-m))
    
    (define/private (view-translate dx dy)
      (send (send this get-dc) transform (vector 1 0 0 1 dx dy))
      (send this refresh))

    (define/private (view-scale x-scale y-scale)
      (send (send this get-dc) transform (vector x-scale 0 0 y-scale 0 0))
      (send this refresh))

    (define/public (view-zoom pos delta)
      (define mx (vec2-x pos))
      (define my (vec2-y pos))

      (define translation (view-get-translation))
      (define xoff (vec2-x translation))
      (define yoff (vec2-y translation))

      (define scale (vec2-x (view-get-scale)))
      (define limited-delta 
        (cond [(> (* scale delta) 2) (/ 2 scale)]
              [(< (* scale delta) 0.25) (/ 0.25 scale)]
              [else delta]))

      (view-scale limited-delta limited-delta)

      ; xoff = (xoff-mx) * delta + mx
      ; yoff = (yoff-my) * delta + my
      (define dx (+ (* (- xoff mx) limited-delta) mx))
      (define dy (+ (* (- yoff my) limited-delta) my))
      (view-set-translation dx dy)
      (send this refresh))

    ; Mouse position
    (define/private (get-mouse-pos event)
      (vec2 (send event get-x) (send event get-y)))
    (define/private (get-mouse-pos-view)
      (apply-transform (send this get-dc) mouse-pos))
    ; tools
    (define/private (tool-add-node data)
      (set-graph (graph-add-node graph data)))

    (define/private (tool-add-node-copy node)
      (set-graph (graph-add-node-pc graph (get-mouse-pos-view) (node-connections node))))

    (define/private (tool-delete-node node)
      (define id (node-id node))
      (cond [(eq? root-node-id id) (set-root-node-id #f)]
            [(eq? goal-node-id id) (set-goal-node-id #f)])
      (set-graph (graph-delete-node graph (node-id node))))

    (define/private (tool-add-connection id1 id2)
      (when (and (not (eq? id1 id2)) (not (graph-has-connection graph id1 id2)))
        (set-graph (graph-set-node-add-connection graph id1 id2))))

    (define/private (tool-delete-connection id1 id2)
      (when (not (eq? id1 id2))
        (set-graph (graph-set-node-delete-connection graph id1 id2))))
    ; draw
    (define/private (draw-node-highlight dc color node-id)
      (define node (graph-get-node graph node-id))
      (when (not (not node))
        (define p1 (node-position node))
        (send dc set-brush color 'solid)
        (send dc set-pen color 0 'transparent)
        (draw-point dc p1 55)))
    (define/private (draw-selection-box dc)
      (define-values (start-x end-x start-y end-y) (rect-get-points selection-box))
      
      (send dc set-brush (make-object color% 255 255 255 0.25) 'opaque)
      (send dc set-pen (make-object color% 255 255 255) 1 'solid)
      (send dc draw-rectangle start-x start-y (- end-x start-x) (- end-y start-y)))
    (define/private (draw-axis dc)
      (send dc set-pen "white" 2 'solid)
      (send dc draw-line 0 0 0 16383)
      (send dc draw-line 0 0 16383 0))

    (define/private (draw-grid dc)
      (define step-size 50)

      (define m (send (send this get-dc) get-initial-matrix))
      (define p (apply-transform dc (vec2 0 0)))

      (define x (vec2-x p))
      (define y (vec2-y p))
      (define w (/ (send this get-width) (vector-ref m 0)))
      (define h (/ (send this get-height) (vector-ref m 3)))

      (define x-start (- x (remainder (exact-floor x) step-size)))
      (define y-start (- y (remainder (exact-floor y) step-size)))
      (define num (+ (abs (exact-ceiling (/ (max w h) step-size))) 1))

      (send dc set-pen (make-object color% 51 51 51) 1 'solid)
      (for ([a (build-list num (lambda (x) (* x step-size)))])
        (define min -16383)
        (define max 16383)
        (define x1 (+ x-start a))
        (define y1 (+ y-start a))
        (send dc draw-line x1 min x1 max)
        (send dc draw-line min y1 max y1)))
    
    ; popups
    (define/private (popup-v1 popup node)
      (map
       (lambda (_label _callback _shortcut _seperator?)
         (when _seperator? (new separator-menu-item% [parent popup]))
         (new menu-item%
              [label _label]
              [parent popup]
              [callback _callback]
              [shortcut _shortcut]))
       (list
        "Set State: Root Node"
        "Set State: Goal Node"
        "Cut"
        "Copy"
        "Move"
        "Delete"
        "Delete Connections: all"
        "Delete Connections: incoming"
        "Delete Connections: outgoing")
       (list
        (lambda (item event) (set-root-node-id (node-id node)))
        (lambda (item event) (set-goal-node-id (node-id node)))
        (lambda (item event) (on-cut))
        (lambda (item event) (on-copy))
        (lambda (item event) (void))
        (lambda (item event) (on-delete))
        (lambda (item event)
          (set-graph (graph-set-nodes-delete-connection graph (node-id node)))
          (set-graph (graph-set-node-connections graph (node-id node) '())))
        (lambda (item event) (set-graph (graph-set-nodes-delete-connection graph (node-id node))))
        (lambda (item event) (set-graph (graph-set-node-connections graph (node-id node) '()))))
       (list #f #f #\X #\C #f #f #f #f #f)
       (list #f #f #t #f #f #f #t #f #f)))

    (define/private (popup-v2 popup)
      (new menu-item%
           [label "add Node"]
           [parent popup]
           [callback (lambda (item event) (on-paste))]
           [shortcut #\B])
      (new separator-menu-item% [parent popup])
      (define popup-paste
        (new menu-item%
             [label "Paste"]
             [parent popup]
             [callback (lambda (item event) 
                         (tool-add-node-copy copy-node))]))
      (send popup-paste enable (node? copy-node)))
    ; extern events
    (define/public (on-cut)
      (on-node-press-single
       (lambda (node)
         (set! copy-node node)
         (tool-delete-node node))
       void))
    (define/public (on-copy)
      (on-node-press-single
       (lambda (node)
         (set! copy-node node))
       void))
    (define/public (on-paste)
      (tool-add-node (get-mouse-pos-view)))
    (define/public (on-delete)
      (on-node-press-single
       (lambda (node)
         (tool-delete-node node))
       void))
    ; event handling
    (define/private (on-node-press-single proc else-proc)
      (define node (graph-search-node-by-closest-position graph (get-mouse-pos-view)))
      (cond [(and (not (void? node))
                  (< (vec2-dist (get-mouse-pos-view) (node-position node)) 25))
             (proc node)]
            [else (else-proc)]))

    (define/private (on-node-press-double proc)
      (on-node-press-single
       (lambda (node)
         (cond [(void? last-selection-id) (set! last-selection-id (node-id node))]
               [else (proc last-selection-id (node-id node))
                     (set! last-selection-id (void))]))
       void))

    ; event handling
    (define/override (on-event event)
      (define type (send event get-event-type))
      (set! p-mouse-pos mouse-pos)
      (set! mouse-pos (get-mouse-pos event))
      (define mouse-pos-view (apply-transform (send this get-dc) mouse-pos))
      (define delta-mouse-pos (vec2-sub mouse-pos p-mouse-pos))
      (case type
        [(motion)
         (cond [(and (eq? tool-id 'select) (send event get-left-down))
                (cond [selecting?
                       (set! selection-box (list (car selection-box) mouse-pos-view))
                       (send this refresh)]
                      [else
                       (set-graph
                        (list-for-recur graph
                                        selections
                                        (lambda (g id)
                                          (define pos (graph-get-node-position g id))
                                          (define new-pos (vec2-add pos (vec2-div delta-mouse-pos
                                                                                  (view-get-scale))))
                                          (graph-set-node-position g id new-pos))))])]
               [(send event get-middle-down)
                (define delta (vec2-div delta-mouse-pos (view-get-scale)))
                (view-translate (vec2-x delta) (vec2-y delta))])]
        [(left-down)
         (case tool-id
           [(select)
            (set-selections
             (on-node-press-single
              (lambda (node)
                (define id (node-id node))
                (cond [(send event get-control-down)
                       (cond [(not (list-search-eq selections id)) (cons id selections)]
                             [else (list-remove-eq selections id)])]
                      [else
                       (cond [(or (empty? selections) (not (list-search-eq selections id))) (list id)]
                             [else selections])]))
              (lambda ()
                (set! selecting? #t)
                (set! selection-box (list mouse-pos-view mouse-pos-view))
                (cond [(send event get-control-down) selections]
                      [else '()]))))]
           [(add-node) (tool-add-node mouse-pos-view)]
           [(delete-node) (on-node-press-single
                           (lambda (node) (tool-delete-node node)) void)]
           [(add-connection) (on-node-press-double
                              (lambda (id1 id2) (tool-add-connection id1 id2)))]
           [(delete-connection) (on-node-press-double
                                 (lambda (id1 id2) (tool-delete-connection id1 id2)))])]
        [(left-up)
         (case tool-id
           [(select)
            (when (and selecting?
                       (not (vec2-eq? (car selection-box) (cadr selection-box))))
              (define-values (start-x end-x start-y end-y) (rect-get-points selection-box))
              (define rect-pos (vec2 start-x start-y))
              (define rect-size (vec2-sub (vec2 end-x end-y) rect-pos))
      
              (set-selections (nodes-get-selection (graph-nodes graph) rect-pos rect-size 25)))
            
            (set! selecting? #f)
            (send this refresh)])]
        [(right-down)
         (define popup (new popup-menu%))
         (on-node-press-single
          (lambda (node) (popup-v1 popup node))
          (lambda () (popup-v2 popup)))
         (send this popup-menu popup (vec2-x mouse-pos) (vec2-y mouse-pos))]))

    (define/override (on-char event)
      (define key-code (send event get-key-code))
      (cond [(or (eq? key-code 'wheel-up) (eq? key-code 'wheel-down))
             (view-zoom mouse-pos (if (eq? key-code 'wheel-up) 1.1 (/ 1 1.1)))]))

    ; canvas init
    (super-new
     [paint-callback
      (lambda (canvas dc)
        (when draw-grid? (draw-grid dc))
        (when draw-axis? (draw-axis dc))

        (when (integer? root-node-id) (draw-node-highlight dc "green" root-node-id))
        (when (integer? goal-node-id) (draw-node-highlight dc "red" goal-node-id))

        (draw-graph graph dc selections draw-node-ids draw-node-weights)

        (when selecting? (draw-selection-box dc)))])

    (send (send this get-dc) set-smoothing 'smoothed)
    ))
