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
        
        
        
        
        
        let databaseFilePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)/db.sqlite3"
        
//                let fileManager = FileManager.default
//        
//                        if fileManager.fileExists(atPath: databaseFilePath) {
//                            do {
//                                try fileManager.removeItem(atPath: databaseFilePath)
//                                print("Existing database deleted.")
//                            } catch {
//                                print("Error deleting database: \(error)")
//                            }
//                        }
        
        
        do {
            db = try Connection(databaseFilePath)
            try db?.execute("PRAGMA foreign_keys = ON;")
            createTables()
        } catch {
            print("Unable to establish connection to the database: \(error)")
        }
    }
    
    func printSchema() {
        do {
            let statement = try db?.prepare("SELECT name, sql FROM sqlite_master WHERE type='table'")
            for row in statement! {
                if let tableName = row[0] as? String, let createStatement = row[1] as? String {
                    print("Table: \(tableName)")
                    print("Create Statement: \(createStatement)\n")
                }
            }
        } catch {
            print("Error printing schema: \(error)")
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
        let setWeight = Expression<Double>("setWeight")
        let setReps = Expression<Int64>("setReps")
        let prevWeight = Expression<Double>("prevWeight")
        let prevReps = Expression<Int64>("prevReps")
        let setExerciseID = Expression<Int64>("exercise_id")
        let setNum = Expression<Int64>("setNum")
        
        // Define the ExerciseHistory table
        let exerciseHistory = Table("ExerciseHistory")
        let historyId = Expression<Int64>("historyId")
        let dayName = Expression<String>("dayName")
        let date = Expression<Date>("date")
        
        // Define the SetHistory table
        let setHistory = Table("SetHistory")
        let setHistoryId = Expression<Int64>("setHistoryId")
        let setExerciseHistoryId = Expression<Int64>("setExerciseHistoryId")
        let name = Expression<String>("name")
        let count = Expression<Int64>("count")
        
        do {
            try db?.run(programs.create { t in
                t.column(programsID, primaryKey: .autoincrement)
                t.column(programsName)
            })
            
            try db?.run(days.create { t in
                t.column(daysID, primaryKey: .autoincrement)
                t.column(daysName)
                t.column(daysProgramID)
                t.foreignKey(daysProgramID, references: programs, programsID, delete: .cascade)
            })
            
            try db?.run(exercises.create { t in
                t.column(exerciseID, primaryKey: .autoincrement)
                t.column(exerciseName)
                t.column(exerciseDayID)
                t.foreignKey(exerciseDayID, references: days, daysID, delete: .cascade)
            })
            
            try db?.run(sets.create { t in
                t.column(setID, primaryKey: .autoincrement)
                t.column(setWeight)
                t.column(setReps)
                t.column(prevWeight)
                t.column(prevReps)
                t.column(setExerciseID)
                t.column(setNum)
                t.foreignKey(setExerciseID, references: exercises, exerciseID, delete: .cascade)
            })
            
            try db?.run(exerciseHistory.create { t in
                t.column(historyId, primaryKey: .autoincrement)
                t.column(dayName)
                t.column(date)
            })
            
            // Create the SetHistory table
            try db?.run(setHistory.create { t in
                t.column(setHistoryId, primaryKey: .autoincrement)
                t.column(setExerciseHistoryId)
                t.column(name)
                t.column(count)
                t.foreignKey(setExerciseHistoryId, references: exerciseHistory, historyId)
            })
        } catch {
            print("Unable to create tables: \(error)")
        }
    }
    
    func fetchAllSetHistories(historyId: Int64) -> [SetHistory] {
        let setHistoryTable = Table("SetHistory")

        let setHistoryId = Expression<Int64>("setHistoryId")
        let setExerciseHistoryId = Expression<Int64>("setExerciseHistoryId")
        let name = Expression<String>("name")
        let count = Expression<Int64>("count")

        var setHistories: [SetHistory] = []

        do {
            let query = setHistoryTable.filter(setExerciseHistoryId == historyId)
            for setHistory in try db!.prepare(query) {
                let id = setHistory[setHistoryId]
                let exerciseHistoryId = setHistory[setExerciseHistoryId]
                let setName = setHistory[name]
                let setCount = setHistory[count]

                let setHistoryInstance = SetHistory(setHistoryId: id,
                                                    setExerciseHistoryId: exerciseHistoryId,
                                                    name: setName,
                                                    count: setCount)
                setHistories.append(setHistoryInstance)
            }
        } catch {
            print("Fetch error: \(error)")
        }

        return setHistories
    }

    
    func addExerciseHistory(_ exerciseHistory: ExerciseHistory) throws -> Int64 {
        let exerciseHistoryTable = Table("ExerciseHistory")
        let historyId = Expression<Int64>("historyId")
        let dayName = Expression<String>("dayName")
        let date = Expression<Date>("date")
        let insert = exerciseHistoryTable.insert(
            dayName <- exerciseHistory.dayName,
            date <- exerciseHistory.date
        )
        if let res = try db?.run(insert)
        {
            return res
        } else {
            return 0
        }
        
    }

    func addSetHistory(_ setHistory: SetHistory) throws {
        
        
        let setHistoryId = Expression<Int64>("setHistoryId")
        let setExerciseHistoryId = Expression<Int64>("setExerciseHistoryId")
        let setName = Expression<String>("name")
        let setCount = Expression<Int64>("count")
        let setHistoryTable = Table("SetHistory")
        let insert = setHistoryTable.insert(
            setExerciseHistoryId <- setHistory.setExerciseHistoryId,
            setName <- setHistory.name,
            setCount <- setHistory.count
        )
        try db?.run(insert)
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
    
    func fetchAllExercises() -> [Exercise] {
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
    
    func fetchSetByExerciseId(id: Int64) -> [SetDetail] {
        let setsTable = Table("sets")
        
        let setID = Expression<Int64>("setID")
        let setWeight = Expression<Double>("setWeight")
        let prevWeight = Expression<Double>("prevWeight")
        let prevReps = Expression<Int64>("prevReps")
        let setReps = Expression<Int64>("setReps")
        let setExerciseID = Expression<Int64>("exercise_id")
        let setNum = Expression<Int64>("setNum")
        
        var setDetails: [SetDetail] = []

        do {
            let query = setsTable
                .filter(setExerciseID == id)
                .select(setID, setWeight, setReps, setExerciseID, prevWeight, prevReps, setNum)

            for set in try db!.prepare(query) {
                let setId = set[setID]
                let weight = set[setWeight]
                let pWeight = set[prevWeight]
                let pReps = set[prevReps]
                let reps = set[setReps]
                let exerciseId = set[setExerciseID]
                let setN = set[setNum]

                setDetails.append(SetDetail(setId: setId, setWeight: weight, setReps: reps, prevWeight: pWeight, prevReps: pReps, setExerciseId: exerciseId, setNum: Int(setN)))
            }
        } catch {
            print("\(error)")
        }

        return setDetails
    }

    
    func fetchSetByDayId(id: Int64) -> [SetDetail] {
        let daysTable = Table("days")
        let exercisesTable = Table("exercises")
        let setsTable = Table("sets")
        
        let dayID = Expression<Int64>("dayId")
        
        let exerciseID = Expression<Int64>("exerciseId")
        let exerciseDayID = Expression<Int64>("day_id")
        
        let setID = Expression<Int64>("setID")
        let setWeight = Expression<Double>("setWeight")
        let prevWeight = Expression<Double>("prevWeight")
        let prevReps = Expression<Int64>("prevReps")
        let setReps = Expression<Int64>("setReps")
        let setExerciseID = Expression<Int64>("exercise_id")
        let setNum = Expression<Int64>("setNum")
        
        var setDetails: [SetDetail] = []
        
        do {
            let query = setsTable
                .join(exercisesTable, on: setExerciseID == exercisesTable[exerciseID])
                .join(daysTable, on: exerciseDayID == daysTable[dayID])
                .filter(dayID == id)
                .select(setsTable[setID], setsTable[setWeight], setsTable[setReps], setsTable[setExerciseID], setsTable[prevWeight], setsTable[prevReps], setsTable[setNum])
            
            for set in try db!.prepare(query) {
                let setId = set[setID]
                let weight = set[setWeight]
                let pWeight = set[prevWeight]
                let pReps = set[prevReps]
                let reps = set[setReps]
                let exerciseId = set[setExerciseID]
                let setN = set[setNum]
                
                setDetails.append(SetDetail(setId: setId, setWeight: weight, setReps: reps, prevWeight: pWeight, prevReps: pReps, setExerciseId: exerciseId, setNum: Int(setN)))
            }
        } catch {
            print("\(error)")
        }
        return setDetails
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
            printSchema()
            print("Unable to fetch workout days: \(error)")
        }
        
        
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
    
    func deleteExercise(id: Int64) {
        let programs = Table("exercises")
        let idColumn = Expression<Int64>("exerciseID")
        
        do {
            let programToDelete = programs.filter(idColumn == id)
            let deleteProgram = programToDelete.delete()
            try db?.run(deleteProgram)
        } catch {
            print("Delete error: \(error)")
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
    
    func deleteDay(id: Int64) {
        let programs = Table("days")
        let idColumn = Expression<Int64>("dayId")
        
        do {
            let programToDelete = programs.filter(idColumn == id)
            let deleteProgram = programToDelete.delete()
            try db?.run(deleteProgram)
        } catch {
            print("Delete error: \(error)")
        }
    }
    
    func deleteProgram(id: Int64) {
        let programs = Table("programs")
        let idColumn = Expression<Int64>("id")
        
        do {
            let programToDelete = programs.filter(idColumn == id)
            let deleteProgram = programToDelete.delete()
            try db?.run(deleteProgram)
        } catch {
            print("Delete error: \(error)")
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
    
    func modifySet(setD: SetDetail) {
        let sets = Table("sets")
        let id = Expression<Int64>("setID") // Assuming 'id' is the primary key
        let prevWeight = Expression<Double>("prevWeight")
        let prevReps = Expression<Int64>("prevReps")
        let setWeight = Expression<Double>("setWeight")
        let setReps = Expression<Int64>("setReps")
        let setExerciseId = Expression<Int64>("exercise_id")
        
        do {
            let setToUpdate = sets.filter(id == setD.setId)
            let updateSet = setToUpdate.update(
                prevWeight <- setD.setWeight,
                prevReps <- setD.setReps,
                setExerciseId <- setD.setExerciseId,
                setWeight <- 0.0, // Set to a new value if needed
                setReps <- 0 // Set to a new value if needed
            )
            try db?.run(updateSet)
        } catch {
            print("Update error: \(error)")
        }
    }
    
    
    func addSet(setD: SetDetail) {
        let sets = Table("sets")
        let prevWeight = Expression<Double>("prevWeight")
        let prevReps = Expression<Int64>("prevReps")
        let setWeight = Expression<Double>("setWeight")
        let setReps = Expression<Int64>("setReps")
        let setExerciseId = Expression<Int64>("exercise_id")
        let setNum = Expression<Int64>("setNum")
        
        do {
            let insertSet = sets.insert(prevWeight <- setD.setWeight, prevReps <- setD.setReps, setExerciseId <- setD.setExerciseId, setWeight <- 0.0, setReps <- 0, setNum <- Int64(setD.setNum))
            try db?.run(insertSet)
        } catch {
            print("\(error)")
        }
    }
    
    func fetchAllExerciseHistory() -> [ExerciseHistory] {
        let exerciseHistoryTable = Table("ExerciseHistory")

        let historyId = Expression<Int64>("historyId")
        let dayName = Expression<String>("dayName")
        let date = Expression<Date>("date")

        var exerciseHistories: [ExerciseHistory] = []

        do {
            for exercise in try db!.prepare(exerciseHistoryTable) {
                let id = exercise[historyId]
                let name = exercise[dayName]
                let dateValue = exercise[date]

                let exerciseHistory = ExerciseHistory(historyId: id, dayName: name, date: dateValue)
                exerciseHistories.append(exerciseHistory)
            }
        } catch {
            print("Fetch error: \(error)")
        }

        return exerciseHistories
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



class ProgramListViewModel: ObservableObject, Identifiable {
    @Published var programs: [Program] = []
    @Published var days: [WorkoutDay] = []
    @Published var exercises: [Exercise] = []
    @Published var sets: [SetDetail] = []
    @Published var history: [ExerciseHistory] = []
    @Published var setHistory: [[SetHistory]] = []
    
    func updateSets(databaseManager: DatabaseManager, dayID: Int64) {
        // Your logic to update sets
        self.sets = databaseManager.fetchSetByDayId(id: dayID)
    }
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

struct ExerciseHistory {
    let historyId: Int64
    let dayName: String
    var date = Date()
}

struct SetHistory {
    let setHistoryId: Int64
    let setExerciseHistoryId: Int64
    let name: String
    let count: Int64
}

struct SetDetail {
    let setId: Int64
    var setWeight: Double
    var setReps: Int64
    var prevWeight: Double
    var prevReps: Int64
    let setExerciseId: Int64
    var setNum: Int = 1
}
