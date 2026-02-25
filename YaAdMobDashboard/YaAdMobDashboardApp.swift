//
//  YaAdMobDashboardApp.swift
//  YaAdMobDashboard
//
//  Created by Pavel Grigorev on 24.02.2026.
//

import SwiftUI

@main
struct YaAdMobDashboardApp: App {
    var body: some Scene {
        WindowGroup {
            let networkManager = NetworkManager()
            let viewModel = StatisticsViewModel(networkManager: networkManager)
            StatisticsView(viewModel: viewModel)
        }
    }
}
