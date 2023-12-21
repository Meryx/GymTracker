//
//  DatabaseManager.swift
//  GymTracker
//
//  Created by Anwar Haredy on 08/06/1445 AH.
//

import Foundation
import SQLite

class DatabaseManager: ObservableObject {
    private var db: Connection?
    
    init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            print("Database Path: \(path)/db.sqlite3") // Print the database path
            db = try Connection("\(path)/db.sqlite3")
            createTables()
        }
        catch {
            print("Unable to establish connection to the database: \(error)")
        }
    }
    private func createTables() {
        let programs = Table("programs")
        let id = Expression<Int64>("id")
        let name = Expression<String>("name")
        
        do {
            try db?.run(programs.create { t in
                t.column(id, primaryKey: true)
                t.column(name)
            })
        } catch {
            print("Unable to create table: \(error)")
        }
    }
    
    func fetchPrograms() -> [Program] {
        let programsTable = Table("programs")
        var programs = [Program]()
        
        do {
            for program in try db!.prepare(programsTable) {
                let id = program[Expression<Int64>("id")]
                let name = program[Expression<String>("name")]
                
                programs.append(Program(id: id, name: name))
            }
        } catch {
            print("Unable to fetch programs: \(error)")
        }
        return programs
    }
    
    func addProgramIfTableEmpty(name: String) {
        let programs = Table("programs")
        let nameColumn = Expression<String>("name")

        do {
            // Check if any row exists
            if let count = try db?.scalar(programs.count), count == 0 {
                // If no rows exist, insert a new row
                let insert = programs.insert(nameColumn <- name)
                try db?.run(insert)
                print("New row added as the table was empty.")
            } else {
                // If the table is not empty, just return
                print("The table is not empty. No row added.")
            }
        } catch {
            print("Database error: \(error)")
        }
    }
}

struct Program {
    let id: Int64
    let name: String
    // Add other fields as necessary
}
