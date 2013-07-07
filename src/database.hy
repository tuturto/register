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
  (.connect sqlite3 "register.db"))

(defn create-schema [connection]
  (.execute connection "create table if not exists person (name text not null, phone text)")
  connection)

(defn insert-person [connection person]
  (let [[params (, (:name person) (:number person))]]
    (.execute connection "insert into person (name, phone) values (?, ?)" params)))

(defn row-to-person [row]
  {:id (get row 0) :name (get row 1) :number (get row 2)})

(defn query-person [connection search-criteria]
  (let [[search-term (+ "%" search-criteria "%")]
        [search-param (, search-term search-term)]]
    (list-comp (row-to-person row) [row (.fetchall (.execute connection "select OID, name, phone from person where name like ? or phone like ?" search-param))])))

(defn load-person [connection person-id]
  (row-to-person (.fetchone (.execute connection "select OID, name, phone from person where OID=?" person-id))))

(defn delete-person [connection person-id]
  (.execute connection "delete from person where OID=?" person-id))

(defn update-person [connection person]
  (let [[params (, (:name person) (:number person) (:id person))]]
    (.execute connection "update person set name=?, phone=? where OID=?" params)))
