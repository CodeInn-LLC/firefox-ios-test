// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import UIKit
import ComponentLibrary

public final class MenuMainView: UIView,
                                 MenuTableViewDataDelegate, ThemeApplicable {
    // MARK: - UI Elements
    private var tableView: MenuTableView = .build()
    public var accountHeaderView: HeaderView = .build()

    // MARK: - Properties

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupView() {
        self.addSubview(accountHeaderView)
        self.addSubview(tableView)

        NSLayoutConstraint.activate([
            accountHeaderView.topAnchor.constraint(equalTo: self.topAnchor),
            accountHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            accountHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: accountHeaderView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    public func setupDetails(subtitle: String, title: String, icon: UIImage?) {
        accountHeaderView.setupDetails(subtitle: subtitle,
                                       title: title,
                                       icon: icon)
    }

    public func setupAccessibilityIdentifiers(closeButtonA11yLabel: String,
                                              closeButtonA11yId: String,
                                              mainButtonA11yLabel: String,
                                              mainButtonA11yId: String,
                                              menuA11yId: String,
                                              menuA11yLabel: String) {
        accountHeaderView.setupAccessibility(closeButtonA11yLabel: closeButtonA11yLabel,
                                             closeButtonA11yId: closeButtonA11yId,
                                             mainButtonA11yLabel: mainButtonA11yLabel,
                                             mainButtonA11yId: mainButtonA11yId)
        tableView.accessibilityIdentifier = menuA11yId
        tableView.accessibilityLabel = menuA11yLabel
    }

    public func adjustLayout() {
        accountHeaderView.adjustLayout()
    }

    // MARK: - Interface
    public func reloadTableView(with data: [MenuSection]) {
        tableView.reloadTableView(with: data)
    }

    // MARK: - ThemeApplicable
    public func applyTheme(theme: Theme) {
        backgroundColor = .clear
        tableView.applyTheme(theme: theme)
        accountHeaderView.applyTheme(theme: theme)
        accountHeaderView.setIconTheme(with: theme)
    }
}