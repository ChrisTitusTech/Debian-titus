; 210_save-as-jpg.scm
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
; script-fu-quick-jpeg-save.scm
; http://chiselapp.com/user/saulgoode/repository/script-fu/home
;==============================================================


 (define (210_save-as-jpg image) 
  (let* ((nameparts (strbreakup (car (gimp-image-get-filename image)) "."))
         (filename "")
		 )
    (unless (and (> (length nameparts) 1)
                 (member (car (last nameparts)) '("jpg" "jpeg" "JPG" "JPEG"))
				 )
	(set! nameparts (append (butlast nameparts) '("jpg"))) )
    (set! filename (unbreakupstr nameparts "."))
    (let* ((buffer (car (gimp-edit-named-copy-visible image "jpg buffer")))
		(new-image (car (gimp-edit-named-paste-as-new buffer)))
		(layer (car (gimp-image-flatten new-image))) )
		(unless (zero? (car (gimp-image-base-type new-image)))
        (gimp-image-convert-rgb new-image) )
        (file-jpeg-save RUN-NONINTERACTIVE 
			  new-image 
			  layer
			  filename 
			  filename 
			  0.92 ; JPEG compression level
			  0 ; smoothing 
			  1 ; optimize 
			  0 ; progressive 
			  "" ; comment 
			  0 ; subsmp (0-4)
			  1 ; baseline 
			  0 ; restart 
			  0 ;dct 
			  )
      (gimp-image-delete new-image)
	  (gimp-image-clean-all image)
	  )))

(script-fu-register "210_save-as-jpg"
  "Save as JPG"
  "Save the image as a JPG file\n\nFor more options and a proper file overwrite protected dialog, \nuse the FILE > EXPORT menu item when saving as a JPG.\n"
  "Paul Sherman"
  "Paul Sherman"
  "February 2014"
  "*"
  SF-IMAGE    "Image"    0
  )
(script-fu-menu-register "210_save-as-jpg" "<Image>/File/Save/")