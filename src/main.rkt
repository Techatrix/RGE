#lang racket/gui
(require "point.rkt")
(require "graph.rkt")
(require "event-canvas.rkt")

; Racket Graph Explorer
; GUI Setup
(define frame (new frame% [label "Graph Note Explorer"] [width 600] [height 600]))


; Message Box
(define msg-mode (new message% [parent frame]
                          [label "Mode: 0"]))

; Tool Bar
(define mode 0)
(define mode-data '()) ; Mode Specific Data
(define e-b-list '()) ; List of Buttons

(define (e-b-func button dc i)
  (set! mode i)
  (set! mode-data '())
  (send msg-mode set-label (string-append "Mode " (number->string i))))
(define (e-b-add name i) (set! e-b-list (append e-b-list (list (new button% [parent panel] [label name] [callback (lambda (button dc) (e-b-func button dc i))])))))

(define panel (new horizontal-panel% [parent frame]
                                     [alignment '(center center)]
                                     [stretchable-height #f]))
(e-b-add "Add Point" 0)
(e-b-add "Remove Point" 1)
(e-b-add "Add Connection" 2)
(e-b-add "Remove Connection" 3)
(e-b-add "Move Point" 4)

; Graph Instance
(define graph (new graph%))

; Graph Points
; (send graph add-point-pc '(100 100) '((1 5) (2 3)))
; (send graph add-point-pc '(200 100) '((0 5)      ))
; (send graph add-point-pc '(400 200) '((0 3)      ))

(define mouse-pos-x -1)
(define mouse-pos-y -1)

(define (mouse-getpos event) (list (- (send event get-x) point-r) (- (send event get-y) point-r)))

(define (on-mouse-down-event event)
  (cond [(eq? mode 0) (send graph add-point-p (mouse-getpos event))]
        [(eq? mode 1) (send graph remove-point-p (mouse-getpos event))]
        [(or (eq? mode 2) (eq? mode 3))
         (let [(p (send graph get-point-p (mouse-getpos event)))]
           (cond [(number? p) (set! mode-data '())]
                 [else (set! mode-data (append mode-data (list p)) )]))
         (cond [(eq? (length mode-data) 2)
                (cond [(eq? mode 2) (send graph add-connection-pp (send (car mode-data) get-pos) (send (cadr mode-data) get-pos))]
                      [(eq? mode 3) (send graph remove-connection-pp (send (car mode-data) get-pos) (send (cadr mode-data) get-pos))])
                (set! mode-data '())])])
  (send graph-canvas refresh))

(define (on-mouse-motion-event event)
  (cond [(eq? mode 4)
         (cond [(send event get-left-down)
                (send graph move-point-p (mouse-getpos event) (list (- (send event get-x) mouse-pos-x) (- (send event get-y) mouse-pos-y)))
                (send graph-canvas refresh)])])
  (set! mouse-pos-x (send event get-x))
  (set! mouse-pos-y (send event get-y)))


; GraphCanvas Instance
(define graph-canvas
  (new event-canvas%
       [parent frame]
       [mouse-down-event-callback on-mouse-down-event]
       [mouse-motion-event-callback on-mouse-motion-event]
       [paint-callback
        (lambda (canvas dc)
          (send graph draw dc))]))

(send (send graph-canvas get-dc) set-smoothing 'smoothed)

(send frame show #t)
