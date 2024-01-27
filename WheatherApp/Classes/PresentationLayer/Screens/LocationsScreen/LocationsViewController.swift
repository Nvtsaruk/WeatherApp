import UIKit

final class LocationsViewController: UIViewController {
    
    let searchController = UISearchController()
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var titleLabel: UILabel!
    var viewModel: LocationsViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = LocationSearchLocalization.title.string
        tableView.delegate = self
        tableView.dataSource = self
        viewModel?.addObserver()
        viewModel?.getData()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        self.navigationItem.hidesBackButton = true
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        searchController.searchBar.barStyle = .black
        
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.delegate = self
        
        let locationNib = UINib(nibName: XibNames.location.name, bundle: nil)
        tableView.register(locationNib, forCellReuseIdentifier: XibNames.location.name)
        
        let searchNib = UINib(nibName: XibNames.search.name, bundle: nil)
        tableView.register(searchNib, forCellReuseIdentifier: XibNames.search.name)
    }

    private func bindViewModel() {
        viewModel?.updateClosure = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension LocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive) {
            return viewModel?.location?.count ?? 0
        } else {
            return viewModel?.weatherData.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentCell = tableView.dequeueReusableCell(withIdentifier: XibNames.location.name) as? LocationsTableViewCell else { return UITableViewCell() }
        guard let searchCell = tableView.dequeueReusableCell(withIdentifier: XibNames.search.name) as? SearchTableViewCell else { return UITableViewCell() }
        if(searchController.isActive)
        {
            let name = ((viewModel?.location?[indexPath.row].local_names?[viewModel?.locale?.getLocale() ?? ""] ?? viewModel?.location?[indexPath.row].name) ?? "")
            let country = (viewModel?.location?[indexPath.row].country ?? "")
            let state = (viewModel?.location?[indexPath.row].state ?? "")
            let label = name + " - " + country + " " + state
            searchCell.configure(label: label)
            return searchCell
        }
        else
        {
            switch indexPath.row {
                case 0:
                    currentCell.configure(locationName: LocationSearchLocalization.current.string,
                                          backImage: viewModel?.weatherData[indexPath.row].current.weather.first?.icon.getBack() ?? "",
                                          sky: viewModel?.weatherData[indexPath.row].current.weather.first?.description ?? "",
                                          temp: viewModel?.weatherData[indexPath.row].current.temp ?? 0,
                                          minMax: viewModel?.getMinMax(tempArr: viewModel?.weatherData[indexPath.row].hourly ?? []) ?? "")
                    currentCell.backgroundImage.heroID = "back\(indexPath.row)"
                    return currentCell
                default:
                    currentCell.configure(locationName: viewModel?.weatherData[indexPath.row].timezone ?? "",
                                          backImage: viewModel?.weatherData[indexPath.row].current.weather.first?.icon.getBack() ?? "",
                                          sky: viewModel?.weatherData[indexPath.row].current.weather.first?.description ?? "",
                                          temp: viewModel?.weatherData[indexPath.row].current.temp ?? 0,
                                          minMax: viewModel?.getMinMax(tempArr: viewModel?.weatherData[indexPath.row].hourly ?? []) ?? "")
                    currentCell.backgroundImage.heroID = "back\(indexPath.row)"
                    return currentCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(searchController.isActive) {
            searchController.isActive = false
            viewModel?.presentWeather(id: indexPath.row)
            tableView.reloadData()
        } else {
            viewModel?.backToMain(page: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
          guard let location = viewModel?.weatherData[indexPath.row].timezone else { return }
          viewModel?.removeCity(location: location)
      }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(searchController.isActive)
        {
            return 30
        }
        else
        {
            return 120
        }
    }
}

extension LocationsViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        if searchText != ""{
            viewModel?.search(item: searchText)
        }
    }
}


extension LocationsViewController: Storyboarded {
    static func containingStoryboard() -> Storyboard {
        .LocationsView
    }
}

