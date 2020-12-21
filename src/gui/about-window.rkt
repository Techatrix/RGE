#lang racket/gui

(require browser/external)

(provide open-about-window)

(define (open-about-window gui)
  (define frame
    (new frame%
         [parent gui]
         [label "About RGE"]
         [width 500]
         [height 200]
         [min-width 400]
         [min-height 130]
         [stretchable-width #f]
         [stretchable-height #f]
         [style (list 'no-resize-border)]))
  
  (new message%
       [label "Racket Graph Explorer"]
       [parent frame]
       [font (make-object font% 20 'modern)])
  (new message%
       [label "Made by: Arian Hosseini (Techatrix)"]
       [parent frame]
       [vert-margin 8]
       [horiz-margin 32]
       [stretchable-width #t])
  (define panel (new horizontal-panel% [parent frame]))
  (new button%
       [label "Github Repository"]
       [parent panel]
       [vert-margin 8]
       [horiz-margin 32]
       [stretchable-width #t]
       [callback (lambda (button event)
                   (send-url "https://github.com/Techatrix/RGE"))])
  
  (send frame center)
  (send frame show #t))
