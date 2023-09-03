//
//  ContentView.swift
//  CleanSwiftUIReportTableDemo
//
//  Created by Lyle Resnick on 2020-12-26.
//

import SwiftUI

struct TransactionListSceneView: View {
    @ObservedObject var proxy: TransactionListPresenterProxy
        
    init(proxy: TransactionListPresenterProxy) {
        self.proxy = proxy
        proxy.refreshTwoSource()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if case .initialize = proxy.output {
                    ProgressView()
                }
                else if case let .showReport(viewModel) = proxy.output {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(viewModel, id: \.self) { row in
                                switch row {
                                case .header:
                                    TransactionListHeaderCell(row: row)
                                case .subheader:
                                    TransactionListSubheaderCell(row: row)
                                case  .detail:
                                    TransactionListDetailCell(row: row)
                                case .message:
                                    TransactionListMessageCell(row: row)
                                case .footer:
                                    TransactionListFooterCell(row: row)
                                case .grandfooter:
                                    TransactionListGrandFooterCell(row: row)
                                case .subfooter:
                                    TransactionListSubfooterCell(row: row)
                                }
                            }
                        }
                    }
//                    .listRowSeparator(.hidden)
//                    .listStyle(PlainListStyle())
                }

            }.navigationTitle(Text("Transactions"))
        }

    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        EntityGatewayFactory.gatewayImplementation = EntityGatewayFactory.Implementation.test

        return TransactionListAssembly().scene
    }
}
