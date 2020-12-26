//  Copyright © 2020 Lyle Resnick. All rights reserved.

import SwiftUI

struct TransactionListHeaderCell: View, TransactionListCell {
    
    let row: TransactionListRowViewModel
    init(row: TransactionListRowViewModel) {
        self.row = row
    }
    
    var body: some View {
        if case let .header(title) = row  {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(headerForegroundColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 60)
                .padding(edgeInsets)
                .background(headerBackgroundColor)
        }
        else {
            fatalError("Expected: header")
        }

    }
}
