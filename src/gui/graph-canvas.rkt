#lang racket/gui

(require "graph-base-canvas.rkt")
(require "../graph/graph.rkt")
(require "../util/util.rkt")
(require "../util/draw-util.rkt")
(require "../util/color.rkt")

(provide graph-canvas%)

(define graph-canvas%
  (class graph-base-canvas%
    (init-field [action-callback void]
                [tool-id 'select]
                [draw-axis? #f]
                [draw-grid? #t]
                [draw-node-ids #f]
                [draw-node-weights #t])
    
    (inherit-field graph)
    (inherit-from-graph-base-canvas)

    (define mouse-pos (vec2 0 0))
    (define p-mouse-pos (vec2 0 0))
    
    (define active #t)
    (define selection-box (list (vec2 0 0) (vec2 0 0)))
    (define selections '())
    (define selecting? #f)
    (define copy-nodes '())

    ; setter
    (define/overment (set-graph! new-graph)
      (super set-graph! new-graph)
      (action-callback graph))
    
    (define/public (set-tool! tool)
      (set! tool-id tool)
      (set! selections '())
      (set! selecting? #f)
      (send this refresh))

    (define/public (set-selections! new-selections)
      (action-tool-select)
      (set! selections new-selections)
      (send this refresh))

    (define/public (set-root-node-id! new-root-node-id)
      (set-graph-root-node-id! graph new-root-node-id)
      (send this refresh))
    (define/public (set-goal-node-id! new-goal-node-id)
      (set-graph-goal-node-id! graph new-goal-node-id)
      (send this refresh))

    (define/public (set-draw-axis! _draw-axis)
      (set! draw-axis? _draw-axis)
      (send this refresh))

    (define/public (set-draw-grid! _draw-grid)
      (set! draw-grid? _draw-grid)
      (send this refresh))

    (define/public (set-draw-node-ids! draw-node-ids?)
      (set! draw-node-ids draw-node-ids?)
      (send this refresh))

    (define/public (set-draw-node-weights! draw-node-weights?)
      (set! draw-node-weights draw-node-weights?)
      (send this refresh))
    
    ; Mouse position
    (define/private (get-mouse-pos-view)
      (apply-transform (send this get-dc) mouse-pos))

    ; draw
    (define/private (draw-node-highlight dc color node-id)
      (define node (graph-get-node graph node-id))
      (when (not (not node)) ; big brain move!
        (define p1 (node-position node))
        (send dc set-brush color 'solid)
        (send dc set-pen color 0 'transparent)
        (draw-point dc p1 55)))
    (define/private (draw-selection-box dc)
      (define-values (start-x end-x start-y end-y) (rect-get-points selection-box))
      
      (send dc set-brush (make-object color% 255 255 255 0.25) 'opaque)
      (send dc set-pen color-white 1 'solid)
      (send dc draw-rectangle start-x start-y (- end-x start-x) (- end-y start-y)))
    (define/private (draw-axis dc)
      (send dc set-pen color-white 2 'solid)
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
    
    ; popup
    (define/private (open-popup [popup-menu (new popup-menu%)] [node (get-node-at-mouse)])
      (cond [(node? node)
             (map
              (lambda (_label _callback _shortcut _seperator?)
                (when _seperator? (new separator-menu-item% [parent popup-menu]))
                (new menu-item%
                     [label _label]
                     [parent popup-menu]
                     [callback _callback]
                     [shortcut _shortcut]))
              (list
               "Set State: Root Node"
               "Set State: Goal Node"
               "Cut"
               "Copy"
               "Delete")
              (list
               (lambda (a b) (set-root-node-id! (node-id node)))
               (lambda (a b) (set-goal-node-id! (node-id node)))
               (lambda (a b) (action-cut))
               (lambda (a b) (action-copy))
               (lambda (a b) (action-delete)))
              (list #f #f #\X #\C #f)
              (list #f #f #t #f #f))
             
             (cond [(not (list-search-eq selections (node-id node)))
                    (new menu-item%
                         [label "Add    Connections"]
                         [parent popup-menu]
                         [callback (lambda (a b) (action-node-add-connections '<- node))])
                    (new menu-item%
                         [label "Delete Connections"]
                         [parent popup-menu]
                         [callback (lambda (a b) (action-node-delete-connections '<- node))])]
                   [else
                    (new menu-item%
                         [label "Delete Connections: incoming"]
                         [parent popup-menu]
                         [callback (lambda (a b) (action-nodes-delete-all-connections '<- node))])
                    (new menu-item%
                         [label "Delete Connections: outgoing"]
                         [parent popup-menu]
                         [callback (lambda (a b) (action-nodes-delete-all-connections '-> node))])
                    (new menu-item%
                         [label "Delete Connections: both"]
                         [parent popup-menu]
                         [callback (lambda (a b) (action-nodes-delete-all-connections '<-> node))])])]
            [else
             (new menu-item%
                  [label "Add Node"]
                  [parent popup-menu]
                  [callback (lambda (item event) (action-add-node))]
                  [shortcut #\B])
             (new separator-menu-item% [parent popup-menu])
             (define popup-paste
               (new menu-item%
                    [label "Paste"]
                    [parent popup-menu]
                    [callback (lambda (item event) (action-paste))]))
             (send popup-paste enable (not (empty? copy-nodes)))])
      popup-menu)
    ; helper
    (define/private (get-selection-nodes [node (get-node-at-mouse)])
      (cond [(empty? selections)
             (if (not node)
                 copy-nodes
                 (list node))]
            [else (foldl (lambda (id nodes) (cons (graph-get-node graph id) nodes)) '() selections)]))
    (define/private (get-selection-node-ids [node (get-node-at-mouse)])
      (cond [(empty? selections)
             (if (not node)
                 '()
                 (list (node-id node)))]
            [else selections]))
    (define/private (get-node-at-mouse [position (get-mouse-pos-view)])
      (define node
        (graph-search-node-by-comparison
         graph
         (lambda (node1 node2)
           (define dist1 (vec2-dist position (node-position node1)))
           (define dist2 (vec2-dist position (node-position node2)))
           (if (< dist1 dist2) node1 node2))))
      (if (and (not (not node))
               (< (vec2-dist position (node-position node)) 25))
          node
          #f))
    
    ; actions
    (define/public (action-tool-select)
      (unless (eq? tool-id 'select)
        (set! tool-id 'select)))

    (define/public (action-cut)
      (action-copy)
      (base-delete-nodes (get-selection-node-ids)))

    (define/public (action-copy)
      (action-tool-select)
      (set! copy-nodes (get-selection-nodes)))

    (define/public (action-paste)
      (action-tool-select)
      (base-copy-nodes (get-mouse-pos-view) copy-nodes))

    (define/public (action-delete)
      (action-tool-select)
      (base-delete-nodes (get-selection-node-ids)))

    (define/public (action-add-node) (base-add-node (get-mouse-pos-view)))
    (define/public (action-delete-node)
      (define node (get-node-at-mouse))
      (when (not (not node))
        (base-delete-node (node-id node))))
    (define/public (action-node-add-connections [direction '->] [node (get-node-at-mouse)])
      (when (not (not node))
        (base-add-connections-1-M (node-id node) selections direction)))
    (define/public (action-node-delete-connections [direction '->] [node (get-node-at-mouse)])
      (when (not (not node))
        (base-delete-connections-1-M (node-id node) selections direction)))
    (define/public (action-nodes-delete-all-connections [direction '->] [node (get-node-at-mouse)])
      (define _selections (get-selection-node-ids node))
      ; TODO: m<->A
      (when (not (empty? _selections))
        (set-graph!
         (foldr (lambda (id _graph)
                  (case direction
                    [(->) (graph-set-node-connections _graph id '())]
                    [(<-) (base-connections-1-A graph-set-node-delete-connection _graph id '<-)]
                    [(<->)
                     (define __graph (graph-set-node-connections _graph id '()))
                     (base-connections-1-A graph-set-node-delete-connection __graph id '<-)])
                  ) graph _selections))))

    (define/public (action-reset)
      (set! copy-nodes '())
      (set! selections '())
      (set! selecting? #f)
      (set! selection-box (list (vec2 0 0) (vec2 0 0)))
      (set-graph! (graph-make)))

    ; event handling
    (define/override (on-event event)
      (define type (send event get-event-type))

      (case type
        [(enter) (set! active #t) (send this refresh)]
        [(leave) (set! active #f) (send this refresh)])

      (when active
        (set! p-mouse-pos mouse-pos)
        (set! mouse-pos (vec2 (send event get-x) (send event get-y)))
        (define mouse-pos-view (apply-transform (send this get-dc) mouse-pos))
        (define delta-mouse-pos (vec2-sub mouse-pos p-mouse-pos))
        (case type
          [(motion)
           (case tool-id
             [(select)
              (when (send event get-left-down)
                (cond [selecting?
                       (set! selection-box (list (car selection-box) mouse-pos-view))
                       (send this refresh)]
                      [else (base-move-nodes selections delta-mouse-pos)]))]
             [(add-node) (send this refresh)])
           (when (send event get-middle-down)
             (define delta (vec2-div delta-mouse-pos (send this get-scale)))
             (send this translate (vec2-x delta) (vec2-y delta)))]
          [(left-down)
           (case tool-id
             [(select)
              (define node (get-node-at-mouse))
              (set-selections!
               (cond [(node? node)
                      (define id (node-id node))
                      (cond [(send event get-control-down)
                             (cond [(not (list-search-eq selections id)) (cons id selections)]
                                   [else (list-remove-eq selections id)])]
                            [else
                             (cond [(or (empty? selections) (not (list-search-eq selections id)))
                                    (list id)]
                                   [else selections])])]
                     [else
                      (set! selecting? #t)
                      (set! selection-box (list mouse-pos-view mouse-pos-view))
                      (cond [(send event get-control-down) selections]
                            [else '()])]))])]
          [(left-up)
           (case tool-id
             [(select)
              (when (and selecting?
                         (not (vec2-eq? (car selection-box) (cadr selection-box))))
                (define-values (start-x end-x start-y end-y) (rect-get-points selection-box))
                (define rect-pos (vec2 start-x start-y))
                (define rect-size (vec2-sub (vec2 end-x end-y) rect-pos))
                
                (define new-selections
                  (nodes-get-selection (graph-nodes graph) rect-pos rect-size 25))

                (set-selections!
                 (if (send event get-control-down)
                     (if (send event get-shift-down)
                         (list-for-recur
                          selections
                          new-selections
                          (lambda (_selections id) (list-remove-eq _selections id)))
                         (list-append-new selections new-selections))
                     new-selections)))
          
              (set! selecting? #f)
              (send this refresh)]
             [(add-node) (action-add-node)]
             [(delete-node) (action-delete-node)])]
          [(right-down)
           (case tool-id
             [(select)
              (define popup (open-popup))
              (send this popup-menu popup (vec2-x mouse-pos) (vec2-y mouse-pos))]
             [else (set-tool! 'select)])])))

    (define/override (on-char event)
      (define key-code (send event get-key-code))
      (cond [(or (eq? key-code 'wheel-up) (eq? key-code 'wheel-down))
             (send this zoom mouse-pos (if (eq? key-code 'wheel-up) 1.1 (/ 1 1.1)))]))
    
    ; canvas init
    (super-new
     [paint-callback
      (lambda (canvas dc)
        (define mouse-pos-view (apply-transform dc mouse-pos))
        
        (when draw-grid? (draw-grid dc))
        (when draw-axis? (draw-axis dc))

        (define root-node-id (graph-root-node-id graph))
        (define goal-node-id (graph-goal-node-id graph))
        
        (when (integer? root-node-id)
          (if (not (graph-get-node graph root-node-id))
              (set-root-node-id! #f)
              (draw-node-highlight dc color-green root-node-id)))
        (when (integer? goal-node-id)
          (if (not (graph-get-node graph goal-node-id))
              (set-goal-node-id! #f)
              (draw-node-highlight dc color-blue goal-node-id)))

        (draw-graph graph dc selections draw-node-ids draw-node-weights)

        (when (and (eq? tool-id 'add-node) active)
          (draw-point dc mouse-pos-view 50))

        (when selecting? (draw-selection-box dc))
        )])
    
    (send (send this get-dc) set-smoothing 'smoothed)
    ))
