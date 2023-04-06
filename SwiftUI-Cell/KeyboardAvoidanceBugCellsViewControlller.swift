//  Created by Alex Ozun on 04/04/2023.

import Foundation
import UIKit
import SwiftUI

class KeyboardAvoidanceBugCellViewControlller: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewCompositionalLayout.list(
      using: UICollectionLayoutListConfiguration(appearance: .plain)
    )
  )
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(collectionView)
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(HostingCollectionCell.self, forCellWithReuseIdentifier: "HostingCollectionCell")
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
    
    navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Read me", style: .done, target: self, action: #selector(showTip))
    view.backgroundColor = .white
  }
  
  @objc func showTip() {
    let vc = ReadMeViewController(
      text: "Run on iOS 14.0 - 14.2 simulator, focus on one of the cells' text field to bring up the keyboard, observe cells' heights fluctuating due to built-in keyboard avoidance of UIHostingController"
    )
    vc.modalPresentationStyle = .pageSheet
    present(vc, animated: true)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.collectionViewLayout.invalidateLayout()
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    100
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let hostingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HostingCollectionCell", for: indexPath) as! HostingCollectionCell
    hostingCell.configure(ViewWithTextField(index: indexPath.row), parentController: self)
    return hostingCell
  }
}

class ReadMeViewController: UIViewController {
  init(text: String) {
    super.init(nibName: nil, bundle: nil)
    let label = UILabel()
    label.text = text
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      label.topAnchor.constraint(equalTo: view.topAnchor),
      label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    view.backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct ViewWithTextField: View {
  @State var text: String = ""
  let index: Int
  
  var height: CGFloat {
    if index.isMultiple(of: 2) {
      return 40
    } else if index.isMultiple(of: 3) {
      return 80
    } else {
      return 120
    }
  }
  
  var colour: Color {
    if index.isMultiple(of: 2) {
      return .red
    } else if index.isMultiple(of: 3) {
      return .yellow
    } else {
      return .green
    }
  }

  var body: some View {
    VStack {
      TextField("Start typing", text: $text)
        .padding(.horizontal, 16)
      Text("Height: \(height)")
        .frame(height: height)
    }
    .background(colour)
  }
}
