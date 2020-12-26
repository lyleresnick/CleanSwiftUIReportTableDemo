//  Copyright © 2020 Lyle Resnick. All rights reserved.

import Foundation
import Combine

class NetworkedTransactionManager: TransactionManager {
        
    private let defaultSession = URLSession(configuration: .default)
    private let baseURLString = "https://report-demo-backend.herokuapp.com/api"

    private let formatter = DateFormatter.dateFormatter( format: "yyyy-MM-dd'T'HH:mm:ss'Z'")
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()
    
    func fetchAuthorizedTransactions() -> AnyPublisher<[Transaction], TransactionError> {
        return fetch(path: "transactions/authorized")
    }

    func fetchPostedTransactions() -> AnyPublisher<[Transaction], TransactionError> {
        return fetch(path: "transactions/posted")
    }

    func fetchAllTransactions() -> AnyPublisher<[Transaction], TransactionError> {
        return fetch(path: "transactions/all")
    }
        
    private func fetch(path: String) -> AnyPublisher<[Transaction], TransactionError> {
        
        let url = URL(string: baseURLString + "/" + path)!
        
        return defaultSession.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard
                    let httpResponse = element.response as? HTTPURLResponse
                else {
                    throw TransactionError.failure(code: 0, description: "Bad HTTPURLResponse")
                }
                if httpResponse.statusCode != 200 {
                    if httpResponse.statusCode == 404 {
                        throw TransactionError.notFound
                    }
                    else {
                        throw TransactionError.failure(code: httpResponse.statusCode, description: httpResponse.description)
                    }
                }
                return element.data
            }
            .decode(type: [NetworkedTransaction].self, decoder: decoder)
            .map { $0.compactMap(Transaction.init(networkedTransaction:)) }
            .mapError { .failure(code: 0, description: $0.localizedDescription) }
            .eraseToAnyPublisher()
    }
}
