//
//  TheMapView.swift
//  Practice-Foursquare-App
//
//  Created by Kelby Mittan on 2/22/20.
//  Copyright © 2020 Kelby Mittan. All rights reserved.
//

import UIKit

class TheMapView: UIView {

    public lazy var locationSearchBar: UISearchTextField = {
        let sb = UISearchTextField()
        sb.placeholder = "search city"
        
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupLocationSearchBarConstraints()
    }
    
    private func setupLocationSearchBarConstraints() {
        addSubview(locationSearchBar)
        locationSearchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationSearchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            locationSearchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            locationSearchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

}
