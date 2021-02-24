import SwiftUI

enum OMDBAPIResponse : String, Codable
{
    case success = "True"
    case failed  = "False"
}

struct OMDBAPIMovieSearchResult : Decodable
{
    let Search      : [FSTMovie]?
    let Error       : String?
    let Response    : OMDBAPIResponse
}

