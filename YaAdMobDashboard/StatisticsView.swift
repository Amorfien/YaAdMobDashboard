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
        VStack(spacing: 20) {

            Picker("Type", selection: $viewModel.selectedType) {
                ForEach(RequestType.allCases) { type in
                    Text(type.title).tag(type)
                }
            }
            .pickerStyle(.segmented)

            TextField("Enter API Key", text: $viewModel.apiKey)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
            
            Picker("Period", selection: $viewModel.selectedPeriod) {
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
            .disabled(viewModel.apiKey.isEmpty || viewModel.isLoading)
            
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
        }
        .padding()
    }
}

#Preview {
    StatisticsView()
}
