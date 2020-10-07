#lang racket/gui

(require "graph-canvas.rkt")
(require "../util/util.rkt")

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
           [label "&File"]))
    (new menu-item%
         [parent menu-1]
         [label "New"]
         [shortcut #\N]
         [callback
          (lambda (item event)
            (displayln "New"))])
    (new menu-item%
         [parent menu-1]
         [label "New Graph"]
         [shortcut #\T]
         [callback
          (lambda (item event)
            (panel-add-tab "Untitled")
            (send tab-panel set-selection (- (send tab-panel get-number) 1))
            (displayln "New Graph"))])
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
         [label "Save"]
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
         [label "Close"]
         [shortcut #\W]
         [callback
          (lambda (item event)
            (cond [(eq? (send tab-panel get-number) 1) (exit)]
                  [else (panel-remove-tab (send tab-panel get-selection))])
            (displayln "Close"))])
    (new menu-item%
         [parent menu-1]
         [label "Quit"]
         [shortcut #\Q]
         [callback
          (lambda (item event)
            (displayln "Quit")
            (exit))])
  
    ; Edit Menu
    (define menu-2
      (new menu%
           [parent menu-bar]
           [label "&Edit"]))

    (new menu-item%
         [parent menu-2]
         [label "Undo"]
         [shortcut #\Z]
         [callback
          (lambda (item event)
            (displayln "Undo"))])
    (new menu-item%
         [parent menu-2]
         [label "Redo"]
         [shortcut #\Z]
         [shortcut-prefix (list 'shift 'ctl)]
         [callback
          (lambda (item event)
            (displayln "Redo"))])
    (new separator-menu-item% [parent menu-2])
    (new menu-item%
         [parent menu-2]
         [label "Clear All"]
         [callback
          (lambda (item event)
            (displayln "Clear All"))])
    (new menu%
         [label "Sub Menu"]
         [parent menu-2])
    
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
            (displayln "Zoom in"))])
    (new menu-item%
         [parent menu-3]
         [label "Zoom out"]
         [shortcut 'subtract]
         [callback
          (lambda (item event)
            (displayln "Zoom out"))])
    (new menu-item%
         [parent menu-3]
         [label "View auto"]
         [callback
          (lambda (item event)
            (displayln "View auto"))])

    (new checkable-menu-item%
         [parent menu-3]
         [label "Draw Axis"]
         [checked #f]
         [callback
          (lambda (item event)
            (displayln "Draw Axis"))])
    (new checkable-menu-item%
         [parent menu-3]
         [label "Draw Grid"]
         [checked #t]
         [callback
          (lambda (item event)
            (displayln "Draw Grid"))])
    
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
              (displayln "Model: Racket"))]))
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
              (displayln "Model: Racket Optimized"))]))
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
              (displayln "Model: Racket Typed"))]))
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
              (displayln "Model: FFI"))]))
    
    ; Tabs Menu
    (define menu-5
      (new menu%
           [parent menu-bar]
           [label "&Tabs"]))
    
    (new menu-item%
         [parent menu-5]
         [label "Previous Tab"]
         [shortcut #\[]
         [callback
          (lambda (item event)
            (define new-selection (number-wrap 0 (- (send tab-panel get-number) 1) (- (send tab-panel get-selection) 1)))
            (send tab-panel set-selection new-selection)
            (panel-set-selection new-selection))])
    (new menu-item%
         [parent menu-5]
         [label "Next Tab"]
         [shortcut #\]]
         [callback
          (lambda (item event)
            (define new-selection (number-wrap 0 (- (send tab-panel get-number) 1) (+ (send tab-panel get-selection) 1)))
            (send tab-panel set-selection new-selection)
            (panel-set-selection new-selection))])
    
    (new separator-menu-item% [parent menu-4])

    ; menu-item: Tabs 1-8
    (map (lambda (n)
           (new menu-item%
                [parent menu-5]
                [label (string-append "Tab " (number->string n))]
                [shortcut (integer->char (+ n 48))]
                [callback (lambda (item event)
                            (cond [(<= n (send tab-panel get-number))
                                   (send tab-panel set-selection (- n 1))
                                   (panel-set-selection (- n 1))]))]))
         (build-list 8 (lambda (n) (+ n 1))))

    
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
            (displayln "About RGE"))])


    ;TAB: (label, issaved?, data)
    (define tabs (list (list "Untitled" #f void)))
    (define panel-selection 0)
    
    (define (tab-get-label tab) (car tab))
    (define (tab-get-label-formated tab id)
      (string-append (if (cadr tab) "" "★ ") (number->string id) ": " (car tab)))
    (define (tab-get-issaved tab) (cadr tab))
    (define (tab-get-data tab) (caddr tab))
    (define (tab-update tab data) (list (car tab) (cadr tab) data))

    (define (panel-add-tab label)
      (send tab-panel append label)
      (set! tabs (append tabs (list (list label #f void))))
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
      (cond [(empty? tabs) void]
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
             (define new-tab (tab-update tab (send graph-canvas get-data)))

             (set! tabs (panel-set-tab tabs panel-selection new-tab 0)) ; TODO: only do if required
             (send graph-canvas set-data (tab-get-data (panel-get-tab tabs id 0)))
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

    (define view-panel
      (new horizontal-panel%
           [parent tab-panel]))

    (define tool-bar-width 160)
    (define tool-bar-height #f)

    (define tool-bar-panel
      (new vertical-panel%
           [parent view-panel]
           [alignment (list 'left 'top)]
           [min-width tool-bar-width]
           [stretchable-width #f]))

    ; (define my-label (read-bitmap "/home/techatrix/Desktop/img-50.png"))
    (map (lambda (label tool)
           ; TODO: replace button% by control%
           (new button%
                [parent tool-bar-panel]
                [label label]
                [min-width tool-bar-width]
                [min-height tool-bar-height]
                [stretchable-width #f]
                [stretchable-height #f]
                [callback (lambda (button event)
                            (send graph-canvas set-tool tool))]))
         (list "add Node" "delete Node" "add Connection" "delete Connection" "move Node")
         (list 'add-node 'delete-node 'add-connection 'delete-connection 'move-node))

    ; Graph
    (define graph-canvas (new graph-canvas% [parent view-panel] [style (list 'no-focus)]))
  
    (send graph-canvas set-canvas-background (make-object color% 25 25 25))

    ))