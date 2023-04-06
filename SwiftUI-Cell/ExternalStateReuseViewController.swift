//  Created by Alex Ozun on 04/04/2023.

import UIKit
import SwiftUI

class ExternalStateReuseViewController: UICollectionViewController {
  let rows: [ExternalState] = (0...100).map { _ in ExternalState() }
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
      text: "Run on any iOS verions, tap on one of the buttons to change it's background colour, scroll to observe how the state is correctly reused."
    )
    vc.modalPresentationStyle = .pageSheet
    present(vc, animated: true)
  }

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    rows.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let hostingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HostingCollectionCell", for: indexPath) as! HostingCollectionCell
      if hostingCell.hostingController.parent != self {
        addChild(hostingCell.hostingController)
        hostingCell.hostingController.didMove(toParent: self)
      }
    hostingCell.configure(ViewWithExternalState(state: rows[indexPath.row]), parentController: self)
      return hostingCell
  }
}

class ExternalState: ObservableObject {
  @Published var isTapped: Bool = false
}

struct ViewWithExternalState: View {
  @ObservedObject var state: ExternalState
  
  init(state: ExternalState = ExternalState()) {
    self.state = state
  }
  
  var body: some View {
    VStack {
      Button("Tap me to change colour", action: {
        state.isTapped.toggle()
      })
    }
    .background(state.isTapped ? Color.red : Color.clear)
    .frame(height: 60)
  }
}
