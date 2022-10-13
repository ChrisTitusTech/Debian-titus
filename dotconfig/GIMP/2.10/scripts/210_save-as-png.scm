; 210_save-as-png.scm
; last modified/tested by Paul Sherman [gimphelp.org]
; 05/11/2019 on GIMP 2.10.10
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
; Original script by Saul Goode
; sg-snapshot.scm
; http://chiselapp.com/user/saulgoode/repository/script-fu/home
;==============================================================


(define (210_save-as-png orig-image drawable)
  ;; Save a copy of the image without affecting the UNDO HISTORY
  (let* (
		 (buffer-name (car (gimp-edit-named-copy-visible orig-image "png_copy")))
         (image (car (gimp-edit-named-paste-as-new buffer-name)))
         (layer (car (gimp-image-get-active-layer image)))
         (filename 
           (if (zero? (strcmp "" (car (gimp-image-get-filename orig-image)) ))
             "Untitled.png"
             (car (gimp-image-get-filename orig-image)) ))
         (fn-components (strbreakup filename "."))
         )
    (set! fn-components (unbreakupstr (butlast fn-components) "."))
    (set! filename (string-append fn-components
                                  ".png" ))
								  
	(if (= 1 (car (gimp-drawable-is-indexed drawable)))
		(gimp-image-convert-indexed image
			NO-DITHER
			MAKE-PALETTE 
			255
			FALSE
			FALSE
			""))					  
									
	(file-png-save-defaults RUN-NONINTERACTIVE image layer filename filename)
    (gimp-image-delete image)
    (gimp-buffer-delete buffer-name)
	(gimp-image-clean-all orig-image)
    )
  )
        
(script-fu-register "210_save-as-png"
  "save as PNG"
  "Save the image as a PNG file.\n\nFor more options and a proper file overwrite protected dialog, \nuse the FILE > EXPORT menu item when saving as a PNG.\n"
  "Paul Sherman"
  "Paul Sherman"
  "Aug 2011"
  "*"
  SF-IMAGE    "Image"    0
  SF-DRAWABLE "The Layer" 0
)
(script-fu-menu-register "210_save-as-png" "<Image>/File/Save/")
 