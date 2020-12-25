#lang racket/gui

(require "../util/util.rkt")

(provide (struct-out tab)
         graph-tab-canvas%)

(struct tab (label
             path
             [issaved? #:mutable]
             data))

(define (tab-set-data _tab new-data)
  (tab (tab-label _tab)
       (tab-path _tab)
       (tab-issaved? _tab)
       new-data))

(define graph-tab-canvas%
  (class tab-panel%
    (super-new)
    (init-field [tabs (list (tab "untitled" #f #t #f) )])

    (inherit delete
             get-number
             get-selection
             set-selection
             set-item-label)
    
    ; getter
    (define/public (get-tab i)
      (list-ref tabs i))
    
    (define/public (get-tab-data i)
      (tab-data (get-tab i)))

    (define/public (get-current-tab)
      (get-tab (get-selection)))

    ; setter
    (define/private (set-tabs! new-tabs)
      (set! tabs new-tabs)
      (update-tabs))
    
    (define/public (set-tab! i tab)
      (set-tabs! (list-replace-n tabs i tab)))
    
    (define/public (set-tab-data! i data)
      (define tab (get-tab i))
      (set-tab! i (tab-set-data tab data)))
    
    (define/public (set-current-tab! tab)
      (set-tab! (get-selection) tab))
    
    ; add/remove tab
    (define/public (add-tab [label #f]
                            [path #f]
                            [issaved? #f]
                            [data #f])
      (send this append label)
      (set-tabs! (append tabs (list (tab label path issaved? data))))
      (set-selection (- (get-number) 1)))

    (define/public (remove-tab i)
      (delete i)
      (set-tabs! (list-remove-n tabs i)))
    
    ; update
    (define/private (update-tab tab i)
      (define label
        (string-append (if (tab-issaved? tab) "" "★ ")
                       (number->string i)
                       ": "
                       (tab-label tab)))
      (set-item-label i label))
    
    (define/private (update-tabs)
      (define (proc tabs i)
        (cond [(empty? tabs)]
              [else
               (update-tab (car tabs) i)
               (proc (rest tabs) (+ i 1))]))
      (proc tabs 0))
    
    (update-tabs)))
