//
//  NetworkManager.swift
//  YaAdMobDashboard
//
//  Created by Pavel Grigorev on 24.02.2026.
//


import Foundation

final class NetworkManager {
    
    private let session: URLSession
    private let baseURL: URL
    
    init(baseURL: URL,
         session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func request<T: Decodable>(
        path: String,
        method: String = "GET",
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil,
        responseType: T.Type
    ) async throws -> T {
        
        var components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )
        components?.queryItems = queryItems.isEmpty ? nil : queryItems
        
        guard let url = components?.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension NetworkManager {

    func fetchPartnerReward(
        apiKey: String,
        type: RequestType = .yandex,
        lang: Language = .ru,
        currency: Currency = .rub,
        period: StatisticsPeriod = .today,
    ) async throws -> String? {

        var queryItems = [
            URLQueryItem(name: "lang", value: lang.rawValue),
            URLQueryItem(name: "stat_type", value: type.rawValue),
            URLQueryItem(name: "currency", value: currency.rawValue),
            URLQueryItem(name: "period", value: period.rawValue)
        ]

        switch type {
        case .yandex:
            queryItems.append(URLQueryItem(name: "field", value: "partner_wo_nds"))
        case .mediation:
            queryItems.append(URLQueryItem(name: "field", value: "revenue_mm"))
            queryItems.append(URLQueryItem(name: "field", value: "revenue_external_mm"))
        }

        let headers = [
            "Authorization": "OAuth \(apiKey)"
        ]

        let response: StatisticsResponse = try await request(
            path: "statistics2/get.json",
            queryItems: queryItems,
            headers: headers,
            responseType: StatisticsResponse.self
        )

        guard
            let firstPoint = response.data.points.first,
            let firstMeasure = firstPoint.measures.first
        else {
            throw NSError(domain: "ParsingError", code: -1)
        }

        var reward: String
        switch type {
        case .yandex:
            reward = "\(firstMeasure.partnerWoNds, default: "??")"
        case .mediation:
            reward = "\(firstMeasure.revenueMm, default: "??") (\(firstMeasure.revenueExternalMm, default: "??"))"
        }
        return reward + " " + currency.rawValue.lowercased()
    }
}
