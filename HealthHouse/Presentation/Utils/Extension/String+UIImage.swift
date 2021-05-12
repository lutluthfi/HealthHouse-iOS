//
//  String+UIImage.swift
//  HealthHouse
//
//  Created by Arif Luthfiansyah on 12/04/21.
//

import UIKit

public struct StringImageProperties {
    
    public let color: UIColor
    public let scale: CGFloat
    public let size: CGFloat
    
}

public extension String {
    
    func image(properties: StringImageProperties) -> UIImage? {
        let outputImageSize = CGSize(width: properties.size, height: properties.size)
        let baseSize = self.boundingRect(with: CGSize(width: 2048, height: 2048),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [.font: UIFont.systemFont(ofSize: properties.size / 2)],
                                         context: nil).size
        let fontSize = outputImageSize.width / max(baseSize.width, baseSize.height) * (outputImageSize.width / 2)
        let font = UIFont.systemFont(ofSize: fontSize * properties.scale)
        let textSize = self.boundingRect(with: CGSize(width: outputImageSize.width, height: outputImageSize.height),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [.font: font], context: nil).size
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        style.lineBreakMode = NSLineBreakMode.byClipping
        
        let attr: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font,
                                                   NSAttributedString.Key.foregroundColor: properties.color,
                                                   NSAttributedString.Key.paragraphStyle: style,
                                                   NSAttributedString.Key.backgroundColor: UIColor.clear ]
        
        UIGraphicsBeginImageContextWithOptions(outputImageSize, false, 0)
        self.draw(in: CGRect(x: (properties.size - textSize.width) / 2,
                             y: (properties.size - textSize.height) / 2,
                             width: textSize.width,
                             height: textSize.height),
                  withAttributes: attr)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}

