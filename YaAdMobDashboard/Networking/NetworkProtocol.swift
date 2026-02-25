//
//  NetworkProtocol.swift
//  YaAdMobDashboard
//
//  Created by Pavel Grigorev on 25.02.2026.
//

protocol NetworkProtocol {
    func fetchPartnerReward(
        apiKey: String,
        type: RequestType,
        lang: Language,
        currency: Currency,
        period: StatisticsPeriod,
    ) async throws -> String?
}
