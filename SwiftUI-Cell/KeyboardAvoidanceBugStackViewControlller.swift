//  Created by Alex Ozun on 04/04/2023.

import Foundation
import UIKit
import SwiftUI

final class KeyboardAvoidanceBugStackViewControlller: UIViewController {
  override func viewDidLoad() {
    let hostingController = UIHostingController(rootView: SwiftUIView())
    hostingController.view.backgroundColor = .clear
    let searchBar = UISearchBar()
    let label = UILabel()
    label.text = "This is a normal UILabel placed in a UIStackView below the SwiftUI view"
    label.numberOfLines = 0
    let stackView = UIStackView(arrangedSubviews: [hostingController.view, label])
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.backgroundColor = .gray
    stackView.alignment = .center
    view.addSubview(stackView)
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(searchBar)
    
    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
    view.backgroundColor = .white
    navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Read me", style: .done, target: self, action: #selector(showTip))
  }
  
  @objc func showTip() {
    let vc = ReadMeViewController(
      text: "Run on any iOS version, focus on search bar to bring up the keyboard, observe the bottom SwiftUI view to jump due to built-in keyboard avoidance of UIHostingController"
    )
    vc.modalPresentationStyle = .pageSheet
    present(vc, animated: true)
  }
}

private class LabelView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    let label = UILabel()
    label.text = "UIKit View"
    label.numberOfLines = 1
    
    label.translatesAutoresizingMaskIntoConstraints = false
    addSubview(label)
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      label.bottomAnchor.constraint(equalTo: bottomAnchor),
      label.leadingAnchor.constraint(equalTo: leadingAnchor),
      label.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private struct SwiftUIView: View {
  let height: CGFloat = 100
  
  var body: some View {
    Text("This SwiftUI View should stay put")
      .padding(.vertical, 30)
      .background(Color.red)
  }
}
