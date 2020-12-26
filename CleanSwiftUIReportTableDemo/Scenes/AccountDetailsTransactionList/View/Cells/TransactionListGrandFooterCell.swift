//  Copyright © 2020 Lyle Resnick. All rights reserved.

import SwiftUI

struct TransactionListGrandFooterCell: View, TransactionListCell {
    
    let row: TransactionListRowViewModel
    init(row: TransactionListRowViewModel) {
        self.row = row
    }
    
    var body: some View {
        if case let .grandfooter(total) = row  {
            HStack {
                Text("Grand Total")
                Spacer()
                Text(total)
            }
            .font(.system(size: 16))
            .foregroundColor(headerForegroundColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 60)
            .padding(edgeInsets)
            .background(headerBackgroundColor)

        }
        else {
            fatalError("Expected: grandfooter")
        }

    }
}
