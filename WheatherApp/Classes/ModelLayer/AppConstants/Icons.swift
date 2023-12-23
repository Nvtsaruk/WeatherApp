enum WeatherIcons: String, Decodable {
    case clearSky = "01d"
    case fewClouds = "02d"
    case scatteredClouds = "03d"
    case brokenClouds = "04d"
    case showerRain = "09d"
    case rain = "10d"
    case thunderstorm = "11d"
    case snow = "13d"
    case mist = "50d"
    case clearSkyN = "01n"
    case fewCloudsN = "02n"
    case scatteredCloudsN = "03n"
    case brokenCloudsN = "04n"
    case showerRainN = "09n"
    case rainN = "10n"
    case thunderstormN = "11n"
    case snowN = "13n"
    case mistN = "50n"
    
    func getIcon() -> String {
        switch self {
            case .clearSky:
                "sun.max.fill"
            case .fewClouds:
                "cloud.sun.fill"
            case .scatteredClouds:
                "cloud.fill"
            case .brokenClouds:
                "smoke.fill"
            case .showerRain:
                "cloud.rain.fill"
            case .rain:
                "cloud.heavyrain.fill"
            case .thunderstorm:
                "cloud.bolt.fill"
            case .snow:
                "snowflake"
            case .mist:
                "cloud.fog.fill"
            case .clearSkyN:
                "moon.fill"
            case .fewCloudsN:
                "cloud.moon.fill"
            case .scatteredCloudsN:
                "cloud.fill"
            case .brokenCloudsN:
                "smoke.fill"
            case .showerRainN:
                "cloud.rain.fill"
            case .rainN:
                "cloud.heavyrain.fill"
            case .thunderstormN:
                "cloud.bolt.fill"
            case .snowN:
                "snowflake"
            case .mistN:
                "cloud.fog.fill"
        }
    }
    func getBack() -> String {
        switch self {
            case .clearSky:
                "ClearSky"
            case .fewClouds:
                "FewClouds"
            case .scatteredClouds:
                "scatteredClouds"
            case .brokenClouds:
                "ClearSky"
            case .showerRain:
                "ClearSky"
            case .rain:
                "ClearSky"
            case .thunderstorm:
                "ClearSky"
            case .snow:
                "ClearSky"
            case .mist:
                "ClearSky"
            case .clearSkyN:
                "ClearSkyN"
            case .fewCloudsN:
                "FewCloudsN"
            case .scatteredCloudsN:
                "scatteredCloudsN"
            case .brokenCloudsN:
                "ClearSky"
            case .showerRainN:
                "ClearSky"
            case .rainN:
                "ClearSky"
            case .thunderstormN:
                "ClearSky"
            case .snowN:
                "ClearSky"
            case .mistN:
                "ClearSky"
        }
    }
}
