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

(import sqlite3)

(defn get-connection []
  (do
    (let [[connection (.connect sqlite3 "register.db")]]
      (setv connection.row-factory sqlite3.Row)
      (setv connection.isolation-level None)
      connection)))

(defn create-schema [connection]
  (.execute connection "create table if not exists person (name text not null, phone text)")
  (get [connection] 0))

(defn insert-person [connection person-name phone-number]
  (let [[params (, person-name phone-number)]]
    (.execute connection "insert into person (name, phone) values (?, ?)" params)))

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

(defn query-person [connection search-criteria]
  (let [[search-term (+ "%" search-criteria "%")]
        [search-param (, search-term search-term)]]
    (.fetchall (.execute connection "select OID, name, phone from person where name like ? or phone like ?" search-param))))

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
        [row (.fetchone (.execute connection "select OID, name, phone from person where OID=?" person-id))]]
    (if row (do 
        (print "found person")
        (display-row row)
        (let [[new-name (raw-input "enter new name or press enter: ")]
              [new-phone (raw-input "enter new phone or press enter: ")]
              [params (, (if new-name new-name (get row 1))
                         (if new-phone new-phone (get row 2))
                         (get row 0))]]
          (.execute connection "update person set name=?, phone=? where OID=?" params)))
      (print "could not find a person with that id")))
  True)

(defn delete-person [connection]
  (print "********************")
  (print "   delete person")
  (print "")
  (let [[person-id (raw-input "enter id of person to delete: ")]]
        (.execute connection "delete from person where OID=?" person-id))
  True)

(defn quit [connection]
  (.close connection)
  False)

(defn main-menu [connection]
  (let [[menu-choices {"1" add-person
                       "2" search-person
                       "3" edit-person
                       "4" delete-person
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
  (try  
    (let [[selection (get menu-choices (raw-input "make a selection: "))]]
      (selection connection))
    (catch [e KeyError] (print "Please choose between 1 and 5") True))))

(if (= __name__ "__main__")
  (let [[connection (create-schema (get-connection))]]
    (while (main-menu connection) [])))

