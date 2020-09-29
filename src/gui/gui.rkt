#lang racket/gui

(require framework)
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
            (writeln "New"))])
    (new menu-item%
         [parent menu-1]
         [label "New Graph"]
         [shortcut #\T]
         [callback
          (lambda (item event)
            (add-choices tab-panel "Untitled")
            (send tab-panel set-selection (- (send tab-panel get-number) 1))
            (writeln "New Graph"))])
    (new menu-item%
         [parent menu-1]
         [label "Open"]
         [shortcut #\O]
         [callback
          (lambda (item event)
            (writeln "Open")
            (writeln (finder:get-file)))])
    (new menu-item%
         [parent menu-1]
         [label "Save"]
         [shortcut #\S]
         [callback
          (lambda (item event)
            (writeln "Save")
            (writeln (finder:put-file)))])
    (new menu-item%
         [parent menu-1]
         [label "Save as"]
         [shortcut #\S]
         [shortcut-prefix (list 'shift 'ctl)]
         [callback
          (lambda (item event)
            (writeln "Save as")
            (writeln (finder:put-file)))])
    (new menu-item%
         [parent menu-1]
         [label "Close"]
         [shortcut #\W]
         [callback
          (lambda (item event)
            (remove-choices tab-panel (send tab-panel get-selection)) ; TODO: handle last tab
            (writeln "Close"))])
    (new menu-item%
         [parent menu-1]
         [label "Quit"]
         [shortcut #\Q]
         [callback
          (lambda (item event)
            (writeln "Quit")
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
            (writeln "Undo"))])
    (new menu-item%
         [parent menu-2]
         [label "Redo"]
         [shortcut #\Z]
         [shortcut-prefix (list 'shift 'ctl)]
         [callback
          (lambda (item event)
            (writeln "Redo"))])
    (new separator-menu-item% [parent menu-2])
    (new menu-item%
         [parent menu-2]
         [label "Clear All"]
         [callback
          (lambda (item event)
            (writeln "Clear All"))])
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
            (writeln "Zoom in"))])
    (new menu-item%
         [parent menu-3]
         [label "Zoom out"]
         [shortcut 'subtract]
         [callback
          (lambda (item event)
            (writeln "Zoom out"))])
    (new menu-item%
         [parent menu-3]
         [label "View auto"]
         [callback
          (lambda (item event)
            (writeln "View auto"))])

    (new checkable-menu-item%
         [parent menu-3]
         [label "Draw Axis"]
         [checked #f]
         [callback
          (lambda (item event)
            (writeln "Draw Axis"))])
    (new checkable-menu-item%
         [parent menu-3]
         [label "Draw Grid"]
         [checked #t]
         [callback
          (lambda (item event)
            (writeln "Draw Grid"))])
    
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
              (writeln "FFI"))]))
    
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
            (send tab-panel set-selection (number-wrap 0 (- (send tab-panel get-number) 1) (- (send tab-panel get-selection) 1))))])
    (new menu-item%
         [parent menu-5]
         [label "Next Tab"]
         [shortcut #\]]
         [callback
          (lambda (item event)
            (send tab-panel set-selection (number-wrap 0 (- (send tab-panel get-number) 1) (+ (send tab-panel get-selection) 1))))])
    (new separator-menu-item% [parent menu-4])

    ; menu-item: Tabs 1-8
    (map (lambda (n)
           (new menu-item%
                [parent menu-5]
                [label (string-append "Tab " (number->string n))]
                [shortcut (integer->char (+ n 48))]
                [callback (lambda (item event) (cond [(<= n (send tab-panel get-number)) (send tab-panel set-selection (- n 1))]))]))
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
            (writeln "About RGE"))])

    (define choices-raw (list "Untitled"))
    (define (_update-choices tab-panel choices-raw i)
      (cond [(empty? choices-raw)]
            [else (send tab-panel set-item-label i (string-append (number->string i) ": " (car choices-raw)))
                  (_update-choices tab-panel (rest choices-raw) (+ i 1))]))
    (define
      (add-choices tab-panel label)
      (send tab-panel append label)
      (set! choices-raw (append choices-raw (list label)))
      (_update-choices tab-panel choices-raw 0))
    
    (define (remove-choices tab-panel i)
      (send tab-panel delete i)
      (set! choices-raw (delete-n choices-raw i))
      (_update-choices tab-panel choices-raw 0))
    
    ; Tab Panel
    (define tab-panel
      (new tab-panel%
           [parent this]
           [choices choices-raw]
           [callback
            (lambda (panel event)
              (writeln "Tab callback"))]))
    
    (_update-choices tab-panel choices-raw 0)

    (define view-panel
      (new horizontal-panel%
           [parent tab-panel]))

    (define tool-bar-size 20)
    (define tool-bar-panel
      (new vertical-panel%
           [parent view-panel]
           [alignment (list 'left 'top)]
           [min-width tool-bar-size]
           [stretchable-width #f]))

    (define tool-id 'none)
    #|
    (define my-bitmap-1 (read-bitmap "/home/techatrix/Desktop/img-50.png"))
    (define my-bitmap-2 (read-bitmap "/home/techatrix/Desktop/img-50.png"))
    (define my-bitmap-3 (read-bitmap "/home/techatrix/Desktop/img-50.png"))
    |#
    (define tool-label-1 "add Node")
    (define tool-label-2 "delete Node")
    (define tool-label-3 "add Connection")
    (define tool-label-4 "delete Connection")
    (define tool-label-5 "move Node")
    
    ; TODO: replace button% by control%
    (new button%
         [parent tool-bar-panel]
         [label tool-label-1]
         [min-width tool-bar-size]
         [min-height tool-bar-size]
         [stretchable-width #f]
         [stretchable-height #f]
         [callback (lambda (button event)
                     (send graph-canvas set-tool 'add-node))])
    (new button%
         [parent tool-bar-panel]
         [label tool-label-2]
         [min-width tool-bar-size]
         [min-height tool-bar-size]
         [stretchable-width #f]
         [stretchable-height #f]
         [callback (lambda (button event)
                     (send graph-canvas set-tool 'delete-node))])
    (new button%
         [parent tool-bar-panel]
         [label tool-label-3]
         [min-width tool-bar-size]
         [min-height tool-bar-size]
         [stretchable-width #f]
         [stretchable-height #f]
         [callback (lambda (button event)
                     (send graph-canvas set-tool 'add-connection))])
    (new button%
         [parent tool-bar-panel]
         [label tool-label-4]
         [min-width tool-bar-size]
         [min-height tool-bar-size]
         [stretchable-width #f]
         [stretchable-height #f]
         [callback (lambda (button event)
                     (send graph-canvas set-tool 'delete-connection))])
    (new button%
         [parent tool-bar-panel]
         [label tool-label-5]
         [min-width tool-bar-size]
         [min-height tool-bar-size]
         [stretchable-width #f]
         [stretchable-height #f]
         [callback (lambda (button event)
                     (send graph-canvas set-tool 'move-node))])

    ; Graph
    (define graph-canvas (new graph-canvas% [parent view-panel] [style (list 'no-focus)]))
  
    (send graph-canvas set-canvas-background (make-object color% 25 25 25))

    ))