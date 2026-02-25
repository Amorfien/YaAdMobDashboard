//
//  Request.swift
//  YaAdMobDashboard
//
//  Created by Pavel Grigorev on 25.02.2026.
//

import SwiftUI

enum RequestConstants {
    static let baseURL = URL(string: "https://partner.yandex.ru/api/")
    static let urlPath = "statistics2/get.json"
    static let authHeaderKey = "Authorization"
    static let apiKeyPrefix = "OAuth "
    static let apyKey = Config.apiKey
    static let method = "GET"
    static let queryField = "field"

    static let partnerRevenue = (key: "partner_wo_nds", desc: "Вознаграждение партнера за рекламу")
    static let mediationSmartRevenue = (key: "revenue_smart_mm", desc: "Доход от показанной рекламы")
    static let mediationTotalRevenue = (key: "revenue_mm", desc: "Включает фактический доход от РСЯ и расчетный доход от других монетизаторов, который рассчитывается на основании выставленных порогов CPM на слотах.")
    static let mediationExternalRevenue = (key: "revenue_external_mm", desc: "Доход от показанной рекламы (значение может быть равно нулю, если рекламная сеть не настроена)")
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
