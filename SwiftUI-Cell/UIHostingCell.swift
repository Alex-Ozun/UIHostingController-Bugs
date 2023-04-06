//  Created by Alex Ozun on 04/04/2023.

import Foundation
import UIKit
import SwiftUI

public final class HostingCollectionCell: UICollectionViewCell {
  let hostingController = UIHostingController(rootView: HostingView(rootView: nil))
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setUpHostingView(hostingController.view)
  }
  
  private func setUpHostingView(_ view: UIView) {
    contentView.addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: contentView.topAnchor),
      view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    ])
  }
  
  public override func updateConfiguration(using state: UICellConfigurationState) {
    super.updateConfiguration(using: state)
    // update styling when isSelected, isHighlighted, etc
  }
  
  public func configure<V: View>(_ view: V, parentController: UIViewController) {
    let needsAddingAsChild = hostingController.parent != parentController
    if needsAddingAsChild {
      parentController.addChild(hostingController)
    }
    hostingController.rootView.rootView = AnyView(view)
    hostingController.view.invalidateIntrinsicContentSize()
    if needsAddingAsChild {
      hostingController.didMove(toParent: parentController)
    }
  }
  
  func disableSafeArea() {
    hostingController.disableSafeArea()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct HostingView: View {
  var rootView: AnyView?
  
  var body: some View {
    rootView
  }
}
