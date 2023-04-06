//  Created by Alex Ozun on 04/04/2023.

import Foundation
import SwiftUI
import UIKit

class PerformanceUICollectionView: UICollectionViewController {
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
    view.backgroundColor = .white
  }

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    500
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let hostingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HostingCollectionCell", for: indexPath) as! HostingCollectionCell
      if hostingCell.hostingController.parent != self {
        addChild(hostingCell.hostingController)
        hostingCell.hostingController.didMove(toParent: self)
      }
    hostingCell.configure(ComplexView(index: indexPath.row), parentController: self)
      return hostingCell
  }
}


struct ListView: View {
  var body: some View {
    List {
      ForEach(Range(0...500)) { index in
//        ViewWithExternalState()
        ComplexView(index: index)
          .frame(maxWidth: .infinity)
      }
    }
  }
}

struct ComplexView: View {
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
    BG {
      BG {
        BG {
          BG {
            BG {
              BG {
                Text("Height: \(height)")
                  .frame(height: height)
                  .background(colour)
              }
            }
          }
        }
      }
    }
  }
}

struct BG<Content: View>: View {
  @ViewBuilder var content: () -> Content
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content
  }
  
  var body: some View {
    VStack {
      content()
      Text("Subview")
    }
      // Might not typecheck in older Xcode versions. You'd have to break these up
      .background(Color.red).padding(2)
      .background(Color.blue).padding(2)
      .background(Color.red).padding(2)
      .background(Color.blue).padding(2)
  }
}
