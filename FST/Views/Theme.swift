import SwiftUI

class FSTTheme : ObservableObject
{
    let paddingUnit             : CGFloat = 10.0
    let superheadingFont        : Font = .largeTitle
    let superheadingFontWeight  : Font.Weight = .bold
    let headingFont             : Font = .headline
    let headingFontWeight       : Font.Weight = .bold
    let subheadingFont          : Font = .subheadline
    let subheadingFontWeight    : Font.Weight = .semibold
    let buttonBackground        : Color
    let buttonForeground        : Color
    let buttonFont              : Font
    let buttonFontWeight        : Font.Weight = .semibold
    let errorFont               : Font = .subheadline
    let errorFontWeight         : Font.Weight = .semibold
    let errorBackground         : Color = .red
    let errorForeground         : Color = .white
    let placeholderForeground   : Color = .blue
    let thumbnailBackground     : Color = .gray
    
    init(buttonBackground : Color, buttonForeground : Color, buttonFont : Font)
    {
        self.buttonBackground = buttonBackground
        self.buttonForeground = buttonForeground
        self.buttonFont       = buttonFont
    }
        
    static let Dark = FSTTheme(
        buttonBackground : .black,
        buttonForeground : .white,
        buttonFont       : Font.system(size: 16.0)
    )
    
    static let Light = Dark // [dho] TODO
}
