//  Copyright © 2020 Lyle Resnick. All rights reserved.

import UIKit
import Combine
import EnumKit

class TransactionListViewController: UIViewController, SpinnerAttachable {

    var presenter: TransactionListPresenter!
    @IBOutlet private weak var tableView: UITableView!
    private var adapter: TransactionListAdapter!
    private var spinnerView: UIActivityIndicatorView!
    private var cancellables = [Cancellable]()

    private let input = PassthroughSubject<TransactionListPresenterInput, Never>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TransactionListConnector(viewController: self).configure()
        adapter = TransactionListAdapter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = adapter
        spinnerView = attachSpinner()
        spinnerView.hidesWhenStopped = true

        let output = presenter.transform(input: input.eraseToAnyPublisher())
            .makeConnectable()

        cancellables.append(
            output.capture(case: TransactionListPresenterOutput.refresh)
                .receive(on: RunLoop.main)
                .sink{ [weak self] event in
                    guard let self = self else { return }
                    switch event {
                    case .initialize:
                        self.spinnerView.startAnimating()
                    case let .showReport(rows):
                        self.spinnerView.stopAnimating()
                        self.adapter.rows = rows
                        self.tableView.reloadData()
                    }
                }
        )
        
        cancellables.append(output.connect())
        
        input.send(.refreshTwoSource)
//        input.send(.refreshOneSource)
    }
}

