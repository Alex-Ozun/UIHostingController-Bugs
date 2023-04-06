//  Created by Alex Ozun on 04/04/2023.

import UIKit
import SwiftUI

class InternalStateReuseViewController: UICollectionViewController {
  init() {
    super.init(collectionViewLayout: UICollectionViewCompositionalLayout.list(
      using: UICollectionLayoutListConfiguration(appearance:
          .plain)
    ))
    collectionView.register(HostingCollectionCell.self, forCellWithReuseIdentifier: "HostingCollectionCell")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Read me", style: .done, target: self, action: #selector(showTip))
    view.backgroundColor = .white
  }
  
  @objc func showTip() {
    let vc = ReadMeViewController(
      text: "Run on any iOS verions, tap on one of the buttons to change it's background colour, scroll to observe how the @State is incorrectly reused."
    )
    vc.modalPresentationStyle = .pageSheet
    present(vc, animated: true)
  }

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    100
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let hostingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HostingCollectionCell", for: indexPath) as! HostingCollectionCell
      if hostingCell.hostingController.parent != self {
        addChild(hostingCell.hostingController)
        hostingCell.hostingController.didMove(toParent: self)
      }
    hostingCell.configure(ViewWithInternalState(), parentController: self)
      return hostingCell
  }
}

struct ViewWithInternalState: View {
  @State var isTapped: Bool = false
  
  var body: some View {
    VStack {
      Button("Tap me to change colour", action: {
        isTapped.toggle()
      })
    }
    .background(isTapped ? Color.red : Color.clear)
    .frame(height: 60)
  }
}
