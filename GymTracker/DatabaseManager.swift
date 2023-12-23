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
        let daysID = Expression<Int64>("dayId")
        let daysName = Expression<String>("dayName")
        let daysProgramID = Expression<Int64>("program_id")
        
        let exercises = Table("exercises")
        let exerciseID = Expression<Int64>("exerciseID")
        let exerciseName = Expression<String>("exerciseName")
        let exerciseDayID = Expression<Int64>("day_id")
        
        let sets = Table("sets")
        let setID = Expression<Int64>("setID")
        let setWeight = Expression<Int64>("setWeight")
        let setReps = Expression<Int64>("setReps")
        let setExerciseID = Expression<Int64>("exercise_id")

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
            
            try db?.run(exercises.create { t in
                t.column(exerciseID, primaryKey: .autoincrement)
                t.column(exerciseName)
                t.column(exerciseDayID, references: days, daysID)
            })
            
            try db?.run(sets.create { t in
                t.column(setID, primaryKey: .autoincrement)
                t.column(setWeight)
                t.column(setReps)
                t.column(setExerciseID, references: exercises, exerciseID)
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
    
    func fetchExercisesByDayId(id: Int64) -> [Exercise] {
        let daysTable = Table("days")
        let exercisesTable = Table("exercises")
        
        let dayID = Expression<Int64>("dayId")
        let dayName = Expression<String>("dayName")
        
        let exerciseID = Expression<Int64>("exerciseId")
        let exerciseName = Expression<String>("exerciseName")
        let exerciseDayID = Expression<Int64>("day_id")
        
        var exercises: [Exercise] = []
        
        do {
            let query = exercisesTable
                .join(daysTable, on: exerciseDayID == daysTable[dayID])
                .filter(dayID == id)
                .select(exercisesTable[exerciseName], exercisesTable[exerciseID], daysTable[dayName])
            
            for exercise in try db!.prepare(query) {
                let id = exercise[exerciseID]
                let name = exercise[exerciseName]
                let dName = exercise[dayName]
                exercises.append(Exercise(exerciseId: id, exerciseName: name, dayName: dName))
            }
        } catch {
            print("\(error)")
        }
        return exercises
    }
    
    func fetchWorkoutDaysByProgramId(id: Int64) -> [WorkoutDay] {
        let programsTable = Table("programs")
        let daysTable = Table("days")

        let programsID = Expression<Int64>("id")
        let programsName = Expression<String>("name")
        
        let daysID = Expression<Int64>("dayId")
        let daysName = Expression<String>("dayName")
        let daysProgramID = Expression<Int64>("program_id")

        var days: [WorkoutDay] = []

        do {
            let query = daysTable
                .join(programsTable, on: daysProgramID == programsTable[programsID])
                .filter(programsID == id)
                .select(daysTable[daysID], daysTable[daysName], programsTable[programsName])

            for day in try db!.prepare(query) {
                let id = day[daysID]
                let name = day[daysName]
                let progName = day[programsName]
                days.append(WorkoutDay(dayId: id, dayName: name, programName: progName))
            }
        } catch {
            print("Unable to fetch workout days: \(error)")
        }
        
        print(days)

        return days
    }
    
    
    func addExercise(name: String, id: Int64) {
        let exerciseTable = Table("exercises")
        let nameColumn = Expression<String>("exerciseName")
        let idColumn = Expression<Int64>("day_id")
        
        let insertExercise = exerciseTable.insert(nameColumn <- name, idColumn <- id)
        
        do {
            try db?.run(insertExercise)
        } catch {
            print("\(error)")
        }
    }
    
    func addDay(name: String, id: Int64) {
        let daysTable = Table("days")
        let nameColumn = Expression<String>("dayName")
        let idColumn = Expression<Int64>("program_id")
        
        let insertDay = daysTable.insert(nameColumn <- name, idColumn <- id)
        
        do {
            try db?.run(insertDay)
        } catch {
            print("\(error)")
        }
    }
    
    func addProgram(name: String) {
        let programs = Table("programs")
        let nameColumn = Expression<String>("name")
        
        do {
            let insertProgram = programs.insert(nameColumn <- name)
            try db?.run(insertProgram)
        } catch {
            print("\(error)")
        }
    }
    
    func addSet(setD: SetDetail) {
        let sets = Table("sets")
        let setWeight = Expression<Int64>("setWeight")
        let setReps = Expression<Int64>("setReps")
        let setExerciseId = Expression<Int64>("exercise_id")
        
        do {
            let insertSet = sets.insert(setWeight <- Int64(setD.setWeight), setReps <- setD.setReps, setExerciseId <- setD.setExerciseId)
            try db?.run(insertSet)
        } catch {
            print("\(error)")
        }
    }

    
    func addProgramIfTableEmpty(name: String) {
        let programs = Table("programs")
        let nameColumn = Expression<String>("name")

        let days = Table("days")
        let daysName = Expression<String>("dayName")
        let daysProgramID = Expression<Int64>("program_id")
        
        let exercises = Table("exercises")
        let exerciseName = Expression<String>("exerciseName")
        let exerciseDayID = Expression<Int64>("day_id")

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
                    let dayID = try db?.run(insertDay)
                    
                    if let dayID = dayID {
                        let insertExercise = exercises.insert(exerciseName <- "Squat", exerciseDayID <- dayID)
                        try db?.run(insertExercise)
                    }
                    
                    
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

class ExerciseRowViewModel: ObservableObject {
    @Published var sets: [SetDetail] = []
}

class ProgramListViewModel: ObservableObject {
    @Published var programs: [Program] = []
    @Published var days: [WorkoutDay] = []
    @Published var exercises: [Exercise] = []
}

struct Program {
    let id: Int64
    let name: String
    // Add other fields as necessary
}

struct WorkoutDay {
    let dayId: Int64
    let dayName: String
    let programName: String
}

struct Exercise {
    let exerciseId: Int64
    let exerciseName: String
    let dayName: String
}

struct SetDetail {
    let setId: Int64
    var setWeight: Double
    var setReps: Int64
    let setExerciseId: Int64
}
