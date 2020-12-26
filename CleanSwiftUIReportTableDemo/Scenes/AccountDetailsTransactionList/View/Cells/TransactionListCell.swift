//  Copyright © 2017 Lyle Resnick. All rights reserved.

import SwiftUI

protocol TransactionListCell {
}

extension TransactionListCell where Self: View {
    
    func getBackgroundColour(odd: Bool ) -> Color { Color(UIColor( rgb: odd ? 0xF7F8FC : 0xDDDDDD )) }
        
//    var headerBackgroundColor: Color { Color(red: 31, green: 112, blue: 229) }
    var headerBackgroundColor: Color { Color.blue }

    var edgeInsets: EdgeInsets { EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25) }
    var headerForegroundColor: Color { Color(red: 239, green: 239, blue: 244) }
}

