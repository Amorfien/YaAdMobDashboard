//
//  StatisticsView.swift
//  YaAdMobDashboard
//
//  Created by Pavel Grigorev on 24.02.2026.
//


import SwiftUI

struct StatisticsView: View {
    
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        VStack(spacing: 32) {

            Image(viewModel.requestConfig.type.image)
                .resizable()
                .scaledToFit()
                .frame(height: 26)

            Picker("Type", selection: $viewModel.requestConfig.type) {
                ForEach(RequestType.allCases) { type in
                    Text(type.title).tag(type)
                }
            }
            .pickerStyle(.segmented)

            SecureField("Enter API Key", text: $viewModel.requestConfig.apiKey)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .font(.system(size: 10))

            Picker("Period", selection: $viewModel.requestConfig.period) {
                ForEach(StatisticsPeriod.allCases) { period in
                    Text(period.title).tag(period)
                }
            }
            .pickerStyle(.segmented)
            .controlSize(.large)

            Button {
                Task {
                    await viewModel.fetch()
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Fetch")
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.requestConfig.apiKey.isEmpty || viewModel.isLoading)

            Divider()
            
            if let result = viewModel.result {
                Text("Reward: \(result)")
                    .font(.title2)
                    .bold()
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            Spacer()

            HStack {
                Spacer()
                Picker("Currency", selection: $viewModel.requestConfig.currency) {
                    ForEach(Currency.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 128)
            }
        }
        .padding()
    }
}

#Preview {
    StatisticsView()
}
