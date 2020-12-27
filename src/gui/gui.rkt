#lang racket/gui

(require "graph-canvas.rkt")
(require "data-tab-panel.rkt")
(require "graph-generator-window.rkt")
(require "about-window.rkt")
(require "../graph/graph.rkt")
(require "../util/util.rkt")
(require "../util/timer.rkt")
(require "../util/preference-manager.rkt")

(provide gui%
         new-gui)

(define (new-gui)
  (define gui
    (new gui%
         [label "Graph Note Explorer"]
         [width 600]
         [height 600]
         [min-width 300]
         [min-height 300]))
  (send gui center)
  (send gui show #t))

(define gui%
  (class frame%
    (super-new)

    (inherit on-exit)
    
    (define/public (close)
      (when (can-close?) (on-exit)))
    
    (define/augment (can-close?)
      (define (proc i)
        (and
         (graph-tab-request-save-if-required (send panel get-tab i))
         (if (< 0 i)
             (proc (- i 1))
             #t)))
      
      (define tab-count (send panel get-number))
      (if (< 0 tab-count)
            (proc (- tab-count 1))
            #t))
    
    (define/public (get-canvas) graph-canvas)
    
    (define (build-menu-items
             parent labels has-seperators checkable
             shortcuts shortcut-prefixes callbacks)
      (define dsp (get-default-shortcut-prefix))
      (map
       (lambda (l hs ck? shc shc-pre cb)
         (when hs
           (new separator-menu-item% [parent parent]))
         (if (not ck?)
             (new menu-item%
                  [parent parent]
                  [label l]
                  [shortcut shc]
                  [shortcut-prefix (if (not shc-pre) dsp shc-pre)]
                  [callback cb])
             (new checkable-menu-item%
                  [parent parent]
                  [label l]
                  [shortcut shc]
                  [shortcut-prefix (if (not shc-pre) dsp shc-pre)]
                  [callback cb]
                  [checked (car ck?)])))
       labels
       has-seperators
       checkable
       shortcuts
       shortcut-prefixes
       callbacks))
    
    ; Menu Bar
    (define menu-bar
      (new menu-bar%
           [parent this]))
    
    ; File Menu
    (define menu-1
      (new menu%
           [parent menu-bar]
           [label "&File"]))
    
    (build-menu-items
     menu-1
     (list "New" "New Tab" "Open" "Save" "Save as" "Close Tab" "Quit")
     (list #f #f #f #f #f #f #f)
     (list #f #f #f #f #f #f #f)
     (list #\N #\T #\O #\S #\S #\W #\Q)
     (list #f #f #f #f (list 'shift 'ctl) #f #f)
     (list
      (lambda (a b) (new-gui))
      (lambda (a b)
        (send panel add-tab "untitled")
        (panel-set-selection (send panel get-selection)))
      (lambda (a b) (load-graph-tab))
      (lambda (a b) (save-graph-tab #f))
      (lambda (a b) (save-graph-tab #t))
      (lambda (a b) (close-graph-tab))
      (lambda (a b) (close))))
  
    ; Edit Menu
    (define menu-2
      (new menu%
           [parent menu-bar]
           [label "&Edit"]))

    
    (build-menu-items
     menu-2
     (list "Undo" "Redo" "Cut" "Copy" "Paste" "Add Node" "Delete Node" "Select All" "Clear All")
     (list #f #f #t #f #f #t #f #t #f)
     (list #f #f #f #f #f #f #f #f #f)
     (list #\Z #\Z #\X #\C #\V #\B #\B #\A #\A)
     (list #f (list 'shift 'ctl) #f #f #f #f (list 'shift 'ctl) #f (list 'shift 'ctl))
     (list
      (lambda (a b) (displayln "Undo"))
      (lambda (a b) (displayln "Redo"))
      (lambda (a b) (send graph-canvas action-cut))
      (lambda (a b) (send graph-canvas action-copy))
      (lambda (a b) (send graph-canvas action-paste))
      (lambda (a b) (send graph-canvas set-tool! 'add-node))
      (lambda (a b) (send graph-canvas set-tool! 'delete-node))
      (lambda (a b)
        (define nodes (graph-nodes (send graph-canvas get-graph)))
        (send graph-canvas set-selections! (map node-id nodes)))
      (lambda (a b)
        (cond [(eq? (message-box "Confirm" "Are you sure?" this (list 'yes-no 'no-icon)) 'yes)
               (send graph-canvas action-reset)]))))
    
    ; View Menu
    (define menu-3
      (new menu%
           [parent menu-bar]
           [label "&View"]))
    
    (build-menu-items
     menu-3
     (list
      "Zoom in" "Zoom out" "View auto" "View reset" "Dark Mode"
      "Draw Axis" "Draw Grid" "Draw Node ID" "Draw Node Weight")
     (list #f #f #t #f #t #t #f #t #f)
     (list #f #f #f #f
      (list (get-pref 'dark-mode #t))
      (list (get-pref 'draw-axis #f))
      (list (get-pref 'draw-grid #t))
      (list (get-pref 'draw-node-id #f))
      (list (get-pref 'draw-node-weight #t))) 
     (list 'add 'subtract #f #f #f #f #f #f #f)
     (list #f #f #f #f #f #f #f #f #f)
     (list
      (lambda (a b)
        (define size (vec2 (send graph-canvas get-width)
                           (send graph-canvas get-height)))
        (send graph-canvas zoom (vec2-scalar size 0.5) 1.1))
      (lambda (a b)
        (define size (vec2 (send graph-canvas get-width)
                           (send graph-canvas get-height)))
        (send graph-canvas zoom (vec2-scalar size 0.5) (/ 1 1.1)))
      (lambda (a b)
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
          (send graph-canvas refresh)))
      (lambda (a b)
        (send (send graph-canvas get-dc) set-initial-matrix (vector 1 0 0 1 0 0))
        (send graph-canvas refresh))
      (lambda (item _)
        (define checked? (send item is-checked?))
        (put-pref 'dark-mode checked?)
        (send graph-canvas set-dark-mode?! checked?))
      (lambda (item _)
        (define checked? (send item is-checked?))
        (put-pref 'draw-axis checked?)
        (send graph-canvas set-draw-axis?! checked?))
      (lambda (item _)
        (define checked? (send item is-checked?))
        (put-pref 'draw-grid checked?)
        (send graph-canvas set-draw-grid?! checked?))
      (lambda (item _)
        (define checked? (send item is-checked?))
        (put-pref 'draw-node-id checked?)
        (send graph-canvas set-draw-node-ids?! checked?))
      (lambda (item _)
        (define checked? (send item is-checked?))
        (put-pref 'draw-node-weight checked?)
        (send graph-canvas set-draw-node-weights?! checked?))))
    
    ; Tools Menu
    (define menu-4
      (new menu%
           (label "&Tools")
           [parent menu-bar]))

    (define menu-4-0
      (new menu%
           [label "Model"]
           [parent menu-4]))

    (define (model-menu-item-callback index)
      (put-pref 'model-id index)
      (define (proc items i)
        (cond [(empty? items)]
              [else
               (send (car items) check (eq? i index))
               (proc (rest items) (+ i 1))]))
      (proc model-menu-items 0))
    
    (define model-menu-items
      (build-menu-items
       menu-4-0
       (list "Racket" "Racket Optimized" #|"Racket Typed"|# "FFI")
       (list #f #f #f)
       (list
        (list (eq? (get-pref 'model-id 0) 0))
        (list (eq? (get-pref 'model-id 0) 1))
        ; (list (eq? (get-pref 'model-id 0) 2))
        (list (eq? (get-pref 'model-id 0) 3))) 
       (list #f #f #f)
       (list #f #f #f)
       (list
        (lambda (a b) (model-menu-item-callback 0))
        (lambda (a b) (model-menu-item-callback 1))
        ; (lambda (a b) (model-menu-item-callback 2))
        (lambda (item b)
          (cond [ffi:is-available
                 (model-menu-item-callback 3)
                 (put-pref 'model-id 3)
                 (send item check #t)]
                [else
                 (define result
                   (message-box/custom "Warning"
                                       (format "Foreign Library File not found or invalid!")
                                       "Select File"
                                       "Cancel"
                                       #f))
                 (when (eq? result 1)
                       (define suffix (system-type 'so-suffix))

                       (define filters
                         (list
                          (list (format "FFI File (*~a)" suffix) (format "*~a" suffix))
                          (list "Any" "*.*")))
                       
                       (define path
                         (get-file "Select Foreign Library File" this #f #f #f null filters))
                       
                       (when (path? path)
                             (displayln path)
                             (put-preferences (list 'ffi-lib-path)
                                              (list (path->string path))
                                              #f
                                              (build-path (find-system-path 'pref-dir) "rge-prefs.rktd"))
                             (define answer
                               (message-box "Requesting Restart"
                                            "To use FFi, a restart is required\n Quit now?"
                                            this
                                            (list 'yes-no)))
                             (when (eq? answer 'yes)
                                   (exit))))])))))
    
    (define menu-4-1
      (new menu%
           [label "Algorithm"]
           [parent menu-4]))

    (define (agol-menu-item-callback index)
      (put-pref 'agol-id index)
      (define (proc items i)
        (cond [(empty? items)]
              [else
               (send (car items) check (eq? i index))
               (proc (rest items) (+ i 1))]))
      (proc agol-menu-items 0))
    
    (define agol-menu-items
      (build-menu-items
       menu-4-1
       (list "BFS" "DFS" "DFS Shortest Path" "Dijkstra" "A-Star")
       (list #f #f #f #f #f)
       (list
        (list (eq? (get-pref 'agol-id 0) 0))
        (list (eq? (get-pref 'agol-id 0) 1))
        (list (eq? (get-pref 'agol-id 0) 2))
        (list (eq? (get-pref 'agol-id 0) 3))
        (list (eq? (get-pref 'agol-id 0) 4))) 
       (list #f #f #f #f #f)
       (list #f #f #f #f #f)
       (list
        (lambda (a b) (agol-menu-item-callback 0))
        (lambda (a b) (agol-menu-item-callback 1))
        (lambda (a b) (agol-menu-item-callback 2))
        (lambda (a b) (agol-menu-item-callback 3))
        (lambda (a b) (agol-menu-item-callback 4)))))
    (define menu-4-2
      (new menu%
           [label "Generate Graph"]
           [parent menu-4]))
    (build-menu-items
     menu-4-2
     (list "Linear Graph" "Star Graph" "Tree Graph" "Random Graph" "Open Window")
     (list #f #f #f #f #t)
     (list #f #f #f #f #f) 
     (list #f #f #f #f #f)
     (list #f #f #f #f #f)
     (list
      (lambda (a b) (send graph-canvas set-graph! (graph-generate 'linear)))
      (lambda (a b) (send graph-canvas set-graph! (graph-generate 'star)))
      (lambda (a b) (send graph-canvas set-graph! (graph-generate 'tree)))
      (lambda (a b) (send graph-canvas set-graph! (graph-generate 'random)))
      (lambda (a b) (open-graph-generator-window this))))

    (new separator-menu-item% [parent menu-4])

    (build-menu-items
     menu-4
     (list "Run Algorithm" "Calculate Weights" "Reset Weights" "Randomize Weights")
     (list #f #t #f #f)
     (list #f #f #f #f)
     (list 'f9 #f #f #f)
     (list '() #f #f #f)
     (list
      (lambda (a b) (run-algorithm))
      (lambda (a b)
        (define old-graph (send graph-canvas get-graph))
        (define new-graph (graph-calculate-weights old-graph))
        (send graph-canvas set-graph! new-graph))
      (lambda (a b)
        (define old-graph (send graph-canvas get-graph))
        (define new-graph (graph-set-weights old-graph
                                             (lambda (node con) 1.0)))
        (send graph-canvas set-graph! new-graph))
      (lambda (a b)
        (define old-graph (send graph-canvas get-graph))
        (define new-graph (graph-set-weights old-graph
                                             (lambda (node con)
                                               (round (/ (* 100 (random)) 10)))))
        (send graph-canvas set-graph! new-graph))))
    
    ; Tabs Menu
    (define menu-5
      (new menu%
           [parent menu-bar]
           [label "&Tabs"]))
    
    (build-menu-items
     menu-5
     (list "Previous Tab" "Next Tab")
     (list #f #f)
     (list #f #f)
     (list #\[ #\])
     (list #f #f)
     (list
      (lambda (item event)
        (define num (number-wrap
                     0
                     (- (send panel get-number) 1)
                     (- (send panel get-selection) 1)))
        (send panel set-selection num)
        (panel-set-selection num))
      (lambda (item event)
        (define num (number-wrap
                     0
                     (- (send panel get-number) 1)
                     (+ (send panel get-selection) 1)))
        (send panel set-selection num)
        (panel-set-selection num))))
    (new separator-menu-item% [parent menu-5])

    ; menu-item: Tabs 1-9
    (map (lambda (n)
           (new menu-item%
                [parent menu-5]
                [label (format "Tab ~a" (+ n 1))]
                [shortcut (integer->char (+ n 49))]
                [callback (lambda (item event)
                            (cond [(<= (+ n 1) (send panel get-number))
                                   (send panel set-selection n)
                                   (panel-set-selection n)]))]))
         (build-list 9 values))

    
    ; Help Menu
    (define menu-6
      (new menu%
           (label "&Help")
           [parent menu-bar]))
    
    (new menu-item%
         [label "About RGE"]
         [parent menu-6]
         [callback
          (lambda (item event)
            (open-about-window this))])

    (define (path-get-filename path)
      (car (string-split (path->string (file-name-from-path path)) ".")))
    
    (define (graph-tab-request-save tab)
      (define close-result
        (message-box/custom "Warning"
                            (format "The File \"~a\" is not saved." (tab-label tab))
                            "Save" 
                            "Cancel"
                            "Don't Save"))
      (case close-result
        [(eq? close-result 1) (save-graph-tab)]
        [(eq? close-result 3) #t]
        [else #f]))
    
    (define (graph-tab-request-save-if-required tab)
      (if (tab-issaved? tab)
          #t
          (graph-tab-request-save tab)))
    
    ; save/load/close graph-tab
    (define (save-graph-tab [always-ask-path #f])
      (define current-tab (send panel get-current-tab))

      (define (ask-graph-save-path label)
        (define path
          (put-file label this #f "graph" "json" null '(("JSON (*.json)" "*.json") ("Any" "*.*"))))
        (if (path? path) (path-replace-extension path #".json") #f))
    
      (define path
        (cond [always-ask-path (ask-graph-save-path "Save File As")]
              [else (if (path? (tab-path current-tab))
                        (tab-path current-tab)
                        (ask-graph-save-path "Save File"))]))
      (cond [(path? path)
             (write-json-graph path (send graph-canvas get-graph))
      
             (define new-tab (tab (path-get-filename path) path #t (tab-data current-tab)))
             (send panel set-tab! (send panel get-selection) new-tab)]
            [else #f]))

    (define (load-graph-tab)
      (define path
        (get-file "Open File" this #f #f ".json" null '(("JSON (*.json)" "*.json") ("Any" "*.*"))))

      (when (path? path)
            (define (get-same-path i)
              (if (equal? path (tab-path (send panel get-tab i)))
                  i
                  (if (zero? i) #f (get-same-path (- i 1)))))
        
            (define tab-count (send panel get-number))
            (define same-path
              (if (zero? tab-count)
                  #f
                  (get-same-path (- tab-count 1))))
            
            (cond [(integer? same-path) (send panel set-selection same-path)]
                  [else
                   (send panel add-tab
                         (path-get-filename path)
                         path
                         #t
                         (read-json-graph path))
                   (panel-set-selection (send panel get-selection))])))

    (define (close-graph-tab)
      (when (graph-tab-request-save-if-required (send panel get-current-tab))
            (send panel remove-tab (send panel get-selection))
            (when (zero? (send panel get-number)) (close))))
    
    ; Tab Panel
    (define panel-selection 0)
    
    (define (panel-set-selection id)
      (define from panel-selection)
      (define to (send panel get-selection))

      (cond [(not (eq? from to))
             (define old-data (send graph-canvas get-graph))
             (send panel set-tab-data! from old-data)
             
             (define new-data (send panel get-tab-data to))
             (send graph-canvas replace-graph! new-data)])
      (set! panel-selection to))
    
    (define panel
      (new graph-tab-canvas%
           [parent this]
           [choices (list "")]
           [callback
            (lambda (panel event)
              (panel-set-selection (send panel get-selection)))]))

    ; Run Algorithms
    (define (run-algorithm)
      (define agol-id (get-pref 'agol-id 0))
      
      (define solver
        (case agol-id
          [(0) graph-solver-bfs]
          [(1) graph-solver-dfs]
          [(2) graph-solver-dfs-sp]
          [(3) graph-solver-dijkstra]
          [(4) graph-solver-a-star]))
      
      (define graph (send graph-canvas get-graph))
      (define root-node-id (graph-root-node-id graph))
      (define goal-node-id (graph-goal-node-id graph))
      
      (define message
        (cond [(and (integer? root-node-id) (integer? goal-node-id))
               (define timer (timer-start))
               (define output (solver graph
                                      (get-pref 'model-id 0)
                                      root-node-id
                                      goal-node-id))
               (define time (timer-stop timer))
               (format "Output:\t ~a\nTime:\t~ams" output time)]
              [else "Root or Goal Node are not set!"]))
      
      (displayln message))

    ; Graph Canvas
    (define graph-canvas
      (new graph-canvas%
           [parent panel]
           [dark-mode? (get-pref 'dark-mode #t)]
           [draw-axis? (get-pref 'draw-axis #f)]
           [draw-grid? (get-pref 'draw-grid #t)]
           [draw-node-ids? (get-pref 'draw-node-id #f)]
           [draw-node-weights? (get-pref 'draw-node-weight #t)]
           [action-callback
            (lambda (_)
              (define current-tab (send panel get-current-tab))
              (when (tab-issaved? current-tab)
                (set-tab-issaved?! current-tab #f)
                (send panel update)))]
           [style (list 'no-focus )]))))
