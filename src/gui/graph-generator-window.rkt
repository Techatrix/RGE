#lang racket/gui

(require "../graph/graph.rkt")

(provide open-graph-generator-window)

(define (open-graph-generator-window gui)
  (define choices (list "Linear" "Star" "Tree" "Random"))
  (define choices-symbols (list 'linear 'star 'tree 'random))
  (define canvas (send gui get-canvas))

  (define (id->type id) (list-ref choices-symbols id))
  
  (define (options-set! key v)
    (hash-set! graph-generate-options key v)
    (when (send check-box-live get-value)
      (generate)))
  (define (options-ref key failure-result)
    (hash-ref graph-generate-options key failure-result))
  (define (generate)
    (define graph (graph-generate (id->type (send tab-panel get-selection))))
    (send (send gui get-canvas) set-graph! graph))
  
  (define (tab-panel-callback panel)
    (send tab-panel change-children
          (lambda (_)
            (define max-node-count 100)
            (define max-degree-depth 10)
            
            (case (send panel get-selection)
              [(0)
               (list
                (new slider%
                     [parent tab-panel]
                     [label "Node Count"]
                     [min-value 0]
                     [max-value max-node-count]
                     [init-value (options-ref 'linear-node-count 50)]
                     [callback (lambda (slider _)
                                 (options-set! 'linear-node-count (send slider get-value)))])
                (new check-box%
                     [parent tab-panel]
                     [label "Circular Layout"]
                     [value (options-ref 'linear-circular-layout #f)]
                     [callback
                      (lambda (check-box event)
                        (options-set! 'linear-circular-layout (send check-box get-value)))]))]
              [(1)
               (list
                (new slider%
                     [parent tab-panel]
                     [label "Degree"]
                     [min-value 0]
                     [max-value max-degree-depth]
                     [init-value (options-ref 'star-degree 3)]
                     [callback (lambda (slider _)
                                 (options-set! 'star-degree (send slider get-value)))])
                (new slider%
                     [parent tab-panel]
                     [label "Depth"]
                     [min-value 0]
                     [max-value max-degree-depth]
                     [init-value (options-ref 'star-depth 3)]
                     [callback (lambda (slider _)
                                 (options-set! 'star-depth (send slider get-value)))]))]
              [(2)
               (list
                (new slider%
                     [parent tab-panel]
                     [label "Degree"]
                     [min-value 0]
                     [max-value max-degree-depth]
                     [init-value (options-ref 'tree-degree 3)]
                     [callback (lambda (slider _)
                                 (options-set! 'tree-degree (send slider get-value)))])
                (new slider%
                     [parent tab-panel]
                     [label "Depth"]
                     [min-value 0]
                     [max-value max-degree-depth]
                     [init-value (options-ref 'tree-depth 3)]
                     [callback (lambda (slider _)
                                 (options-set! 'tree-depth (send slider get-value)))]))]
              [(3)
               (list
                (new slider%
                     [parent tab-panel]
                     [label "Node Count"]
                     [min-value 0]
                     [max-value max-node-count]
                     [init-value (options-ref 'random-node-count 50)]
                     [callback (lambda (slider _)
                                 (options-set! 'random-node-count (send slider get-value)))])
                (new slider%
                     [parent tab-panel]
                     [label "Connection Probability %"]
                     [min-value 0]
                     [max-value 100]
                     [init-value
                      (exact-round (* (options-ref 'random-connection-probability 0.01) 100))]
                     [callback
                      (lambda (slider _)
                        (define value (/ (send slider get-value) 100))
                        (options-set! 'random-connection-probability value))])
                (new slider%
                     [parent tab-panel]
                     [label "Radius"]
                     [min-value 0]
                     [max-value 100]
                     [init-value (options-ref 'random-radius 20)]
                     [callback (lambda (slider _)
                                 (options-set! 'random-radius (send slider get-value)))]))]))))
  
  (define frame
    (new frame%
         [parent gui]
         [label "Generate Graph"]
         [width 500]
         [height 200]
         [min-width 500]
         [min-height 200]
         [stretchable-width #f]
         [stretchable-height #f]
         [style (list 'no-resize-border)]))
  (define tab-panel
    (new tab-panel%
         [parent frame]
         [choices choices]
         [callback
          (lambda (panel event)
            (tab-panel-callback panel))]))

  (define check-box-live
    (new check-box%
         [parent frame]
         [label "Live Preview"]
         [value #f]))
  (new button%
       [parent frame]
       [label "Create Graph"]
       [stretchable-width #t]
       [callback
        (lambda (button event)
          (generate))])
  
  (tab-panel-callback tab-panel)
  (send frame center)
  (send frame show #t))