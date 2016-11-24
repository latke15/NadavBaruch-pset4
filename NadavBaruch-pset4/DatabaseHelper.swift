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
private var db: Connection?

let users = Table("users")
let id = Expression<Int>("id")
let note = Expression<String>("note")
let check = Expression<Bool>("check")
    
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
            db = try Connection("\(path)/db.sqlite3")
            try createTable()
        } catch {
            // error handling
            throw error
        }
}

    private func createTable() throws {
        do {
            try db!.run(users.create(ifNotExists: true) { t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(note)
                t.column(check)
                
            } )
        } catch {
            // error handling
            throw error
        }
    }
    
    func create(note: String) throws {
        
        let insert = users.insert(self.note <- note, self.check <- false)
        
        do {
            
            let rowId = try db!.run(insert)
            
        } catch {
            // error handling
            throw error
        }
    }
    
    func read(index: Int) throws -> String? {
        var result: String?
        var count = 0
        do {
            
            for user in try db!.prepare(users) {
                if count == index {
                    result = user[note]
                }
                count += 1
            }
        } catch {
            // error handling
            throw error
            
        }
        return result
    }
    
    func readCheck(index: Int) throws -> Bool? {
        
        var result = false
        var count = 0
        
        do {
            
            for user in try db!.prepare(users) {
                if count == index {
                    result = user[check]
                }
                count += 1
            }
        } catch {
            // error handling
            throw error
            
        }
        return result
    }
    
    func checkSwitch(index: Int) throws {
        
        var rowID: Int
        var rowCheck: Bool
        rowID = 0
        rowCheck = false
        var count = 0
        
        do {
            for row in try db!.prepare(users.select(id, check)) {
                if count == index {
                    rowID = (row[id])
                    rowCheck = row[check]
                }
                count += 1
            }
        } catch {
            throw error
        }
        
        let checkState = users.filter(id == rowID)
        
        if(rowCheck == false) {
            do {
                print(try db!.run(checkState.update(check <- true)))
            } catch {
                print(error)
            }
        } else {
            do {
                print(try db!.run(checkState.update(check <- false)))
            } catch {
                print(error)
            }
        }
    }
    
    func countRows() throws -> Int? {
        var count = 0
        do {
            
            count = try db!.scalar(users.select(note.count))
//            print(count)
            
        } catch {
            
            // error handling
            throw error
        }
        return count
        
    }
    
    func deleteRows(index: Int) throws {
        var rowId = Int()
        var count = 0
        
        do {
            for checkId in try db!.prepare(users) {
                if count == index {
                    rowId = checkId[id]
                }
                count += 1
            }
            let note = users.filter(id == rowId)
            try db!.run(note.delete())
        } catch {
            print("delete failed: \(error)")
        }
    }
}

