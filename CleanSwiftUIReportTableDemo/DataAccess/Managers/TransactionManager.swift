//  Copyright © 2020 Lyle Resnick. All rights reserved.

import Combine

enum  TransactionError: Error {
    case notFound
    case failure(code: Int, description: String)
}


protocol TransactionManager: class {
    
    func fetchAuthorizedTransactions() -> AnyPublisher<[Transaction], TransactionError>
    func fetchPostedTransactions() -> AnyPublisher<[Transaction], TransactionError>
    func fetchAllTransactions() -> AnyPublisher<[Transaction], TransactionError>
}

