;; -*- coding: utf-8 -*-
;;
;;   Copyright 2013 Tuukka Turto
;;
;;   This file is part of register.
;;
;;   register is free software: you can redistribute it and/or modify
;;   it under the terms of the GNU General Public License as published by
;;   the Free Software Foundation, either version 3 of the License, or
;;   (at your option) any later version.
;;
;;   register is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;   GNU General Public License for more details.
;;
;;   You should have received a copy of the GNU General Public License
;;   along with register.  If not, see <http://www.gnu.org/licenses/>.

(import [database [get-connection create-schema insert-person query-person]])
(import [database [load-person delete-person update-person]])

(defn add-person [connection]
  (print "********************")
  (print "    add person")
  (print "")
  (let [[person-name (raw-input "enter name: ")]
        [phone-number (raw-input "enter phone number: ")]]
    (insert-person connection person-name phone-number)
    True))

(defn display-row [row]
  (print (get row 0) (get row 1) (get row 2)))

(defn search-person [connection]
  (print "********************")
  (print "    search person")
  (print "")
  (let [[search-criteria (raw-input "enter name or phone number: ")]]
    (for (row (query-person connection search-criteria)) (display-row row)))
  True)

(defn edit-person [connection]
  (print "********************")
  (print "     edit person")
  (print "")
  (let [[person-id (raw-input "enter id of person to edit: ")]
	[row (load-person connection person-id)]]
    (if row (do (print "found person")
		(display-row row)
		(let [[new-name (raw-input "enter new name or press enter: ")]
		      [new-phone (raw-input "enter new phone or press enter: ")]]
		  (update-person connection (if new-name new-name (get row 1)) (if new-phone new-phone (get row 2)) (get row 0))))
	(print "could not find a person with that id")))
  True)

(defn remove-person [connection]
  (print "********************")
  (print "   delete person")
  (print "")
  (let [[person-id (raw-input "enter id of person to delete: ")]]
    (delete-person connection person-id))
  True)

(defn quit [connection]
  (.close connection)
  False)

(defn main-menu [connection]
  (let [[menu-choices {"1" add-person
			   "2" search-person
			   "3" edit-person
			   "4" remove-person
			   "5" quit}]]
    (print "********************")
    (print "     register")
    (print "")
    (print "1. add new person")
    (print "2. search")
    (print "3. edit person")
    (print "4. delete person")
    (print "5. quit")
    (print "")
    (try (let [[selection (get menu-choices (raw-input "make a selection: "))]]
	   (selection connection))
	 (catch [e KeyError] (print "Please choose between 1 and 5") True))))

(if (= __name__ "__main__")
  (let [[connection (create-schema (get-connection))]]
    (while (main-menu connection) [])))
 
