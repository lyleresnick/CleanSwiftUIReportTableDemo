//  Copyright © 2017 Lyle Resnick. All rights reserved.

import Foundation

class EntityGatewayFactory {
    
    enum Implementation {
        case test
        case networked
    }

    static var gatewayImplementation = Implementation.test
    
    static var gateway: EntityGateway = {

        switch gatewayImplementation {
        case .test:
            return TestEntityGateway()
        case .networked:
            return NetworkedEntityGateway()
        }
    } ()
}
