//
//  GridView.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 25/10/2023.
//

import UIKit

class VerticalStackView: UIStackView, DataTransfer {

    private lazy var horizontalStackViews = [HorizontalStackView(), HorizontalStackView(),
                                     HorizontalStackView(), HorizontalStackView(), HorizontalStackView()]

    private let loadView = UIView()

    private let loadButton = UIButton()

    func transferThumbnailData(data: [[(String, String)]]) {

        setupThumbnailViews()
        setupThumbnailConstraints()

        self.setRulesStackView(backgroundColor: .white, axis: .vertical, distribution: .fillEqually,
                               alignment: .fill, spacing: 1)

        //Shows 5 Horizontal until theres a need to lead more
        var auxData = data
        for horizontalStackView in horizontalStackViews {

            horizontalStackView.transferThumbnailData(data: auxData.removeFirst())
        }
    }

    func transferDetailData(data: Character) {

    }
}

extension VerticalStackView {

    func setupThumbnailViews() {

        for horizontalStackView in horizontalStackViews {

            self.addArrangedSubview(horizontalStackView)
        }

        self.addArrangedSubview(loadView)
        loadView.addSubview(loadButton)
        loadButton.setTitle("Load more", for: .normal)
        loadButton.backgroundColor = .black
        loadButton.layer.cornerRadius = 15
        loadButton.clipsToBounds = true

        var resp : UIResponder! = self
        while !(resp is MainViewController) { resp = resp.next }
        let vc = resp as! MainViewController
        loadButton.addTarget(vc, action: #selector(vc.buttonAction), for: .touchUpInside)
    }

    func setupDetailViews() {

        for horizontalStackView in horizontalStackViews {

            self.addArrangedSubview(horizontalStackView)
        }
    }

    func setupThumbnailConstraints() {

        for horizontalStackView in horizontalStackViews {

            horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }

        loadView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            loadView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])

        loadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadButton.centerXAnchor.constraint(equalTo: loadView.centerXAnchor),
            loadButton.centerYAnchor.constraint(equalTo: loadView.centerYAnchor),
            loadButton.heightAnchor.constraint(equalToConstant: 50),
            loadButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    func setupDetailConstraints() {

        for horizontalStackView in horizontalStackViews {

            horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }

    }
}

//Aplicar em todas as Views
protocol DataTransfer{

    func transferThumbnailData(data: [[(String, String)]])

    func transferDetailData(data: Character)

    func setupThumbnailViews()

    func setupDetailViews()

    func setupThumbnailConstraints()

    func setupDetailConstraints()
}

extension UIStackView {

    func setRulesStackView(backgroundColor: UIColor, axis: NSLayoutConstraint.Axis,
                           distribution: UIStackView.Distribution,
                           alignment: UIStackView.Alignment, spacing: CGFloat) {

        self.backgroundColor = backgroundColor
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
    }
}
