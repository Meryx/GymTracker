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
        let fileManager = FileManager.default
        let databaseFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)/db.sqlite3"
        
        if fileManager.fileExists(atPath: databaseFilePath) {
            do {
                try fileManager.removeItem(atPath: databaseFilePath)
                print("Existing database deleted.")
            } catch {
                print("Error deleting database: \(error)")
            }
        }
        
        do {
            db = try Connection(databaseFilePath)
            createTables()
        } catch {
            print("Unable to establish connection to the database: \(error)")
        }
    }

    private func createTables() {
        let programs = Table("programs")
        let programsID = Expression<Int64>("id")
        let programsName = Expression<String>("name")

        let days = Table("days")
        let daysID = Expression<Int64>("id")
        let daysName = Expression<String>("name")
        let daysProgramID = Expression<Int64>("program_id")

        do {
            try db?.run(programs.create { t in
                t.column(programsID, primaryKey: .autoincrement)
                t.column(programsName)
            })

            try db?.run(days.create { t in
                t.column(daysID, primaryKey: .autoincrement)
                t.column(daysName)
                t.column(daysProgramID, references: programs, programsID)
            })
        } catch {
            print("Unable to create tables: \(error)")
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

        let days = Table("days")
        let daysName = Expression<String>("name")
        let daysProgramID = Expression<Int64>("program_id")

        do {
            // Check if any program row exists
            if let programCount = try db?.scalar(programs.count), programCount == 0 {
                // If no program exists, insert a new program
                let insertProgram = programs.insert(nameColumn <- name)
                let programId = try db?.run(insertProgram)
                print("New program added as the table was empty.")

                // Insert a new day associated with the newly added program
                if let programId = programId {
                    let insertDay = days.insert(daysName <- "leg day", daysProgramID <- programId)
                    try db?.run(insertDay)
                    print("New day 'leg day' added to the program.")
                }
            } else {
                // If the table is not empty, just return
                print("The table is not empty. No row added.")
            }
        } catch {
            print("Database error: \(error)")
        }
    }

}

class ProgramListViewModel: ObservableObject {
    @Published var programs: [Program] = []
}

struct Program {
    let id: Int64
    let name: String
    // Add other fields as necessary
}
