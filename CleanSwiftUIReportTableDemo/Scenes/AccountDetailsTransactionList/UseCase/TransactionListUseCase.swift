//  Copyright © 2020 Lyle Resnick. All rights reserved.

import Foundation
import Combine
import EnumKit

class TransactionListUseCase {
    var entityGateway: EntityGateway
    
    required init(entityGateway: EntityGateway) {
        self.entityGateway = entityGateway
    }
    
    func transform(input: AnyPublisher<TransactionListUseCaseInput, Never>) -> AnyPublisher<TransactionListUseCaseOutput, Never> {
        
        let transformer = TransactionListUseCaseTransformer(transactionManager: entityGateway.transactionManager)

        return transformer.refreshTwoSourceTransform(input: input)
            .merge(with: transformer.refreshOneSourceTransform(input: input))
            .eraseToAnyPublisher()
    }
}

struct TransactionListUseCaseTransformer {
    let transactionManager: TransactionManager

    init(transactionManager: TransactionManager) {
        self.transactionManager = transactionManager
    }
}
