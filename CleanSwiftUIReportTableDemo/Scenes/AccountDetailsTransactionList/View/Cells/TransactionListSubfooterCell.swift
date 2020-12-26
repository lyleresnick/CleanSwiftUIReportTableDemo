//  Copyright © 2020 Lyle Resnick. All rights reserved.

import SwiftUI

struct TransactionListSubfooterCell: View, TransactionListCell {
    
    let row: TransactionListRowViewModel
    init(row: TransactionListRowViewModel) {
        self.row = row
    }
    
    var body: some View {
        if case let .subfooter( odd ) = row  {
            Text("") //TODO: figure out the container thing
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 18)
                .background(getBackgroundColour(odd: odd))
        }
        else {
            fatalError("Expected: subfooter")
        }
    }
}
