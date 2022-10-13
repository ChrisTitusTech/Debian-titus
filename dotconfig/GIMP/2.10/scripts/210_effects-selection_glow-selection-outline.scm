; 210_effects-selection_glow-selection.scm
; last modified/tested by Paul Sherman [gimphelp.org]
; 08/26/2018 on GIMP 2.10.6
;==================================================
;
; Installation:
; This script should be placed in the user or system-wide script folder.
;
;	Windows 7/10
;	C:\Program Files\GIMP 2\share\gimp\2.0\scripts
;	or
;	C:\Users\YOUR-NAME\AppData\Roaming\GIMP\2.10\scripts
;	
;    
;	Linux
;	/home/yourname/.config/GIMP/2.10/scripts  
;	or
;	Linux system-wide
;	/usr/share/gimp/2.0/scripts
;
;==================================================
;
; LICENSE
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
;==============================================================
; Original information 
; 
; Glow
; Copyright (c) 1997 Adrian Likins
; aklikins@eos.ncsu.ed
;
;  Makes a "glow" around the outside of the current selection.
;==============================================================


(define (my-pair->string pair)
  (cons ((pair? (cdr pair))
	 (my-list->string pair))
	(else
	 (print "aoeuo")
	 (string-append "("   (to-string (car pair))
			" . " (to-string (cdr pair)) ")"))))

(define (flatten-string-list str lst)
  (cond ((not (null? lst))
	 (flatten-string-list (string-append str (car lst) " ")
			      (cdr lst)))
	(else
	 str)))

(define (my-list->string pair)
  (let ((string-list (flatten-string-list ""
		      (map (lambda (x) (to-string x)) pair))))
    (string-append "(" string-list ")")))

(define (to-string arg)
  (cond ((number? arg)
	 (number->string arg))
	((string? arg)
	 arg)
	((symbol? arg)
	 " <symbol is unhandeld> ")
	((pair? arg)
	 (my-pair->string arg))
	(else
	 " <unhandeled> ")))

(define (message-box . args)
  (gimp-message (apply string-append (map to-string args))))
  
  
(define (210-glow-selection-outline image
			drawable
			glow-radius
			feather-radius
			glow-color
			glow-opacity
			keep-selection)

			
    (if (= (car (gimp-selection-is-empty image)) TRUE)
	(begin
	  (message-box "The current image doesn't have a selection.\n\nThis plugin creates a glow effect around a \nSELECTED AREA of the image."))
	(begin
	    (gimp-image-undo-group-start image)	  
	    (if (not (= RGB (car (gimp-image-base-type image))))
		    	 (gimp-image-convert-rgb image))	
		(define seperate-layer TRUE)
	    (define from-selection TRUE)
	    (define active-selection (car (gimp-selection-save image)))
	 
  (let* (
	 (type (car (gimp-drawable-type-with-alpha drawable)))
	 (old-gradient (car (gimp-context-get-gradient)))
	 (old-fg (car (gimp-context-get-foreground)))
	 (old-bg (car (gimp-context-get-background))))
    
    (gimp-layer-add-alpha drawable)

    (define selection-bounds (gimp-selection-bounds image))
    (define select-offset-x (cadr selection-bounds))
    (define select-offset-y (caddr selection-bounds))
    (define select-width (- (cadr (cddr selection-bounds)) select-offset-x))
    (define select-height (- (caddr (cddr selection-bounds)) select-offset-y))
    (define buffer (+ (* glow-radius 2) (* feather-radius 2) 2))
    (define select-height (+ select-height buffer))
    (define select-width (+ select-width buffer))
    (define select-offset-x (- select-offset-x (/ buffer 2)))
    (define select-offset-y (- select-offset-y (/ buffer 2)))
    
    (if (= seperate-layer TRUE)
	(begin
	  (define effect-layer (car (gimp-layer-new image
						  select-width
						  select-height
						  type
						  "glow layer"
						  100
						  LAYER-MODE-NORMAL-LEGACY)))
	  (gimp-layer-set-offsets effect-layer select-offset-x select-offset-y)
	  (gimp-image-insert-layer image effect-layer 0 -1)
	  (gimp-selection-none image)
	  (gimp-edit-clear effect-layer)
	  (gimp-image-select-item image CHANNEL-OP-REPLACE active-selection)
	  (gimp-image-set-active-layer image effect-layer ))
	(begin
	  (gimp-edit-copy drawable)))
    (define active-layer (car (gimp-image-get-active-layer image)))

    (gimp-selection-grow image glow-radius)
    (gimp-selection-feather image feather-radius)
    (gimp-context-set-background glow-color)
    (gimp-edit-fill active-layer BACKGROUND-FILL)
    
    (if (= seperate-layer TRUE)
	(begin
	  (gimp-image-select-item image CHANNEL-OP-REPLACE active-selection)
	  (gimp-edit-clear active-layer)
	  (gimp-layer-set-opacity active-layer glow-opacity))
	(begin
	  (gimp-image-select-item image CHANNEL-OP-REPLACE active-selection)
	  (let ((floating-sel (car (gimp-edit-paste active-layer FALSE))))
	      (gimp-floating-sel-anchor floating-sel))
	  (gimp-image-select-item image CHANNEL-OP-REPLACE active-selection)))
    
    (gimp-context-set-gradient old-gradient)
    (gimp-context-set-background old-bg)
    (gimp-context-set-foreground old-fg)
    
    (if (= keep-selection FALSE)
	(gimp-selection-none image))
    
    (gimp-image-set-active-layer image drawable)
    (gimp-image-remove-channel image active-selection)
    
;Finish the undo group for the process
    (gimp-image-undo-group-end image)   
    
    (gimp-displays-flush)))
    ))

(script-fu-register "210-glow-selection-outline"
		    "<Image>/Script-Fu/Effects Selection/Glow Selection Outline"
		    "Makes a \"glow\" around the outside of the current selection."
		    "Adrian Likins <adrian@gimp.org>"
		    "Adrian Likins"
		    "10/12/97"
		    "*"
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Drawable" 0
		    SF-VALUE "Glow Radius" "5"
		    SF-VALUE "Feather Radius" "0"
		    SF-COLOR "Glow Color" '(255 160 0)
		    SF-VALUE "Glow Opacity (only for seperate layer)" "100"
		    SF-TOGGLE "Keep Selection?" TRUE)
