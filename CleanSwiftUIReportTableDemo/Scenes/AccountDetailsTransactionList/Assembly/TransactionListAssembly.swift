//  Copyright © 2020 Lyle Resnick. All rights reserved.

import SwiftUI

class TransactionListAssembly {
    
    let scene: TransactionListSceneView
        
    init(entityGateway: EntityGateway = EntityGatewayFactory.gateway) {
        
        let useCase = TransactionListUseCase(entityGateway: entityGateway)
        let presenter = TransactionListPresenter(useCase: useCase)
        let proxy = TransactionListPresenterProxy(presenter: presenter)
        scene = TransactionListSceneView(proxy: proxy)
    }
    
}
