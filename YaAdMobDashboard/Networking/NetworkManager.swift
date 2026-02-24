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
        lang: String = "ru",
        currency: String = "USD",
        period: String = "7days",
        field: String = "partner_wo_nds"
    ) async throws -> Double {

        let queryItems = [
            URLQueryItem(name: "lang", value: lang),
            URLQueryItem(name: "currency", value: currency),
            URLQueryItem(name: "period", value: period),
            URLQueryItem(name: "field", value: field)
        ]

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

        return firstMeasure.partnerWoNds
    }
}
