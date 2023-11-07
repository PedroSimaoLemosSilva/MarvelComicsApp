//
//  DetailsViewController.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 31/10/2023.
//

import UIKit

class DetailsViewController: UIViewController {

    private let tableView = UITableView()

    private let webservice = Webservice()

    private var characterThumbnail: CharacterThumbnail = CharacterThumbnail()

    lazy var characterDetails: [String: [Detail]] = [:]

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

            await dataFormatting()
            addSubviews()
            defineSubviewConstraints()
            configureSubviews()
        }

        self.title = characterThumbnail.name

        tableView.register(CharacterThumbnailCell.self, forCellReuseIdentifier: "ThumbnailCell")
        tableView.register(DetailsCell.self, forCellReuseIdentifier: "DetailsCell")

    }
}

private extension DetailsViewController {

    func addSubviews() {

        self.view.addSubview(self.tableView)
    }

    func defineSubviewConstraints() {

        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }

    func configureSubviews() {

        self.view.backgroundColor = .white

        self.tableView.backgroundColor = .white
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        //self.tableView.tableFooterView = UIView()
    }

    func dataFormatting() async {

        do {

            var constants = Constants.Urls(id: characterThumbnail.id)
            let comicsUrl = constants.comics
            let eventsUrl = constants.events
            let seriesUrl = constants.series
            let storiesUrl = constants.stories

            guard let comicsDataWrapper = try await webservice.fetchDetailsInfo(url: comicsUrl),
                  let eventsDataWrapper = try await webservice.fetchDetailsInfo(url: eventsUrl),
                  let seriesDataWrapper = try await webservice.fetchDetailsInfo(url: seriesUrl),
                  let storiesDataWrapper = try await webservice.fetchDetailsInfo(url: storiesUrl) else { return }

            //let comicsTitle = constants.comics
            //let eventsTitle = constants.events
            //let seriesTitle = constants.series
            //let storiesTitle = constants.stories


            if let comicsData = comicsDataWrapper.data?.results {
                //comicsData.insert(, at: )
                if comicsData.count > 3 {

                    let newComicsData = Array(comicsData[0...2])
                    characterDetails["Comics"] = newComicsData
                } else { characterDetails["Comics"] = comicsData }
            } else { characterDetails["Comics"] = nil }

            if let eventsData = eventsDataWrapper.data?.results {

                if eventsData.count > 3 {

                    let newEventsData = Array(eventsData[0...2])
                    characterDetails["Events"] = newEventsData
                } else { characterDetails["Events"] = eventsData}
            } else { characterDetails["Events"] = nil }

            if let seriesData = seriesDataWrapper.data?.results {

                if seriesData.count > 3 {

                    let newSeriesData = Array(seriesData[0...2])
                    characterDetails["Series"] = newSeriesData
                } else { characterDetails["Series"] = seriesData }
            } else { characterDetails["Series"] = nil  }

            if let storiesData = storiesDataWrapper.data?.results {

                if storiesData.count > 3 {

                    let newStoriesData = Array(storiesData[0...2])
                    characterDetails["Stories"] = newStoriesData
                } else { characterDetails["Stories"] = storiesData }
            } else { characterDetails["Stories"] = nil  }

            characterDetails["Name"] = [Detail(title: "", description: "")]

        } catch { print(error) }
    }
}

extension DetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            //print(indexPath.row)
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

            let sectionsNames = ["Name", "Comics", "Events", "Series", "Stories"]
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

        let sectionsNames = ["Name", "Comics", "Events", "Series", "Stories"]

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
                sectionName = NSLocalizedString("", comment: "Names")
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

        cell.transferThumbnailData(id: item.id, name: item.name, imageUrl: item.imageUrl)

    }


    func configureDetailsCell(for cell: DetailsCell, with item: Detail) {

        cell.transferDetailsData(detail: item)

    }
}

