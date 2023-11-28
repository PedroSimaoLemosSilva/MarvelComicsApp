//
//  DetailsViewController.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 31/10/2023.
//

import UIKit

class DetailsViewController: UIViewController {

    var delegate: DetailsViewControllerDelegate?

    private let tableView = UITableView()

    private let indicatorView = IndicatorView()

    private let detailsViewModel = DetailsViewModel()

    init(id: Int, name: String, image: UIImage, favourite: Bool) {

        super.init(nibName: nil, bundle: nil)
    
        detailsViewModel.setCharacterThumbnail(id: id, name: name, image: image, favourite: favourite)
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        Task {
        
            configureLoadingView()

            indicatorView.showSpinner()

            await detailsViewModel.dataFormatting()

            indicatorView.hideSpinner()

            tableView.reloadData()
            addSubviews()
            defineSubviewConstraints()
            configureSubviews()
        }

        tableView.register(CharacterThumbnailCell.self, forCellReuseIdentifier: "ThumbnailCell")
        tableView.register(DetailsCell.self, forCellReuseIdentifier: "DetailsCell")

    }
}

private extension DetailsViewController {

    func configureLoadingView() {

        indicatorView.setupViews()
        indicatorView.setupConstraints()

        self.view.addSubview(self.indicatorView)

        self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.indicatorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.indicatorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.indicatorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.indicatorView.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
    }

    func addSubviews() {

        self.view.addSubview(self.tableView)
    }

    func defineSubviewConstraints() {

        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    func configureSubviews() {

        self.view.backgroundColor = .white

        self.tableView.backgroundColor = .white
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
    }
}

extension DetailsViewController: CharacterThumbnailCellDelegate {

    func sendCharacterClickedMain(id: Int) {
        
        detailsViewModel.changeFavourite(id: id)
        detailsViewModel.saveChanges()
       
        tableView.reloadData()

        delegate?.sendFavouriteSelected(id: id)
    }
}

extension DetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            print("hello")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThumbnailCell", for: indexPath) as? CharacterThumbnailCell else {

                return UITableViewCell()
            }

            cell.selectionStyle = .none
            cell.delegate = self
            
            let item = detailsViewModel.getCharacterThumbnail()
            configureThumbnailCell(for: cell, with: item)
            
            return cell
        } else {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath) as? DetailsCell else {

                return UITableViewCell()
            }

            //Naming the keys in alphabetic order to sort them the same way as the sections
            let sectionsNames = detailsViewModel.getCharacterDetailsKeys()

            let key = sectionsNames[indexPath.section]

            let item = detailsViewModel.characterForRowAtSectionAt(indexPath: indexPath, key: key)
            cell.selectionStyle = .none

            configureDetailsCell(for: cell, with: item)

            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {

        return detailsViewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let sectionsNames = detailsViewModel.getCharacterDetailsKeys()

        let sectionName = sectionsNames[section]

        if let sectionSize = detailsViewModel.numberOfRowsInSection(section: sectionName) {

            return sectionSize
        } else {

            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        let sectionName: String
        switch section {
            case 0:
                sectionName = NSLocalizedString("", comment: "Character")
            case 1:
                sectionName = NSLocalizedString("Comics", comment: "Comics")
            case 2:
                sectionName = NSLocalizedString("Events", comment: "Events")
            case 3:
                sectionName = NSLocalizedString("Series", comment: "Series")
            case 4:
                sectionName = NSLocalizedString("Stories", comment: "Stories")
            default:
                sectionName = ""
        }
        return sectionName
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 150
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 1
    }

    func configureThumbnailCell(for cell: CharacterThumbnailCell, with item: (Int, String, UIImage, Bool)) {

        cell.transferThumbnailData(id: item.0, name: item.1, thumbnailImage: item.2, favourite: item.3)
    }

    func configureDetailsCell(for cell: DetailsCell, with item: (String, String)) {

        cell.transferDetailsData(title: item.0, description: item.1)

    }
}

protocol DetailsViewControllerDelegate {

    func sendFavouriteSelected(id: Int)
}
