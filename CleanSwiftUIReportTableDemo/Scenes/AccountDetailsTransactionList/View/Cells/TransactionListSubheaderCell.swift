//  Copyright © 2020 Lyle Resnick. All rights reserved.

import SwiftUI

struct TransactionListSubheaderCell: View, TransactionListCell {
    
    let row: TransactionListRowViewModel
    init(row: TransactionListRowViewModel) {
        self.row = row
    }
    
    var body: some View {
        if case let .subheader(title, odd) = row  {
            Text(title)
                .font(.system(size: 11))
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 34, alignment: .bottom)
                .padding(edgeInsets)
                .background(getBackgroundColour(odd: odd))
        }
        else {
            fatalError("Expected: subheader")
        }
    }
}
