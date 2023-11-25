//
//  GymTrackerApp.swift
//  GymTracker
//
//  Created by Anwar Haredy on 11/05/1445 AH.
//

import SwiftUI

@main
struct GymTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
