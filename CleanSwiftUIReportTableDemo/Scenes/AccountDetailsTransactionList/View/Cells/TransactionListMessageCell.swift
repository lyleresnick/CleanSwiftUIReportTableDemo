//  Copyright © 2020 Lyle Resnick. All rights reserved.

import SwiftUI

struct TransactionListMessageCell: View, TransactionListCell {
    
    let row: TransactionListRowViewModel
    init(row: TransactionListRowViewModel) {
        self.row = row
    }
    
    var body: some View {
        if case let  .message( message ) = row  {
            Text(message)
                .font(.system(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 100)
                .padding(edgeInsets)
                .background(getBackgroundColour(odd: true)) 
        }
        else {
            fatalError("Expected: message")
        }
    }
}

struct TransactionListMessageCell_preview: PreviewProvider {
    static var previews: some View {
        TransactionListMessageCell(row: .message(message: "This is a message"))
    }
}

