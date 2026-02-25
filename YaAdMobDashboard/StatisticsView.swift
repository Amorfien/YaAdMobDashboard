//
//  StatisticsView.swift
//  YaAdMobDashboard
//
//  Created by Pavel Grigorev on 24.02.2026.
//


import SwiftUI

struct StatisticsView: View {
    
    @ObservedObject private var viewModel: StatisticsViewModel
    @FocusState private var isFocused: Bool

    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            ScrollView {
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
                        .font(.system(size: 9))
                        .focused($isFocused)
                        .onSubmit {
                            isFocused = false
                        }

                    Picker("Period", selection: $viewModel.requestConfig.period) {
                        ForEach(StatisticsPeriod.allCases) { period in
                            Text(period.title).tag(period)
                        }
                    }
                    .pickerStyle(.segmented)
                    .controlSize(.large)

                    Button {
                        isFocused = false
                        Task {
                            await viewModel.fetch()
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 40)
                        } else {
                            Text("Запрос")
                                .font(.title3)
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity, minHeight: 40)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.requestConfig.apiKey.isEmpty || viewModel.isLoading)

                    Divider()

                    if let result = viewModel.result {
                        Text(result)
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }
                }
                .padding(20)
            }

            VStack {
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
                .padding(.horizontal)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = false
        }
    }
}

#Preview {
    StatisticsView(viewModel: StatisticsViewModel(networkManager: NetworkManager()))
}
