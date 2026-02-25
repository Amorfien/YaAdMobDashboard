//
//  NetworkManager.swift
//  YaAdMobDashboard
//
//  Created by Pavel Grigorev on 24.02.2026.
//


import Foundation

final class NetworkManager {
    
    private let session: URLSession
    private let baseURL: URL?

    init(baseURL: URL? = RequestConstants.baseURL,
         session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func request<T: Decodable>(
        path: String,
        method: String,
        queryItems: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil,
        responseType: T.Type
    ) async throws -> T {

        guard let baseURL else { throw URLError(.badURL) }

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

extension NetworkManager: NetworkProtocol {

    func fetchPartnerReward(
        apiKey: String,
        type: RequestType,
        lang: Language,
        currency: Currency,
        period: StatisticsPeriod,
    ) async throws -> String? {

        var queryItems = [
            URLQueryItem(name: lang.queryName, value: lang.rawValue),
            URLQueryItem(name: type.queryName, value: type.rawValue),
            URLQueryItem(name: currency.queryName, value: currency.rawValue),
            URLQueryItem(name: period.queryName, value: period.rawValue)
        ]

        switch type {
        case .yandex:
            queryItems.append(URLQueryItem(name: RequestConstants.queryField,
                                           value: RequestConstants.partnerRevenue.key))
        case .mediation:
            queryItems.append(URLQueryItem(name: RequestConstants.queryField,
                                           value: RequestConstants.mediationSmartRevenue.key))
            queryItems.append(URLQueryItem(name: RequestConstants.queryField,
                                           value: RequestConstants.mediationTotalRevenue.key))
            queryItems.append(URLQueryItem(name: RequestConstants.queryField,
                                           value: RequestConstants.mediationExternalRevenue.key))
        }

        let headers = [
            RequestConstants.authHeaderKey: RequestConstants.apiKeyPrefix + apiKey
        ]

        let response: StatisticsResponse = try await request(
            path: RequestConstants.urlPath,
            method: RequestConstants.method,
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
            reward = """
\(firstMeasure.partnerWoNds, default: "??") \(currency.rawValue)
\(RequestConstants.partnerRevenue.desc)
"""
        case .mediation:
            reward = """
\(firstMeasure.revenueSmartMm, default: "??") \(currency.rawValue)
\(RequestConstants.mediationSmartRevenue.desc)
\(firstMeasure.revenueMm, default: "??") \(currency.rawValue)
\(RequestConstants.mediationTotalRevenue.desc)
\(firstMeasure.revenueExternalMm, default: "??") \(currency.rawValue)
\(RequestConstants.mediationExternalRevenue.desc)
"""
        }
        return reward
    }
}
