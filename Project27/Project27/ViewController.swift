//
//  ViewController.swift
//  Project27
//
//  Created by Ashraf Dewan on 5/16/20.
//  Copyright © 2020 Ashraf Dewan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: UIButton) {
        currentDrawType += 1
        
        if currentDrawType > 8 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
            
        case 1:
            drawCircle()
            
        case 2:
            drawCheckerboard()
            
        case 3:
            drawRotatedSquares()
            
        case 4:
            drawLines()
        
        case 5:
            drawImagesAndText()
        //1
        case 6:
            drawEmoji()
            
        case 7:
            drawStar()
        //2
        case 8:
            drawTwinText()
        //
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0..<8 {
                for col in 0..<8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let mount = Double.pi / Double(rotations)
            
            for _ in 0..<rotations {
                ctx.cgContext.rotate(by: CGFloat(mount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0..<256 {
                ctx.cgContext.rotate(by: .pi / 2)

                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }

                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
    
        imageView.image = image
    }
    //1
    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let face = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.orange.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: face)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let LeftEye = CGRect(x: 128, y: 128, width: 72, height: 80).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.orange.cgColor)
            
            ctx.cgContext.addEllipse(in: LeftEye)
            ctx.cgContext.drawPath(using: .fill)
            
            let RightEye = CGRect(x: 312, y: 128, width: 72, height: 80).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.orange.cgColor)
            
            ctx.cgContext.addEllipse(in: RightEye)
            ctx.cgContext.drawPath(using: .fill)
            
            let mouth = CGRect(x: 184, y: 288, width: 144, height: 144).insetBy(dx: 5, dy: 5)

            ctx.cgContext.setFillColor(UIColor.orange.cgColor)

            ctx.cgContext.addEllipse(in: mouth)
            ctx.cgContext.drawPath(using: .fill)
        }
        
        imageView.image = image
    }
    
    func drawStar() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.move(to: CGPoint(x: 256, y: 0))
            ctx.cgContext.addLine(to: CGPoint(x: 320, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 512, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 352, y: 256))
            ctx.cgContext.addLine(to: CGPoint(x: 416, y: 512))
            ctx.cgContext.addLine(to: CGPoint(x: 256, y: 352))
            
            ctx.cgContext.addLine(to: CGPoint(x: 96, y: 512))
            ctx.cgContext.addLine(to: CGPoint(x: 160, y: 256))
            ctx.cgContext.addLine(to: CGPoint(x: 0, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 192, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 256, y: 0))
            
            ctx.cgContext.setStrokeColor(UIColor.orange.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    //2
    func drawTwinText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.move(to: CGPoint(x: 0, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 128, y: 192))
            ctx.cgContext.move(to: CGPoint(x: 64, y: 192))
            ctx.cgContext.addLine(to: CGPoint(x: 64, y: 320))
            
            ctx.cgContext.move(to: CGPoint(x: 144, y: 187))
            ctx.cgContext.addLine(to: CGPoint(x: 176, y: 310))
            ctx.cgContext.addLine(to: CGPoint(x: 208, y: 251))
            ctx.cgContext.addLine(to: CGPoint(x: 240, y: 310))
            ctx.cgContext.addLine(to: CGPoint(x: 272, y: 187))
            
            ctx.cgContext.move(to: CGPoint(x: 304, y: 187))
            ctx.cgContext.addLine(to: CGPoint(x: 304, y: 320))
            
            ctx.cgContext.move(to: CGPoint(x: 336, y: 320))
            ctx.cgContext.addLine(to: CGPoint(x: 336, y: 197))
            ctx.cgContext.addLine(to: CGPoint(x: 468, y: 310))
            ctx.cgContext.addLine(to: CGPoint(x: 468, y: 187))
            
            ctx.cgContext.setStrokeColor(UIColor.orange.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    //
}

