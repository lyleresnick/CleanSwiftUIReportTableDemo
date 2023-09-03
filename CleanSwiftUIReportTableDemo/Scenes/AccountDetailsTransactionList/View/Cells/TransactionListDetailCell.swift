//  Copyright © 2020 Lyle Resnick. All rights reserved.

import SwiftUI

struct TransactionListDetailCell: View, TransactionListCell {
    
    let row: TransactionListRowViewModel
    init(row: TransactionListRowViewModel) {
        self.row = row
    }
    
    var body: some View {
        if case let .detail( description, amount, odd ) = row  {
            HStack  {
                Text(description)
                Spacer()
                Text(amount)
            }
                .font(.system(size: 13))
                .frame(maxWidth: .infinity)
                .frame(height: 18)
                .padding(edgeInsets)
                .background(getBackgroundColour(odd: odd))
        }
        else {
            fatalError("Expected: detail")
        }
    }
}

struct TransactionListDetailCell_preview: PreviewProvider {
    static var previews: some View {
        TransactionListDetailCell(row: .detail(description: "Thing i bought", amount: "100.00", odd: false))
    }
}

