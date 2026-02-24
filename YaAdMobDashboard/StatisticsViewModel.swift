//
//  StatisticsViewModel.swift
//  YaAdMobDashboard
//
//  Created by Pavel Grigorev on 24.02.2026.
//


import Foundation
import SwiftUI
import Combine

@MainActor
final class StatisticsViewModel: ObservableObject {
    
    @Published var apiKey: String = ""
    @Published var selectedType: RequestType = .yandex
    @Published var selectedPeriod: StatisticsPeriod = .days7
    @Published var result: Double?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkManager = NetworkManager(
        baseURL: URL(string: "https://partner.yandex.ru/api/")!
    )
    
    func fetch() async {
        guard !apiKey.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        result = nil
        
        do {
            let value = try await networkManager.fetchPartnerReward(
                apiKey: apiKey,
                period: selectedPeriod.rawValue
            )
            result = value
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
