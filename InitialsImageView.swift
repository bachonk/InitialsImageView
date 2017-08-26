//
//  InitialsImageView.swift
//  
//
//  Created by Tom Bachant on 1/28/17.
//
//

import UIKit

let kFontResizingProportion: CGFloat = 0.4
let kColorMinComponent: Int = 30
let kColorMaxComponent: Int = 214

public typealias GradientColors = (top: UIColor, bottom: UIColor)

typealias GradientOffset = (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat)
let kGradientTopOffset: GradientOffset = (hue: -0.025, saturation: 0.05, brightness: 0, alpha: 0)
let kGradientBotomOffset: GradientOffset = (hue: 0.025, saturation: -0.05, brightness: 0, alpha: 0)

extension UIImageView {
    
    public func setImageForName(string: String, backgroundColor: UIColor? = nil, circular: Bool, textAttributes: [String: AnyObject]?, gradient: Bool = false) {
        
        setImageForName(string: string, backgroundColor: backgroundColor, circular: circular, textAttributes: textAttributes, gradient: gradient, gradientColors: nil)
    }
    
    public func setImageForName(string: String, gradientColors: GradientColors, circular: Bool, textAttributes: [String: AnyObject]?) {
        
        setImageForName(string: string, backgroundColor: nil, circular: circular, textAttributes: textAttributes, gradient: true, gradientColors: gradientColors)
    }
    
    private func setImageForName(string: String, backgroundColor: UIColor?, circular: Bool, textAttributes: [String: AnyObject]?, gradient: Bool = false, gradientColors: GradientColors?) {
        
        let initials: String = initialsFromString(string: string)
        let color: UIColor = (backgroundColor != nil) ? backgroundColor! : randomColor(for: string)
        let gradientColors = gradientColors ?? twoColors(from: color)
        let attributes: [String: AnyObject] = (textAttributes != nil) ? textAttributes! : [
            NSFontAttributeName: self.fontForFontName(name: nil),
            NSForegroundColorAttributeName: UIColor.white
        ]
        
        self.image = imageSnapshot(text: initials, backgroundColor: color, circular: circular, textAttributes: attributes, gradient: gradient, gradientColors: gradientColors)
    }
    
    private func fontForFontName(name: String?) -> UIFont {
        
        let fontSize = self.bounds.width * kFontResizingProportion;
        if name != nil {
            return UIFont(name: name!, size: fontSize)!
        }
        else {
            return UIFont.systemFont(ofSize: fontSize)
        }
        
    }
    
    private func imageSnapshot(text imageText: String, backgroundColor: UIColor, circular: Bool, textAttributes: [String : AnyObject], gradient: Bool, gradientColors: GradientColors) -> UIImage {
        
        let scale: CGFloat = UIScreen.main.scale
        
        var size: CGSize = self.bounds.size
        if (self.contentMode == .scaleToFill ||
            self.contentMode == .scaleAspectFill ||
            self.contentMode == .scaleAspectFit ||
            self.contentMode == .redraw) {
            
            size.width = (size.width * scale) / scale
            size.height = (size.height * scale) / scale
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        if circular {
            // Clip context to a circle
            let path: CGPath = CGPath(ellipseIn: self.bounds, transform: nil)
            context.addPath(path)
            context.clip()
        }
        
        if gradient {
            // Draw a gradient from the top to the bottom
            let baseSpace = CGColorSpaceCreateDeviceRGB()
            let colors = [gradientColors.top.cgColor, gradientColors.bottom.cgColor]
            let gradient = CGGradient(colorsSpace: baseSpace, colors: colors as CFArray, locations: nil)!
            
            let startPoint = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
            let endPoint = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
            
            context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        } else {
            // Fill background of context
            context.setFillColor(backgroundColor.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        // Draw text in the context
        let textSize: CGSize = imageText.size(attributes: textAttributes)
        let bounds: CGRect = self.bounds
        
        imageText.draw(in: CGRect(x: bounds.midX - textSize.width / 2,
                                  y: bounds.midY - textSize.height / 2,
                                  width: textSize.width,
                                  height: textSize.height),
                       withAttributes: textAttributes)
        
        let snapshot: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return snapshot;
    }
}

private func initialsFromString(string: String) -> String {
    
    var displayString: String = ""
    var words: [String] = string.components(separatedBy: .whitespacesAndNewlines)
    
    // Get first letter of the first and last word
    if words.count > 0 {
        let firstWord: String = words.first!
        if firstWord.characters.count > 0 {
            // Get character range to handle emoji (emojis consist of 2 characters in sequence)
            let range: Range<String.Index> = firstWord.startIndex..<firstWord.index(firstWord.startIndex, offsetBy: 1)
            let firstLetterRange: Range = firstWord.rangeOfComposedCharacterSequences(for: range)
            
            displayString.append(firstWord.substring(with: firstLetterRange).uppercased())
        }
        
        if words.count >= 2 {
            var lastWord: String = words.last!
            
            while lastWord.characters.count == 0 && words.count >= 2 {
                words.removeLast()
                lastWord = words.last!
            }
            
            if words.count > 1 {
                // Get character range to handle emoji (emojis consist of 2 characters in sequence)
                let range: Range<String.Index> = lastWord.startIndex..<lastWord.index(lastWord.startIndex, offsetBy: 1)
                let lastLetterRange: Range = lastWord.rangeOfComposedCharacterSequences(for: range)
                
                displayString.append(lastWord.substring(with: lastLetterRange).uppercased())
            }
        }
    }
    
    return displayString
}

private func randomColorComponent() -> Int {
    let limit = kColorMaxComponent - kColorMinComponent
    return kColorMinComponent + Int(drand48() * Double(limit))
}

private func randomColor(for string: String) -> UIColor {
    srand48(string.hashValue)

    let red = CGFloat(randomColorComponent()) / 255.0
    let green = CGFloat(randomColorComponent()) / 255.0
    let blue = CGFloat(randomColorComponent()) / 255.0
    
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}

private func clampColorComponent(_ value: CGFloat) -> CGFloat {
    return min(max(value, 0), 1)
}

private func correct(color: UIColor, with offset: GradientOffset) -> UIColor {
    
    var hue = CGFloat(0)
    var saturation = CGFloat(0)
    var brightness = CGFloat(0)
    var alpha = CGFloat(0)
    if color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
        hue = clampColorComponent(hue + offset.hue)
        saturation = clampColorComponent(saturation + offset.saturation)
        brightness = clampColorComponent(brightness + offset.brightness)
        alpha = clampColorComponent(alpha + offset.alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    return color
}

private func twoColors(from color: UIColor) -> GradientColors {
    let topColor = correct(color: color, with: kGradientTopOffset)
    let bottomColor = correct(color: color, with: kGradientBotomOffset)
    return (top: topColor, bottom: bottomColor)
}
