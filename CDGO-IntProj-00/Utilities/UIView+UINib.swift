//
//  UIView+NibLoadableView.swift
//  CDGO-IntProj-00
//
//  Created by Thwin Htoo Aung on 2022-05-21.
//

import UIKit


protocol NibLoadableView: UIView {

    // Target nib file to load
    var nibOrNil: UINib? { get }

    // container view where the nib views are attached
    var nibContainerView: UIView? { get }

    // Load contents from the nib, resolve outlets to current object
    // and attach top level view objects to the provided container
    func loadAndAttachNib()

}

extension NibLoadableView {

    static func __getSimpleClassName(
        from anyClass: AnyClass
    ) -> String {
        return NSStringFromClass(anyClass)
            .split(separator: ".")
            .map(String.init).last ?? ""
    }
    
    
    // Default implementation of attaching nib
    func loadAndAttachNib() {
        var nibFile = nibOrNil

        if nibFile == nil {
            nibFile = UINib(
                nibName: Self.__getSimpleClassName(
                    from: self.classForCoder
                ),
                bundle: Bundle(for: self.classForCoder)
            )
        }
        
        
        // If the nib file is not resolved, just don't do anything
        guard let nib = nibFile else {
//            fatalError("Unable to load \(Self.self) instance from nib.")
            return
        }

        // get all top level objects from the nib file
        // This also let the nib dynamically assign
        // outlets to the owner
        let objects = nib.instantiate(
            withOwner: self, options: nil
        )
        
        // if the nib container is not provided
        // no need to attach views on the container
        guard let container = nibContainerView else { return }

        // if the container is provided
        
        // Filter every uiview objects
        let views = objects.compactMap{$0 as? UIView}

        // Stick each view to the container
        for view in views {
            // Clear background
            view.backgroundColor = .clear
            
            // Opt into autolayout
            view.translatesAutoresizingMaskIntoConstraints = false
            
            // add to the container
            container.addSubview(view)
            
            // Stick the view to the margins
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0),
                view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0),
                view.topAnchor.constraint(equalTo: container.topAnchor, constant: 0),
                view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: 0),
            ])
        }
        
        awakeFromNib()

    }

}


class NibView: UIView, NibLoadableView {

    var nibOrNil: UINib? { nil }

    var nibContainerView: UIView? { self }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        loadAndAttachNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadAndAttachNib()
    }
    
}


class NibTableViewCell: UITableViewCell, NibLoadableView {
    
    var nibOrNil: UINib? { nil }

    var nibContainerView: UIView? { self.contentView }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadAndAttachNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadAndAttachNib()
    }
    
}
