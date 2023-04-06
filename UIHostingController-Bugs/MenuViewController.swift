//  Created by Alex Ozun on 04/04/2023.

import Foundation
import UIKit
import SwiftUI

class MenuViewController: UITableViewController {
  struct Screen {
    let text: String
    let selector: Selector
  }
  
  let screens: [Screen] = [
    Screen(
      text: "Safe Area Inset bug in embedded Collection/Table View (all iOS versions)",
      selector: #selector(presetSafeAreaInsetsBugViewController)
    ),
    Screen(
      text: "Keyboard Avoidance Bug inside Collection/Table Cells (iOS 14-14.2)",
      selector: #selector(presetKeyboardAvoidanceBugCellViewController)
    ),
    Screen(
      text: "Keyboard Avoidance Bug outside Collection/Table Cells (all iOS versions)",
      selector: #selector(presetKeyboardAvoidanceBugStackViewController)
    ),
    Screen(
      text: "@State reuse bug (all iOS versions)",
      selector: #selector(presetInternalStateReuseViewController)
    ),
    Screen(
      text: "@State reuse fix (all iOS versions)",
      selector: #selector(presetExternalStateReuseViewController)
    ),
    Screen(
      text: "Performance comparison",
      selector: #selector(presetBenchmarkViewController)
    ),
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let screen = screens[indexPath.row]
    let cell = UITableViewCell()
    cell.textLabel?.text = screen.text
    cell.textLabel?.numberOfLines = 0
    return cell
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    screens.count
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let screen = screens[indexPath.row]
    perform(screen.selector)
  }
  
  @objc func presetSafeAreaInsetsBugViewController() {
    navigationController?.pushViewController(SafeAreaInsetsBugViewController(), animated: true)
  }
  
  @objc func presetKeyboardAvoidanceBugCellViewController() {
    navigationController?.pushViewController(KeyboardAvoidanceBugCellViewControlller(), animated: true)
  }
  
  @objc func presetKeyboardAvoidanceBugStackViewController() {
    navigationController?.pushViewController(KeyboardAvoidanceBugStackViewControlller(), animated: true)
  }
  
  @objc func presetInternalStateReuseViewController() {
    navigationController?.pushViewController(InternalStateReuseViewController(), animated: true)
  }
  
  @objc func presetExternalStateReuseViewController() {
    navigationController?.pushViewController(ExternalStateReuseViewController(), animated: true)
  }
  
  @objc func presetBenchmarkViewController() {
    navigationController?.pushViewController(BenchmarkViewController(), animated: true)
  }
}

class BenchmarkViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let uikit = UIButton()
    let swiftUI = UIButton()
    uikit.setTitle("Complex SwiftUI view in UICollectionView", for: .normal)
    uikit.setTitleColor(.systemBlue, for: .normal)
    swiftUI.setTitleColor(.systemBlue, for: .normal)
    swiftUI.setTitle("Complex SwiftUI view in SwiftUI.List", for: .normal)
    uikit.addTarget(self, action: #selector(presentCollection), for: .touchUpInside)
    swiftUI.addTarget(self, action: #selector(presentList), for: .touchUpInside)
    let stackView = UIStackView(arrangedSubviews: [uikit, swiftUI])
    stackView.axis = .vertical
    view.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
    ])
    navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Read me", style: .done, target: self, action: #selector(showTip))
    view.backgroundColor = .white
  }
  
  @objc func showTip() {
    let vc = ReadMeViewController(
      text: "Run these screens on a real device using Time, GPU and SwiftUI Profilers"
    )
    vc.modalPresentationStyle = .pageSheet
    present(vc, animated: true)
  }
  
  @objc func presentCollection() {
    navigationController?.pushViewController(PerformanceUICollectionView(), animated: true)
  }
  
  @objc func presentList() {
    navigationController?.pushViewController(UIHostingController(rootView: ListView()), animated: true)
  }
}
