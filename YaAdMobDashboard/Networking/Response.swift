//
//  StatisticsResponse.swift
//  YaAdMobDashboard
//
//  Created by Pavel Grigorev on 24.02.2026.
//

import Foundation

struct StatisticsResponse: Decodable {
    let data: DataContainer

    struct DataContainer: Decodable {
        let points: [Point]

        struct Point: Decodable {
            let measures: [Measure]

            struct Measure: Decodable {
                let partnerWoNds: Double?
                let revenueSmartMm: Double?
                let revenueMm: Double?
                let revenueExternalMm: Double?

                enum CodingKeys: String, CodingKey {
                    case partnerWoNds = "partner_wo_nds"
                    case revenueSmartMm = "revenue_smart_mm"
                    case revenueMm = "revenue_mm"
                    case revenueExternalMm = "revenue_external_mm"
                }
            }
        }
    }
}
