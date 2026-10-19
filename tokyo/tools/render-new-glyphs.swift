import Foundation
import CoreGraphics
import CoreText
var glyphs = [String: [String]]()
for ch in "輪ゲートウェイ" {
    // Thin strokes keep the small counters in 輪 open at 28px.
    let font = CTFontCreateWithName((ch == "輪" ? "HiraginoSans-W2" : "HiraginoSans-W6") as CFString, 28, nil)
    var pixels = [UInt8](repeating: 255, count: 28*28)
    let context = CGContext(data: &pixels, width: 28, height: 28, bitsPerComponent: 8, bytesPerRow: 28, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGImageAlphaInfo.none.rawValue)!
    context.setFillColor(gray: 1, alpha: 1)
    context.fill(CGRect(x: 0, y: 0, width: 28, height: 28))
    context.setFillColor(gray: 0, alpha: 1)
    context.setShouldAntialias(false)
    let line = CTLineCreateWithAttributedString(NSAttributedString(string: String(ch), attributes: [NSAttributedString.Key(kCTFontAttributeName as String): font, NSAttributedString.Key(kCTForegroundColorFromContextAttributeName as String): true]))
    context.textPosition = CGPoint(x: 0, y: 3)
    CTLineDraw(line, context)
    if ch == "ー" {
        // Use the same long mark vertically in the vertical station name.
        let horizontal = pixels
        pixels = (0..<28*28).map { i in horizontal[(27 - i % 28)*28 + i / 28] }
    }
    glyphs[String(ch)] = (0..<28).map { y in String((0..<28).map { x in pixels[y*28+x] < 128 ? "#" : "." }) }
}
let data = try JSONSerialization.data(withJSONObject: glyphs, options: [.prettyPrinted, .sortedKeys])
FileHandle.standardOutput.write(data)
