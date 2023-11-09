//
//  DetailsViewController.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 31/10/2023.
//

import UIKit

class DetailsViewController: UIViewController {

    private let tableView = UITableView()

    private let indicatorView = IndicatorView()

    private let webservice = DetailsWebservice()

    private var characterThumbnail: CharacterThumbnail = CharacterThumbnail()

    lazy var characterDetails: [String: [Detail]] = [:]

    enum ProfileSection: Int {

        case Time, WarmUp, CoolDown, Count

        static var count = {

            return ProfileSection.Count.rawValue
        }

        static let sectionTitles = [

            Time: "Time",
            WarmUp: "Warm Up",
            CoolDown: "Cool Down"
        ]

        func sectionTitle() -> String {

            if let sectionTitle = ProfileSection.sectionTitles[self] {

                return sectionTitle
            } else {

                return ""
            }
        }
    }


    init(characterThumbnail: CharacterThumbnail) {

        super.init(nibName: nil, bundle: nil)
    
        self.characterThumbnail = characterThumbnail
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        Task {
        
            configureLoadingView()

            indicatorView.showSpinner()

            await dataFormatting()

            indicatorView.hideSpinner()

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

    func dataFormatting() async {

        do {

            guard let comicsDataWrapper = try await webservice.fetchComics(id: characterThumbnail.id),
                  let eventsDataWrapper = try await webservice.fetchEvents(id: characterThumbnail.id),
                  let seriesDataWrapper = try await webservice.fetchSeries(id: characterThumbnail.id),
                  let storiesDataWrapper = try await webservice.fetchStories(id: characterThumbnail.id) else { return }

            characterDetails["Character"] = [Detail(title: "", description: "")]

            if let comicsData = comicsDataWrapper.data?.results {

                characterDetails["Comics"] = comicsData
            } else { characterDetails["Comics"] = nil }

            if let eventsData = eventsDataWrapper.data?.results {

                characterDetails["Events"] = eventsData
            } else { characterDetails["Events"] = nil }

            if let seriesData = seriesDataWrapper.data?.results {

                characterDetails["Series"] = seriesData
            } else { characterDetails["Series"] = nil  }

            if let storiesData = storiesDataWrapper.data?.results {

                characterDetails["Stories"] = storiesData
            } else { characterDetails["Stories"] = nil  }

        } catch { print(error) }
    }
}

extension DetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ThumbnailCell", for: indexPath) as? CharacterThumbnailCell else {

                return UITableViewCell()
            }

            cell.selectionStyle = .none
            let item = characterThumbnail
            configureThumbnailCell(for: cell, with: item)

            return cell
        } else {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath) as? DetailsCell else {

                return UITableViewCell()
            }

            //Naming the keys in alphabetic order to sort them the same way as the sections
            let sectionsNames = Array(characterDetails.keys).map { String($0) }.sorted { $0 < $1 }

            let key = sectionsNames[indexPath.section]

            let item = characterDetails[key]?[indexPath.row]
            cell.selectionStyle = .none

            if let item = item {

                configureDetailsCell(for: cell, with: item)
            }

            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {

        return characterDetails.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //Naming the keys in alphabetic order to sort them the same way as the sections
        let sectionsNames = Array(characterDetails.keys).map { String($0) }.sorted { $0 < $1 }

        let sectionName = sectionsNames[section]

        if let sectionList = characterDetails[sectionName] {

            return sectionList.count
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

    func configureThumbnailCell(for cell: CharacterThumbnailCell, with item: CharacterThumbnail) {

        cell.transferThumbnailData(id: item.id, name: item.name, imageData: item.imageData)

    }


    func configureDetailsCell(for cell: DetailsCell, with item: Detail) {

        cell.transferDetailsData(detail: item)

    }
}

