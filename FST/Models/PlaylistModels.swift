import SwiftUI

struct FSTPlaylist : Codable, Identifiable
{
    let id          : String;
    let name        : String;
    let description : String;
    let image       : URL?;
    let movies      : [FSTMovie]
}
