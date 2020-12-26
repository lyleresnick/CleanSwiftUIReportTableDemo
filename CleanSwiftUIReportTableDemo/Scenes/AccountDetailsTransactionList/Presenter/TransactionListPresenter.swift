//  Copyright © 2020 Lyle Resnick. All rights reserved.

import Foundation
import Combine
import EnumKit

class TransactionListPresenter : ObservableObject {
    
    let useCase: TransactionListUseCase

    fileprivate static let outboundDateFormatter = DateFormatter.dateFormatter( format: "MMM' 'dd', 'yyyy" )

    required init(useCase: TransactionListUseCase) {
        self.useCase = useCase
    }

    func transform(input: AnyPublisher<TransactionListPresenterInput, Never>) -> AnyPublisher<TransactionListPresenterOutput, Never> {

        let output = useCase.transform(input: input.compactMap(toUseCaseInput).eraseToAnyPublisher())
        
        func refresh() -> AnyPublisher<TransactionListPresenterOutput, Never> {
        
            func formatDate(date: Date) -> String { Self.outboundDateFormatter.string(from: date) }
            
            func toRefreshPresenterOutput(useCaseOutput: TransactionListRefreshUseCaseOutput) -> TransactionListRefreshPresenterOutput? {
                switch useCaseOutput {
                case .initialize:
                    return .initialize
                default:
                    return nil
                }
            }

            var odd = false
            var rows =  [TransactionListRowViewModel]()
            let rowsSubject = PassthroughSubject<[TransactionListRowViewModel], Never>()

            let general = output.capture(case: TransactionListUseCaseOutput.refresh)
               .handleEvents(receiveOutput: { row in
                    switch row {
                    case .initialize:
                        odd = false
                        rows = [TransactionListRowViewModel]()
                    case let .header(group):
                        rows.append(.header(title: group.toString() + " Transactions"));
                    case let .subheader(date):
                        odd = !odd;
                        rows.append(.subheader(title: formatDate(date: date), odd: odd))
                    case let .detail(description, amount):
                        rows.append(.detail(description: description, amount: amount.asString, odd: odd));
                    case .subfooter:
                        rows.append(.subfooter(odd: odd));
                    case let .footer(total):
                        odd = !odd;
                        rows.append(.footer(total: total.asString, odd: odd));
                    case let .grandFooter(grandTotal):
                        rows.append(.grandfooter(total: grandTotal.asString));
                    case let .notFoundMessage(group):
                        rows.append(.message(message: "\(group.toString()) Transactions are not currently available."))
                    case .notFoundMessageAll:
                        rows.append(.message(message: "Transactions are not currently available."))
                    case let .noTransactionsMessage(group):
                        rows.append(.message(message: "There are no \(group.toString()) Transactions in this period" ));
                    case let .failure(code, description):
                        rows.append(.message(message: "Error: \(code), Message: \(description)" ));
                    case .finalize:
                        rowsSubject.send(rows)
                    }
                })
                .compactMap(toRefreshPresenterOutput)
                
            let showReport = rowsSubject
                .map(TransactionListRefreshPresenterOutput.showReport)


            return general
                .merge(with: showReport)
                .map(TransactionListPresenterOutput.refresh)
                .eraseToAnyPublisher()
        }
        
        let refreshOutput = refresh()
        return refreshOutput
    }
    
    func toUseCaseInput(presenterInput: TransactionListPresenterInput) -> TransactionListUseCaseInput? {
        switch presenterInput {
        case .refreshTwoSource:
            return .refreshTwoSource
        case .refreshOneSource:
            return .refreshOneSource
        }
    }
}

// MARK: -

private extension Double {
    var asString: String {
        return String(format: "%0.2f", self)
    }
}
