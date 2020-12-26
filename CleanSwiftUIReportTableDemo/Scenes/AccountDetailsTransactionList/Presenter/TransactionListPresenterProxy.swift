//
//  TransactionListViewProxy.swift
//  CleanCombineReportTableDemo
//
//  Created by Lyle Resnick on 2020-12-27.
//  Copyright © 2020 Lyle Resnick. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import CombineExt

class TransactionListPresenterProxy: ObservableObject {
    private let input = PassthroughSubject<TransactionListPresenterInput, Never>()
    private var cancellables = [Cancellable]()
    
    @Published var output: TransactionListRefreshPresenterOutput = .initialize
    
    init(presenter: TransactionListPresenter) {
        
        cancellables.append(
            presenter.transform(input: input.eraseToAnyPublisher())
                .capture(case: TransactionListPresenterOutput.refresh)
                .receive(on: RunLoop.main)
                .sink { [weak self] event in
                    guard let self = self else { return }
                    self.output = event
                }
        )
    }
    
    func refreshTwoSource() {
        input.send(.refreshTwoSource)
    }
    
    func refreshOneSource() {
        input.send(.refreshOneSource)
    }

    
}
