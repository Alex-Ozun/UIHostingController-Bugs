//  Created by Alex Ozun on 04/04/2023.

import UIKit
import SwiftUI

class SafeAreaInsetsBugViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewCompositionalLayout.list(
      using: UICollectionLayoutListConfiguration(appearance: .plain)
    )
  )
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let topView = UIView()
    topView.backgroundColor = .gray
    let stackView = UIStackView(arrangedSubviews: [topView, collectionView])
    stackView.axis = .vertical
    view.addSubview(stackView)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      topView.heightAnchor.constraint(equalToConstant: 10)
    ])
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.register(HostingCollectionCell.self, forCellWithReuseIdentifier: "HostingCollectionCell")
    navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Read me", style: .done, target: self, action: #selector(showTip))
    view.backgroundColor = .white
  }
  
  @objc func showTip() {
    let vc = ReadMeViewController(
      text: "(Any iOS version) Run on any simulator device that has safe area (e.g. iPhone 14) and observe cells' heights fluctuating due to built-in safe area insets of UIHostingController when the collection/table view isn't directly attached to the safeAreaLayoutGuide (notice the gray view above the collection view)"
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
    hostingCell.configure(TextCell(index: indexPath.row), parentController: self)
    return hostingCell
  }
}

struct TextCell: View {
  let index: Int
  var height: CGFloat {
    
    if index.isMultiple(of: 3) {
      return 80
    } else if index.isMultiple(of: 2) {
      return 40
    } else {
      return 120
    }
  }
  var colour: Color {
    if index.isMultiple(of: 3) {
      return .red
    } else if index.isMultiple(of: 2) {
      return .yellow
    } else {
      return .green
    }
  }
  
  var body: some View {
    Text("SwiftUI View, height: \(height)")
      .frame(height: height)
      .background(colour)
  }
}

struct ButtonCell: View {
  @State var isTapped: Bool = false
  @State var text: String = "text"
  @State var isEditing: Bool = false
  
  var body: some View {
    VStack {
      TextField("Hello", text: $text)
      Button("I'm a button! Tap me!", action: {
        isTapped.toggle()
      })
      .background(isTapped ? Color.red : Color.clear)
      .frame(maxWidth: .infinity, minHeight: 60, maxHeight: .infinity)
    }
    .background(Color.yellow)
  }
}

class UIKitCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: .zero)
    let redView = UIView(frame: bounds)
    redView.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
    self.backgroundView = redView

    let blueView = UIView(frame: bounds)
    blueView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 1, alpha: 1)
    self.selectedBackgroundView = blueView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
