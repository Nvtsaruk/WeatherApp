import Foundation
struct CoordToPlace: Decodable {
    let name: String
    let local_names: [String: String]?
    let lat: Double
    let lon: Double
    let country: String?
    let state: String?
}
typealias CoordToPlaceArr = [CoordToPlace]
struct Place: Decodable {
    let name: String
}
