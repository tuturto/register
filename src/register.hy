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
    (get [connection] 0))))

(defn create-schema [connection]
  (.execute connection "create table if not exists person (name text not null, phone text)")
  (get [connection] 0))

(defn main-menu []
  (print "********************")
  (print "     register")
  (print "")
  (print "1. add new person")
  (print "2. search")
  (print "3. edit person")
  (print "4. delete person")
  (print "5. quit")
  (print (raw-input "make a selection: ")))

(if (= __name__ "__main__")
  (let [[connection (create-schema (get-connection))]]))

