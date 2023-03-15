//
//  UPageControl.swift
//  Handy
//
//  Created by Uma on 01/07/21.
//

import UIKit

public class UPageControl: UIPageControl {
    
    /// Active indicator color
    public var activeColor = UIColor.AppColor
    
    /// Inactive indicator color
    public var inactiveColor = UIColor.AppColor
    
    /// Active indicator size
    public var activeSize = CGSize(width: 22, height: 6)
    
    /// Inactive indicator size
    public var inactiveSize = CGSize(width: 10, height: 6)

    private let magicTag = "UPageControl".hash

    /// Indicator spacing
    public var dotSpacing: CGFloat = 5.0 {
        didSet {
            updateDots()
        }
    }
    
    override public var currentPage: Int {
        didSet {
            updateDots()
        }
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateDots(animated: false)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        pageIndicatorTintColor = .clear
        currentPageIndicatorTintColor = .clear
        clipsToBounds = false
    }
    
    /// Update indicator
    func updateDots(animated: Bool = true) {
        guard numberOfPages > 0 else { return }
        let view = self
        let spacing = dotSpacing
        let dotsTotalW: CGFloat = CGFloat(numberOfPages - 1)
            * (inactiveSize.width + spacing)
            + activeSize.width
        let totalW = view.bounds.width

        var startX: CGFloat = totalW > dotsTotalW
            ? (totalW - dotsTotalW)/2.0
            : 0
        for idx in (0..<numberOfPages) {
            let isActive = idx == currentPage
            let color = isActive ? activeColor : inactiveColor
            let size = isActive ? activeSize: inactiveSize
            let imageV = self.imageView(for: view, index: idx)
            let pointX = startX
            let pointY = view.bounds.midY - size.height/2.0

            let change = {
                imageV?.frame = .init(x: pointX, y: pointY, width: size.width, height: size.height)
                imageV?.layer.cornerRadius = min(size.width, size.height)/2.0
                imageV?.backgroundColor = color
            }
            if animated {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                    change()
                })
            }else {
                change()
            }
            startX += size.width + spacing
        }
    }
    func imageView(for view: UIView, index page: Int) -> UIImageView?   {
        let tag = magicTag + page
        if let imageV = view.viewWithTag(tag) as? UIImageView {
            return imageV
        }
        let imageV  = UIImageView()
        imageV.tag = tag
        view.addSubview(imageV)
        return imageV
    }
}
