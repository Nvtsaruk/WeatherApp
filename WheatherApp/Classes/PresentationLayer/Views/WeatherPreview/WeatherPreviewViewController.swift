import UIKit

final class WeatherPreviewViewController: UIViewController {
    
    let cityName = UILabel()
    let tempLabel = UILabel()
    let skyLabel = UILabel()
    let tempSkyLabel = UILabel()
    let minMaxLabel = UILabel()
    
    let backgroundImage = UIImageView()
    
    let cancelButton = UIButton()
    let addButton = UIButton()
    
    var viewModel: WeatherPreviewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getData()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel?.updateClosure = { [weak self] in
            guard let self = self else { return }
            guard let image = viewModel?.weatherData?.current.weather.first?.icon.getBack() else { return }
            backgroundImage.image = UIImage(named: image)
            setupUI()
        }
    }
    
    private func setupUI() {
        cityName.textColor = .white
        tempLabel.textColor = .white
        skyLabel.textColor = .white
        minMaxLabel.textColor = .white
        
        cityName.font = cityName.font.withSize(35)
        tempLabel.font = UIFont.systemFont(ofSize: 120, weight: UIFont.Weight.thin)
        skyLabel.font = skyLabel.font.withSize(20)
        minMaxLabel.font = minMaxLabel.font.withSize(20)
        
        cityName.text = viewModel?.weatherData?.timezone
        tempLabel.text = String(Int(viewModel?.weatherData?.current.temp ?? 0)) + WeatherScreenLocalization.tempSign.string
        skyLabel.text = viewModel?.weatherData?.current.weather.first?.description
        minMaxLabel.text = viewModel?.getMinMax(tempArr: viewModel?.weatherData?.hourly ?? [])
        
        cancelButton.setTitle(LocationSearchLocalization.cancel.string, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelWindow), for: .touchUpInside)
        addButton.setTitle(LocationSearchLocalization.add.string, for: .normal)
        addButton.addTarget(self, action: #selector(addCity), for: .touchUpInside)
        
        view.addSubview(backgroundImage)
        view.addSubview(cancelButton)
        view.addSubview(addButton)
        view.addSubview(cityName)
        view.addSubview(tempLabel)
        view.addSubview(skyLabel)
        view.addSubview(minMaxLabel)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        cityName.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        skyLabel.translatesAutoresizingMaskIntoConstraints = false
        minMaxLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cityName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityName.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            
            tempLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tempLabel.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: -12),
            
            skyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skyLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: -2),
            
            minMaxLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            minMaxLabel.topAnchor.constraint(equalTo: skyLabel.bottomAnchor, constant: 4),
        ])
    }
    
    @objc private func cancelWindow() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func addCity() {
        viewModel?.addBase()
        self.dismiss(animated: true, completion: nil)
    }
}
