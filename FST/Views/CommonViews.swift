import SwiftUI

struct FSTLoadingView : View
{
    @EnvironmentObject var theme : FSTTheme
    
    var body : some View
    {
        VStack(alignment: .center)
        {
            Spacer()
            
            Text("Loading...")
                .font(theme.subheadingFont)
                .fontWeight(theme.subheadingFontWeight)
            
            Spacer()
        }
        .frame(minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .center
        )
    }
}


struct FSTErrorView : View
{
    @EnvironmentObject var theme : FSTTheme
    
    let error : FSTError
    
    var body : some View
    {
        HStack
        {
            Spacer()
            Text(error.localizedDescription)
                .font(theme.errorFont)
                .fontWeight(theme.errorFontWeight)
                .foregroundColor(theme.errorForeground)
            Spacer()
        }
        .padding(.vertical, theme.paddingUnit)
        .padding(.horizontal, theme.paddingUnit * 2)
        .background(theme.errorBackground) 
    }
}

struct FSTButton : View
{
    @EnvironmentObject var theme : FSTTheme
    
    var label: String
    var action: (() -> Void)
    var disabled: Bool = false
        
    public var body: some View{
        Button(action: action)
        {
            Text(self.label.lowercased())
                .font(theme.buttonFont)
                .fontWeight(theme.buttonFontWeight)
                .fontWeight(Font.Weight.semibold)
                .fixedSize(horizontal: true, vertical: true)
                .lineLimit(1)
        }
        .foregroundColor(theme.buttonForeground)
        .padding(Edge.Set.vertical, theme.paddingUnit)
        .padding(Edge.Set.horizontal, theme.paddingUnit)
        .background(theme.buttonBackground)
        .disabled(disabled)
        .grayscale(disabled ? 1.0 : 0.0)
    }
}

struct FSTTextButton : View
{
    @EnvironmentObject var theme : FSTTheme
    
    var label: String
    var disabled : Bool = false
    
    public var body: some View{
        Text(label)
            .font(theme.buttonFont)
            .fontWeight(theme.buttonFontWeight)
            .fixedSize(horizontal: true, vertical: true)
            .lineLimit(1)
            .foregroundColor(theme.buttonForeground)
            .padding(.vertical, theme.paddingUnit)
            .padding(.horizontal, theme.paddingUnit * 2)
            .background(theme.buttonBackground)
            .cornerRadius(theme.paddingUnit)
            .grayscale(disabled ? 1.0 : 0.0)
    }
}

struct FSTThumbnailView : View
{
    @EnvironmentObject var theme : FSTTheme

    let dim : CGFloat = 100.0
    let imageURL : URL?
    
    @StateObject var dataProvider = FSTThumbnailProvider()
    
    var body: some View {
        
        VStack {
            if let uiImage = dataProvider.image, 
                let thumbnail = Image(uiImage: uiImage)
            {
                thumbnail
                    .resizable()
                    .scaledToFill()
                    .frame(width: dim, height: dim, alignment: .center)
                    .clipped()
            }
        }
        .frame(width: dim, height: dim, alignment: .center)
        .background(theme.thumbnailBackground)
        .onAppear
        {
            if let imageURL = imageURL 
            {
                dataProvider.load(from: imageURL)
            }
        }
    }
}


struct FSTTextField: View {
    @EnvironmentObject var theme : FSTTheme
    
    var placeholder: String
    @Binding var text: String
    var disabled : Bool = false
    var onEditingChanged: (Bool) -> () = { _ in }
    var onCommit: () -> () = { }

    var body: some View
    {
        ZStack(alignment: .leading)
        {
            if text.isEmpty {
                Text(placeholder).foregroundColor(theme.placeholderForeground)
            }
            
            TextField("", text: $text, onEditingChanged: onEditingChanged, onCommit: onCommit)
                .autocapitalization(.none)
                .disabled(disabled)
        }
    }
}

// [dho] TODO CLEANUP HACK adapted from : https://stackoverflow.com/a/59618704 - 19/02/21
extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}

func DismissKeyboard(){
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
}

