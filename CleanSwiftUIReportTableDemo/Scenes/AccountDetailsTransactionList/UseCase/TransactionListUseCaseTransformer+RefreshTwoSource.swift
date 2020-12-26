//  Copyright © 2020 Lyle Resnick. All rights reserved.

import Foundation
import Combine
import CombineExt
import EnumKit

extension TransactionListUseCaseTransformer {

    func refreshTwoSourceTransform(input: AnyPublisher<TransactionListUseCaseInput, Never>) -> AnyPublisher<TransactionListUseCaseOutput, Never> {
        
        func transform(transactions: AnyPublisher<[Transaction], TransactionError>, group: TransactionGroup, totals: ReplaySubject<Double, Never>) -> AnyPublisher<TransactionListRefreshUseCaseOutput, Never> {
            return transactions
                .map { transactions -> [TransactionListRefreshUseCaseOutput] in
                    guard transactions.count > 0 else { return [.noTransactionsMessage(group: group)] }

                    var (list, total ) =  transactions
                        .reduce(into: [:]) { $0[$1.date, default: []].append($1) }
                        .map { ($0.key, $0.value) }
                        .sorted { $0.0 < $1.0 }
                        .reduce(into:(list: [], total: 0), transformGroupToUseCaseOutput)
                    
                    totals.send(total)
                    list += [.footer(total: total)]
                    return list
                }
                .flatMap { $0.publisher }
                .prepend([.header(group: group)])
                .catch { error -> Just<TransactionListRefreshUseCaseOutput> in
                    switch error {
                    case .notFound:
                        return Just(.notFoundMessage(group: group))
                    case let .failure(code, description):
                        return Just(.failure(code: code, description: description))
                    }
                }
                .eraseToAnyPublisher()
        }

        func transformGroupToUseCaseOutput(
                            _ accumulator: inout (list: [TransactionListRefreshUseCaseOutput], total: Double),
                            _ group: (key: Date, value: [Transaction]) ) {
               
            accumulator.list += [.subheader(date: group.key)]
            accumulator.list += group.value.map { .detail(description: $0.description, amount: $0.amount) }
            accumulator.list += [.subfooter]
            
            accumulator.total += group.value.reduce(0) { $0 + $1.amount }
        }
        
        return input.filter(case: TransactionListUseCaseInput.refreshTwoSource)
            .flatMap { _ -> AnyPublisher<TransactionListRefreshUseCaseOutput, Never> in
                let totals = ReplaySubject<Double, Never>(bufferSize: 2)
                
                let grandTotal = totals
                    .reduce(0, +)
                    .map(TransactionListRefreshUseCaseOutput.grandFooter)
                
                let transactions = transform(transactions: transactionManager.fetchAuthorizedTransactions(), group: .authorized, totals: totals)
                        .append(transform(transactions: transactionManager.fetchPostedTransactions(), group: .posted, totals: totals))
                    .handleEvents( receiveCompletion: { _ in totals.send(completion: .finished) })
                
                return Just(TransactionListRefreshUseCaseOutput.initialize)
                    .append(transactions)
                    .append(grandTotal)
                    .append(Just(TransactionListRefreshUseCaseOutput.finalize))
                    .eraseToAnyPublisher()
            }
            .map(TransactionListUseCaseOutput.refresh)
            .eraseToAnyPublisher()
    }
}
