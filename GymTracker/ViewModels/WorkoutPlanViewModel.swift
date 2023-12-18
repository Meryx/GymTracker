//
//  WorkoutPlanViewModel.swift
//  GymTracker
//
//  Created by Anwar Haredy on 05/06/1445 AH.
//

import Foundation

class WorkoutPlanViewModel: ObservableObject {
    @Published private var workoutPlans: [WorkoutPlanModel] = []
    @Published private var showPrompt: Bool = false
    
    init() {
        loadWorkoutDays()
    }
    
    var publicWorkoutPlans: [WorkoutPlanModel]
    {
        return workoutPlans
    }
    
    func removeWorkoutPlan(at: Int)
    {
        workoutPlans.remove(at: at)
    }
    
    func isPromptShown() -> Bool
    {
        return showPrompt
    }
    
    func hidePrompt()
    {
        showPrompt = false
    }
    
    func handleNewWorkoutPlanClick()
    {
        showPrompt = true
    }
    
    func addItem(name: String) {
        let newItem = WorkoutPlanModel(name: name, days: WorkoutSubDayViewModel())
        workoutPlans.append(newItem)
        saveWorkoutDays()
    }
    
    func saveWorkoutDays() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let archiveURL = documentsDirectory.appendingPathComponent("workout_plans.plist")
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml
            
            do {
                let data = try encoder.encode(workoutPlans)
                try data.write(to: archiveURL)
            } catch {
                print("Error saving workout days: \(error)")
            }
        }
    }
    
    private func loadWorkoutDays() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let archiveURL = documentsDirectory?.appendingPathComponent("workout_plans.plist")
        
        if let archiveURL = archiveURL,
           let data = try? Data(contentsOf: archiveURL),
           let decodedWorkoutDays = try? PropertyListDecoder().decode([WorkoutPlanModel].self, from: data) {
            workoutPlans = decodedWorkoutDays
        }
    }
}
