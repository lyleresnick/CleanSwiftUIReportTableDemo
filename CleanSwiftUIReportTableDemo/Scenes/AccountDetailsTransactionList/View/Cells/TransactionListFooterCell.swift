//  Copyright © 2020 Lyle Resnick. All rights reserved.

import SwiftUI

struct TransactionListFooterCell: View, TransactionListCell {
    
    let row: TransactionListRowViewModel
    init(row: TransactionListRowViewModel) {
        self.row = row
    }
    
    var body: some View {
        if case let .footer(total, odd) = row  {
            HStack {
                Text("Total")
                Spacer()
                Text(total)
            }
                .font(.system(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 44)
                .padding(edgeInsets)
                .background(getBackgroundColour(odd: odd))
        }
        else {
            fatalError("Expected: footer")
        }
    }
}
