#lang racket/gui

(require framework)
(require string-constants)

(require "graph-canvas.rkt")
(require "util.rkt")
(require "../graph/graph.rkt")
(require "../util/util.rkt")
(require "../util/timer.rkt")

(provide gui%)

(define gui%
  (class frame%
    (super-new)

    ; Menu Bar
    (define menu-bar
      (new menu-bar%
           [parent this]))
    
    ; File Menu
    (define menu-1
      (new menu%
           [parent menu-bar]
           [label (string-constant file-menu-label)]))
    (new menu-item%
         [parent menu-1]
         [label (string-constant new-menu-item)]
         [shortcut #\N]
         [callback
          (lambda (item event)
            (displayln "New"))])
    (new menu-item%
         [parent menu-1]
         [label (string-constant new-tab)]
         [shortcut #\T]
         [callback
          (lambda (item event)
            (panel-add-tab "Untitled")
            (send tab-panel set-selection (- (send tab-panel get-number) 1)))])
    (new menu-item%
         [parent menu-1]
         [label "Open"]
         [shortcut #\O]
         [callback
          (lambda (item event)
            (display "Open: ")
            (displayln (get-file #f #f #f #f #f null '(("JSON (*.json)" "*.json")))))])
    (new menu-item%
         [parent menu-1]
         [label (string-constant save)]
         [shortcut #\S]
         [callback
          (lambda (item event)
            (display "Save: ")
            (displayln (put-file)))])
    (new menu-item%
         [parent menu-1]
         [label "Save as"]
         [shortcut #\S]
         [shortcut-prefix (list 'shift 'ctl)]
         [callback
          (lambda (item event)
            (display "Save as: ")
            (displayln (put-file)))])
    (new menu-item%
         [parent menu-1]
         [label (string-constant close-tab)]
         [shortcut #\W]
         [callback
          (lambda (item event)
            (cond [(eq? (send tab-panel get-number) 1) (exit)]
                  [else (panel-remove-tab (send tab-panel get-selection))]))])
    (new menu-item%
         [parent menu-1]
         [label (string-constant quit)]
         [shortcut #\Q]
         [callback
          (lambda (item event)
            (exit))])
  
    ; Edit Menu
    (define menu-2
      (new menu%
           [parent menu-bar]
           [label (string-constant edit-menu-label)]))

    (new menu-item%
         [parent menu-2]
         [label (string-constant undo-menu-item)]
         [shortcut #\Z]
         [callback
          (lambda (item event)
            (displayln "Undo"))])
    (new menu-item%
         [parent menu-2]
         [label (string-constant redo-menu-item)]
         [shortcut #\Z]
         [shortcut-prefix (list 'shift 'ctl)]
         [callback
          (lambda (item event)
            (displayln "Redo"))])
    (new separator-menu-item% [parent menu-2])
    (new menu-item%
         [parent menu-2]
         [label "Cut"]
         [shortcut #\X]
         [callback
          (lambda (item event) (send graph-canvas action-cut))])
    (new menu-item%
         [parent menu-2]
         [label "Copy"]
         [shortcut #\C]
         [callback
          (lambda (item event) (send graph-canvas action-copy))])
    (new menu-item%
         [parent menu-2]
         [label "Paste"]
         [shortcut #\V]
         [callback
          (lambda (item event) (send graph-canvas action-paste))])
    (new separator-menu-item% [parent menu-2])
    (new menu-item%
         [parent menu-2]
         [label "Add Node"]
         [shortcut #\B]
         [callback
          (lambda (item event) (send graph-canvas set-tool! 'add-node))])
    (new menu-item%
         [parent menu-2]
         [label "Delete Node"]
         [shortcut #\B]
         [shortcut-prefix (list 'shift 'ctl)]
         [callback
          (lambda (item event) (send graph-canvas set-tool! 'delete-node))])
    
    (new separator-menu-item% [parent menu-2])
    (new menu-item%
         [parent menu-2]
         [label "Select All"]
         [shortcut #\A]
         [callback
          (lambda (item event)
            (define nodes (graph-nodes (send graph-canvas get-graph)))
            (send graph-canvas set-selections! (map node-id nodes)))])
    (new menu-item%
         [parent menu-2]
         [label "Clear All"]
         [shortcut #\A]
         [shortcut-prefix (list 'shift 'ctl)]
         [callback
          (lambda (item event)
            (define result (message-box "Confirm" "Are you sure?" this (list 'ok-cancel)))
            (cond [(eq? result 'ok)
                   (send graph-canvas action-reset)]))])
    
    ; View Menu
    (define menu-3
      (new menu%
           [parent menu-bar]
           [label "&View"]))
    (new menu-item%
         [parent menu-3]
         [label "Zoom in"]
         [shortcut 'add]
         [callback
          (lambda (item event)
            (define size (vec2 (send graph-canvas get-width)
                               (send graph-canvas get-height)))
            (send graph-canvas zoom (vec2-scalar size 0.5) 1.1))])
    (new menu-item%
         [parent menu-3]
         [label "Zoom out"]
         [shortcut 'subtract]
         [callback
          (lambda (item event)
            (define size (vec2 (send graph-canvas get-width)
                               (send graph-canvas get-height)))
            (send graph-canvas zoom (vec2-scalar size 0.5) (/ 1 1.1)))])
    (new separator-menu-item% [parent menu-3])
    (new menu-item%
         [parent menu-3]
         [label "View auto"]
         [callback
          (lambda (item event)
            (define _graph (send graph-canvas get-graph))
            (when (< 1 (length (graph-nodes _graph)))
              (define-values (x y w h) (graph-nodes-get-extend _graph))
              (define width (send graph-canvas get-width))
              (define height (send graph-canvas get-height))
              (define x-scale (/ w width))
              (define y-scale (/ h height))

              (define new-scale (/ 1 (max x-scale y-scale)))
              (define new-x (- (* x new-scale)))
              (define new-y (- (* y new-scale)))
              (define new-transform (vector new-scale 0 0 new-scale new-x new-y))
              (send (send graph-canvas get-dc) set-initial-matrix new-transform)
              (send graph-canvas refresh)))])
    (new menu-item%
         [parent menu-3]
         [label "View reset"]
         [callback
          (lambda (item event)
            (send (send graph-canvas get-dc) set-initial-matrix (vector 1 0 0 1 0 0))
            (send graph-canvas refresh))])
    (new separator-menu-item% [parent menu-3])

    (new checkable-menu-item%
         [parent menu-3]
         [label "Draw Axis"]
         [checked #t]
         [callback
          (lambda (item event)
            (send graph-canvas set-draw-axis! (send item is-checked?)))])
    (new checkable-menu-item%
         [parent menu-3]
         [label "Draw Grid"]
         [checked #t]
         [callback
          (lambda (item event)
            (send graph-canvas set-draw-grid! (send item is-checked?)))])
    (new separator-menu-item% [parent menu-3])
    (new checkable-menu-item%
         [parent menu-3]
         [label "Draw Node ID"]
         [checked #f]
         [callback
          (lambda (item event)
            (send graph-canvas set-draw-node-ids! (send item is-checked?)))])
    (new checkable-menu-item%
         [parent menu-3]
         [label "Draw Node Weight"]
         [checked #t]
         [callback
          (lambda (item event)
            (send graph-canvas set-draw-node-weights! (send item is-checked?)))])
    
    ; Tools Menu
    (define menu-4
      (new menu%
           (label "&Tools")
           [parent menu-bar]))

    (define menu-4-0
      (new menu%
           [label "Model"]
           [parent menu-4]))
    (define menu-4-0-0
      (new checkable-menu-item%
           [parent menu-4-0]
           [label "Racket"]
           [checked #t]
           [callback
            (lambda (item event)
              (send item check #t)
              (send menu-4-0-1 check #f)
              (send menu-4-0-2 check #f)
              (send menu-4-0-3 check #f)
              (set! graph-model-level 0)
              (writeln "Racket"))]))
    (define menu-4-0-1
      (new checkable-menu-item%
           [parent menu-4-0]
           [label "Racket Optimized"]
           [checked #f]
           [callback
            (lambda (item event)
              (send item check #t)
              (send menu-4-0-0 check #f)
              (send menu-4-0-2 check #f)
              (send menu-4-0-3 check #f)
              (set! graph-model-level 1)
              (writeln "Racket Optimized"))]))
    (define menu-4-0-2
      (new checkable-menu-item%
           [parent menu-4-0]	
           [label "Racket Typed"]
           [checked #f]
           [callback
            (lambda (item event)
              (send item check #t)
              (send menu-4-0-0 check #f)
              (send menu-4-0-1 check #f)
              (send menu-4-0-3 check #f)
              (set! graph-model-level 2)
              (writeln "Racket Typed"))]))
    (define menu-4-0-3
      (new checkable-menu-item%
           [parent menu-4-0]
           [label "FFI"]
           [checked #f]
           [callback
            (lambda (item event)
              (send item check #t)
              (send menu-4-0-0 check #f)
              (send menu-4-0-1 check #f)
              (send menu-4-0-2 check #f)
              (set! graph-model-level 3)
              (writeln "FFI"))]))
    
    (define menu-4-1
      (new menu%
           [label "Algorithm"]
           [parent menu-4]))
    (define menu-4-1-0
      (new checkable-menu-item%
           [parent menu-4-1]
           [label "BFS"]
           [checked #t]
           [callback
            (lambda (item event)
              (send item check #t)
              (send menu-4-1-1 check #f)
              (set! graph-algorithm-id 1)
              (displayln "BFS"))]))
    (define menu-4-1-1
      (new checkable-menu-item%
           [parent menu-4-1]
           [label "DFS"]
           [checked #f]
           [callback
            (lambda (item event)
              (send item check #t)
              (send menu-4-1-0 check #f)
              (set! graph-algorithm-id 2)
              (displayln "DFS"))]))
    (new separator-menu-item% [parent menu-4])

    (new menu-item%
         [parent menu-4]
         [label "Run Algorithm"]
         [shortcut 'f9]
         [shortcut-prefix '()]
         [callback
          (lambda (item event)
            (run-algorithm))])
    
    (new separator-menu-item% [parent menu-4])
    
    (new menu-item%
         [parent menu-4]
         [label "Calculate Weights"]
         [callback
          (lambda (item event)
            (define old-graph (send graph-canvas get-graph))
            (define new-graph (graph-calculate-weights old-graph))
            (send graph-canvas set-graph! new-graph))])

    (new menu-item%
         [parent menu-4]
         [label "Reset Weights"]
         [callback
          (lambda (item event)
            (define old-graph (send graph-canvas get-graph))
            (define new-graph (graph-set-weights old-graph
                                                 (lambda (node con) 1.0)))
            (send graph-canvas set-graph! new-graph))])
    (new menu-item%
         [parent menu-4]
         [label "Randomize Weights"]
         [callback
          (lambda (item event)
            (define old-graph (send graph-canvas get-graph))
            (define new-graph (graph-set-weights old-graph
                                                 (lambda (node con)
                                                   (round (/ (* 100 (random)) 10)))))
            (send graph-canvas set-graph! new-graph))])
    
    ; Tabs Menu
    (define menu-5
      (new menu%
           [parent menu-bar]
           [label (string-constant tabs-menu-label)]))
    
    (new menu-item%
         [parent menu-5]
         [label (string-constant prev-tab)]
         [shortcut #\[]
         [callback
          (lambda (item event)
            (define num (number-wrap
                         0
                         (- (send tab-panel get-number) 1)
                         (- (send tab-panel get-selection) 1)))
            (send tab-panel set-selection num)
            (panel-set-selection num))])
    (new menu-item%
         [parent menu-5]
         [label (string-constant next-tab)]
         [shortcut #\]]
         [callback
          (lambda (item event)
            (define num (number-wrap
                         0
                         (- (send tab-panel get-number) 1)
                         (+ (send tab-panel get-selection) 1)))
            (send tab-panel set-selection num)
            (panel-set-selection num))])
    (new separator-menu-item% [parent menu-5])

    ; menu-item: Tabs 1-9
    (map (lambda (n)
           (new menu-item%
                [parent menu-5]
                [label (format (string-constant tab-i/no-name) n)]
                [shortcut (integer->char (+ n 48))]
                [callback (lambda (item event) (cond [(<= n (send tab-panel get-number))
                                                      (send tab-panel set-selection (- n 1))
                                                      (panel-set-selection (- n 1))]))]))
         (build-list 9 (lambda (n) (+ n 1))))

    
    ; Help Menu
    (define menu-6
      (new menu%
           (label (string-constant help-menu-label))
           [parent menu-bar]))
    
    (new menu-item%
         [label "About RGE"]
         [parent menu-6]
         [callback
          (lambda (item event)
            (displayln "About RGE"))])


    ;TAB: (label, issaved?, data)
    (define tabs (list (list "Untitled" #f (void))))
    (define panel-selection 0)
    
    (define (tab-get-label tab) (car tab))
    (define (tab-get-label-formated tab id)
      (string-append (if (cadr tab) "" "★ ") (number->string id) ": " (car tab)))
    (define (tab-get-issaved tab) (cadr tab))
    (define (tab-get-data tab) (caddr tab))
    (define (tab-update tab data) (list (car tab) (cadr tab) data))

    (define (panel-add-tab label)
      (send tab-panel append label)
      (set! tabs (append tabs (list (list label #f (void)))))
      (panel-set-selection (+ (panel-get-selection) 1))
      (panel-update tabs 0))
    
    (define (panel-remove-tab id)
      (panel-set-selection (- id 1))
      (send tab-panel delete id)
      (set! tabs (list-delete-n tabs id))
      (panel-update tabs 0))

    (define (panel-set-tab tabs id tab i)
      (cond [(empty? tabs)]
            [(eq? id i) (append (list tab) (rest tabs))]
            [else (append (list (car tabs)) (panel-set-tab (rest tabs) id tab (+ i 1)))]))
    
    (define (panel-get-tab tabs id i)
      (cond [(empty? tabs) (void)]
            [(eq? id i) (car tabs)]
            [else (panel-get-tab (rest tabs) id (+ i 1))]))

    (define (panel-update tabs i)
      (cond [(empty? tabs)]
            [else (send tab-panel set-item-label i (tab-get-label-formated (car tabs) i))
                  (panel-update (rest tabs) (+ i 1))]))

    (define (panel-get-selection) panel-selection)

    (define (panel-set-selection id)
      (cond [(not (eq? id panel-selection)) 
             (define tab (panel-get-tab tabs id 0))
             (define new-tab (tab-update tab (send graph-canvas get-graph)))

             (set! tabs (panel-set-tab tabs panel-selection new-tab 0)) ; TODO: only do if required
             (send graph-canvas set-graph! (tab-get-data (panel-get-tab tabs id 0)))
             (set! panel-selection id)]))

    ; Tab Panel
    (define tab-panel
      (new tab-panel%
           [parent this]
           [choices (list "")]
           [callback
            (lambda (panel event)
              (panel-set-selection (send panel get-selection)))]))
    
    (panel-update tabs 0)

    (define graph-model-level 0)
    (define graph-algorithm-id 1)
    
    (define (run-algorithm)
      (define message
        (cond [(not (zero? graph-algorithm-id))
               (define solver
                 (case graph-algorithm-id
                   [(0) void]
                   [(1) graph-solver-bfs]
                   [(2) graph-solver-dfs]))
               
               (define graph (send graph-canvas get-graph))
               (define root-node-id (send graph-canvas get-root-node-id))
               (define goal-node-id (send graph-canvas get-goal-node-id))
               
               (cond [(and (integer? root-node-id) (integer? goal-node-id))
                      (define timer (timer-start))
                      (define output (solver graph
                                             graph-model-level
                                             root-node-id
                                             goal-node-id))
                      (define time (timer-stop timer))
                      (format "Output:\t ~a\nTime:\t~ams" output time)]
                     [else "Root or Goal Node are not set!"])]
              [else "No Algorithm selected!"]))
      (displayln message))

    ; Graph
    (define graph-canvas (new graph-canvas% [parent tab-panel] [style (list 'no-focus)]))
  
    (send graph-canvas set-canvas-background (make-object color% 25 25 25))

    ))
