//
//  StatisticsViewModel.swift
//  YaAdMobDashboard
//
//  Created by Pavel Grigorev on 24.02.2026.
//


import Foundation
import SwiftUI
import Combine

struct RequestConfig {
    var apiKey: String
    var type: RequestType
    var language: Language
    var currency: Currency
    var period: StatisticsPeriod

    static let initial = Self.init(
        apiKey: Config.apiKey,
        type: .yandex,
        language: .ru,
        currency: .rub,
        period: .today
    )
}

@MainActor
final class StatisticsViewModel: ObservableObject {

    @Published var requestConfig: RequestConfig = .initial

    @Published var result: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkManager: NetworkProtocol

    init(networkManager: NetworkProtocol) {
        self.networkManager = networkManager
    }

    func fetch() async {
        guard !requestConfig.apiKey.isEmpty else { return }

        isLoading = true
        errorMessage = nil
        result = nil
        
        do {
            let value = try await networkManager.fetchPartnerReward(
                apiKey: requestConfig.apiKey,
                type: requestConfig.type,
                lang: requestConfig.language,
                currency: requestConfig.currency,
                period: requestConfig.period
            )
            result = value
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
