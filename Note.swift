//
//  Note.swift
//  Notes
//
//  Created by Elena Vigo Olivan on 12/07/2020.
//  Copyright © 2020 None. All rights reserved.
//

import Foundation
import SQLite3

struct Note {
    let id: Int
    var contents: String
    var done: Int
}

class NoteManager {
    var database: OpaquePointer!
    
    static let main = NoteManager()
    
    func connect () {
        if database != nil {
            return
        }
        do {
            let databaseURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("notes.sqlite3")
            
            if sqlite3_open(databaseURL.path, &database) == SQLITE_OK {
                if sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS notes (contents TEXT, done INT)", nil, nil, nil) == SQLITE_OK {
                    
                } else {
                    print("Could not create table")
                }
            } else {
                print("Could not connect")
            }
        }
        catch let error {
            print("Could not create database")
        }
    }
    
    func create() -> Int {
        connect()
        var statement: OpaquePointer!
        
        if sqlite3_prepare(database, "INSERT INTO notes (contents, done) VALUES ('Empty task', 0)", -1, &statement, nil) != SQLITE_OK {
                print("Coult not create query")
                return -1
            }
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Coult not insert note")
            return -1
        }
        sqlite3_finalize(statement)
        
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func getAllNotes() -> [Note] {
        connect()
        
        var result: [Note] = []
        var statement: OpaquePointer!
        
        if sqlite3_prepare_v2(database, "SELECT rowid, contents, done FROM notes", -1, &statement, nil) != SQLITE_OK {
            print("Error creating select")
            return []
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            result.append(Note(id: Int(sqlite3_column_int(statement, 0)), contents: String(cString: sqlite3_column_text(statement, 1)), done: Int(sqlite3_column_int(statement, 2))))
        }
        
        sqlite3_finalize(statement)
        
        return result
    }
    
    func save(note: Note) {
        connect()
        var statement: OpaquePointer!
        
        if sqlite3_prepare_v2(database, "UPDATE notes SET contents = ?, done = ? WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Error creating update statement")
        }
        
        sqlite3_bind_text(statement, 1, NSString(string: note.contents).utf8String, -1, nil)
        sqlite3_bind_int(statement, 2, Int32(note.done))
        sqlite3_bind_int(statement, 3, Int32(note.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error runnig update")
        }
        
        sqlite3_finalize(statement)
    }
    
    func delete(note: Note) {
        connect()
        var statement: OpaquePointer!
        
        if sqlite3_prepare_v2(database, "DELETE FROM notes WHERE rowid = ?", -1, &statement, nil) != SQLITE_OK {
            print("Error deleting the note")
        }
        
        sqlite3_bind_int(statement, 1, Int32(note.id))
        
        if sqlite3_step(statement) != SQLITE_DONE {
            print("Error runnig delete")
        }
        
        sqlite3_finalize(statement)
    }
}
