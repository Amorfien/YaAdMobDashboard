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
    
    @Published var apiKey: String = "y0__xD26rQ_GOeMLSD-3-PEFt6FvUrpBm0jipp19TkdXvpEiGDl"
    @Published var selectedType: RequestType = .yandex
    @Published var selectedPeriod: StatisticsPeriod = .today
    @Published var result: String?
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
                type: selectedType,
                period: selectedPeriod
            )
            result = value
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
