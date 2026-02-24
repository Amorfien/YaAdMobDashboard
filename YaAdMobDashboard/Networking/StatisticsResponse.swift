//
//  StatisticsResponse.swift
//  YaAdMobDashboard
//
//  Created by Pavel Grigorev on 24.02.2026.
//

import SwiftUI

struct StatisticsResponse: Decodable {
    let data: DataContainer

    struct DataContainer: Decodable {
        let points: [Point]

        struct Point: Decodable {
            let measures: [Measure]

            struct Measure: Decodable {
                let partnerWoNds: Double?
                let revenueMm: Double?
                let revenueExternalMm: Double?

                enum CodingKeys: String, CodingKey {
                    case partnerWoNds = "partner_wo_nds"
                    case revenueMm = "revenue_mm"
                    case revenueExternalMm = "revenue_external_mm"
                }
            }
        }
    }
}

enum StatisticsPeriod: String, CaseIterable, Identifiable {
    case today
    case yesterday
    case days7 = "7days"
    case days14 = "14days"
    case days30 = "30days"
    case days90 = "90days"

    var id: String { rawValue }

    var queryName: String {
        "period"
    }

    var title: String {
        switch self {
        case .today: return "Сегодня"
        case .yesterday: return "Вчера"
        case .days7: return "7 дней"
        case .days14: return "14 дней"
        case .days30: return "30 дней"
        case .days90: return "90 дней"
        }
    }
}

enum Currency: String, CaseIterable, Identifiable {
    case rub = "RUB"
    case usd = "USD"

    var id: String { rawValue }

    var queryName: String {
        "currency"
    }
}

enum Language: String {
    case ru = "ru"
    case en = "en"

    var queryName: String {
        "lang"
    }
}

enum RequestType: String, CaseIterable, Identifiable {
    case yandex = "main"
    case mediation = "mm"

    var id: String { rawValue }

    var queryName: String {
        "stat_type"
    }

    var title: String {
        switch self {
        case .yandex:
            "РСЯ"
        case .mediation:
            "Медиация"
        }
    }

    var image: ImageResource {
        switch self {
        case .yandex: return .yandexAd
        case .mediation: return .easyMon
        }
    }
}
