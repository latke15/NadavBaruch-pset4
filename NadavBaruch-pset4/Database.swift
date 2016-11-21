//
//  Database.swift
//  NadavBaruch-pset4
//
//  Created by Nadav Baruch on 21-11-16.
//  Copyright © 2016 Nadav Baruch. All rights reserved.
//

import Foundation
import SQLite

class DatabaseHelper {

// MARK: SQLite database
private var database: Connection?

let users = Table("users")
let id = Expression<Int64>("id")
let note = Expression<String>("note")
    
    init?() {
        do {
            try setupDatabase()
        } catch {
            print(error)
            return nil
        }
    }

    private func setupDatabase() throws {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            database = try Connection("\(path)/db.sqlite3")
        } catch {
            // error handling
            print("Cannot connect to database: \(error)")
        }
}

    private func createTable() {
        do {
            database!.run(users.create(ifNotExists: true) { t in
                
                t.column(id, PrimaryKey:)
            
            } )
        } catch {
            // error handling
            print("Cannot create table: \(error)")
        }
}
}


