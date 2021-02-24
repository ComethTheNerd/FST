import SwiftUI

class FSTThumbnailProvider : ObservableObject
{    
    @Published
    var loading : Bool = false;
    
    @Published
    var image   : UIImage?
    
    @Published
    var error   : FSTError?

    
    func load(from url : URL)
    {
        loading = true

        DispatchQueue.global(qos: .background).async
        { [weak self] in
            
            guard let self = self else { return }
            
            FetchImage(from: url, completion: self.fetchImageResultHandler)
        }
    }
    
    private func fetchImageResultHandler(result : FSTFetchImageResult)
    {
        if let task = result.task, task.state != .completed {
            return
        }
  
        var newImage : UIImage? = nil
        
        if let downloadedImage = result.image {
            newImage = ensureSquareImage(downloadedImage)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.image   = newImage
            self.error   = result.error;
            self.loading = false
        }
    }
    
    
    private func ensureSquareImage(_ image: UIImage) -> UIImage {
        if image.size.width == image.size.height {
            return image
        }
        else
        {
            return cropToBounds(image: image)
        }
    }

    // [dho] adapted from : https://stackoverflow.com/a/32041649 - 18/02/21
    private func cropToBounds(image: UIImage) -> UIImage {

        let width = image.size.width;
        let height = image.size.height;

        let cgImage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgImage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgWidth: CGFloat = CGFloat(width)
        var cgHeight: CGFloat = CGFloat(height)

        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgWidth = contextSize.height
            cgHeight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgWidth = contextSize.width
            cgHeight = contextSize.width
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cgWidth, height: cgHeight)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgImage.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

        return image
    }
}
