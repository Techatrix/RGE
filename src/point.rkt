#lang racket
(require "util.rkt")

(provide point%)
(provide point-d)
(provide point-r)

(define point-d 50)
(define point-r (/ point-d 2))

; Point Class
(define point%
  (class object%
    (init-field [id 0]
                [position '(0 0)]
                [connections '()])
    ; Getter
    (define/public (get-id) id)
    (define/public (get-pos) position)
    (define/public (get-pos-x) (car position))
    (define/public (get-pos-y) (car (cdr position)))
    (define/public (get-con) connections)
    ; Draw
    (define/public (draw-point dc) (send dc draw-ellipse (send this get-pos-x) (send this get-pos-y) point-d point-d))
    (define/public (draw-connection dc x y) (draw-line dc (+ (send this get-pos-x) point-r) (+ (send this get-pos-y) point-r) (+ x point-r) (+ y point-r)))

    ; Has Connection
    (define/public (has-con-i i) (_has-con-i i connections))
    ; Add Connection
    (define/public (add-con c)
      (cond [(eq? (car c) id) (writeln "warning: creating connections to self")]
            [(has-con-i (car c)) (writeln "warning: connections already exists")]
            [else (set! connections (append connections (list c)))])
      this)
    ; Remove Connection
    (define/public (remove-con-i i)
      (cond [(eq? i id) (writeln "warning: removing connection to self")]
            [else (set! connections (_remove-con-i i connections))])
      this)

    ; Util
    (define/public (ishit x y) (< (dst-PtoP (send this get-pos-x) (send this get-pos-y) x y) point-r))
    (define/public (move-pos delta-pos) (set! position (list (+ (get-pos-x) (car delta-pos)) (+ (get-pos-y) (cadr delta-pos)))) this)

    (define/public (print-point) (writeln (string-append (number->string id) ", (" (number->string (get-pos-x)) " " (number->string (get-pos-y)) "), " )))

    ; Private
    (define/private (_has-con-i i connections)
      (cond [(empty? connections) #f]
            [(eq? (car (car connections)) i) #t]
            [else (_has-con-i i (rest connections))]
            ))
    
    (define/private (_remove-con-i i connections)
      (cond [(empty? connections) '()]
            [(eq? (car (car connections)) i) (rest connections)]
            [else (append (list (car connections)) (_remove-con-i i (rest connections)))]))
    
    (super-new)))