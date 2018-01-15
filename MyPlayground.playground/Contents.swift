//: A UIKit based Playground for presenting user interface

import UIKit
import XCPlayground
import PlaygroundSupport

struct TextData {
    static let texts: [[String]] = {
        return [
            [
                "be",
                "become",
                "break",
                "bring",
                "build",
                "buy",
                "choose",
                "catch",
                "come",
                "cut",
                "do",
                "drink",
                "drive",
                "eat",
                "fall",
                "feed",
                "feel",
                "find",
                "fly",
                "forget",
                "get",
                "give",
                "go",
                "have",
                "keep",
                "know",
                "learn",
                "lose",
                "make",
                "pay",
                "read",
                "ride",
                "see",
                "say",
                "sell",
                "send",
                "sit",
                "sleep",
                "speak",
                "spend",
                "steal",
                "take",
                "tell",
                "think",
                "wake (up)",
                "win",
                "write",
            ],
            [
                "was / were",
                "became",
                "broke",
                "brought",
                "built",
                "bought",
                "chose",
                "caught",
                "came",
                "cut",
                "did",
                "drank",
                "drove",
                "ate",
                "fell",
                "fed",
                "felt",
                "found",
                "flew",
                "forgot",
                "got",
                "gave",
                "went",
                "had",
                "kept",
                "knew",
                "learnt",
                "lost",
                "made",
                "paid",
                "read",
                "rode",
                "saw",
                "said",
                "sold",
                "sent",
                "sat",
                "slept",
                "spoke",
                "spent",
                "stole",
                "took",
                "told",
                "thought ",
                "woke up",
                "won",
                "wrote",
            ],
            [
                "been",
                "become",
                "broken",
                "brought",
                "built",
                "bought",
                "chosen",
                "caught",
                "come",
                "cut",
                "done",
                "drunk",
                "driven",
                "eaten",
                "fallen",
                "fed",
                "felt",
                "found",
                "flown",
                "forgotten",
                "got",
                "given",
                "gone",
                "had",
                "kept",
                "known",
                "learnt",
                "lost",
                "made",
                "paid",
                "read",
                "ridden",
                "seen",
                "said",
                "sold",
                "sent",
                "sat",
                "slept",
                "spoken",
                "spent",
                "stolen",
                "taken",
                "told",
                "thought",
                "woken up",
                "won",
                "written",
            ],
            [
                "být",
                "stát se\n(něčím)",
                "zlomit",
                "přinést,\npřivést",
                "vybudovat",
                "koupit (si)",
                "moci",
                "chytit",
                "přijít",
                "sekat,\nkrájet",
                "udělat",
                "pít",
                "řídit, jet",
                "jíst",
                "spadnout",
                "krmit",
                "cítit",
                "najít",
                "letět, létat",
                "zapomenout",
                "dostat",
                "dát",
                "jít",
                "mít",
                "nechat si,\nchovat",
                "vědět, znát",
                "naučit se",
                "ztratit",
                "vytvořit",
                "(za)platit",
                "číst",
                "jezdit, řídit",
                "vidět",
                "říci",
                "prodat",
                "poslat",
                "sednout si, sedět",
                "spát",
                "mluvit",
                "trávit\n(čas, peníze)",
                "ukrást",
                "vzít",
                "říci\n(někomu)",
                "myslet",
                "probudit\n(se)",
                "vyhrát",
                "psát",
            ]
        ]
    }()
}

class MyViewController: UIViewController {

    var numberOfColumns: Int {
        return TextData.texts.count
    }
    var numberOfParts: Int {
        return TextData.texts.first?.count ?? 0
    }
    let innerAreaRadius: CGFloat = 300
    let outerAreaRadius: CGFloat = 40
    lazy var angleStep: CGFloat = {
        return 360 / CGFloat(numberOfParts)
    }()
    let radius: CGFloat = 1000
    var size: CGSize {
        return CGSize(width: radius * 2, height: radius * 2)
    }
    var rect: CGRect {
        return CGRect(origin: .zero, size: size)
    }
    lazy var center: CGPoint = {
        return CGPoint(x: radius, y: radius)
    }()
    lazy var columnWidth: CGFloat = {
        return (radius - outerAreaRadius - innerAreaRadius) / CGFloat(numberOfColumns)
    }()

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let image = makeImage()
        let label = UIImageView(image: image)
        label.contentMode = .scaleAspectFit

        view.addSubview(label)
        view.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: label.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        self.view = view

        save(image, with: "bottom")
        let topImage = makeTop()
        save(topImage, with: "top")
    }

    private func save(_ image: UIImage, with name: String) {
        let path = XCPlaygroundSharedDataDirectoryURL.appendingPathComponent("\(name).png")!
        let data = UIImagePNGRepresentation(image)
        do {
            try data?.write(to: path)
        } catch {
            print(error)
        }
    }

    private func makeTop() -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }

        UIGraphicsBeginImageContext(size)
        drawPeriphery()
        drawCircle(radius: radius - outerAreaRadius)

        for index in 0 ..< numberOfColumns {
            drawCircle(radius: makeRadius(for: index))
        }

        drawLineFromCenter(to: makePoint(for: CGFloat(0) * angleStep))
        drawLineFromCenter(to: makePoint(for: CGFloat(numberOfParts - 1) * angleStep))

        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    private func makeImage() -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }

        UIGraphicsBeginImageContext(size)
        drawPeriphery()
        drawCircle(radius: radius - outerAreaRadius)

        for index in 0 ..< numberOfColumns {
            drawCircle(radius: makeRadius(for: index))
        }

        drawSeparators()
        drawLabels()
        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    private func makeRadius(for index: Int) -> CGFloat {
        return innerAreaRadius + columnWidth * CGFloat(index)
    }

    private func drawCircle(radius: CGFloat) {
        let delta = self.radius - radius
        let origin = CGPoint(x: delta, y: delta)
        let size = CGSize(width: radius * 2, height: radius * 2)
        let rect = CGRect(origin: origin, size: size)
        let path = UIBezierPath(ovalIn: rect)
        UIColor.black.setStroke()
        path.stroke()
    }

    private func drawPeriphery() {
        drawCircle(radius: radius)
    }

    private func drawSeparators() {
        for index in 0 ..< numberOfParts {
            let point = makePoint(for: CGFloat(index) * angleStep)
            drawLineFromCenter(to: point)
        }
    }

    private func drawLineFromCenter(to point: CGPoint) {
        let plusPath = UIBezierPath()
        plusPath.lineWidth = 2
        plusPath.move(to: center)

        plusPath.addLine(to: point)
        UIColor.black.setStroke()
        plusPath.stroke()
    }

    private func drawLabels() {
        for column in 0 ..< numberOfColumns {
            for index in 0 ..< numberOfParts {
                let delta = makeRadius(for: column)
                let text = TextData.texts[column][index]
                drawLabel(text: text, angle: CGFloat(index) * angleStep + angleStep / 2, delta: delta)
            }
        }
    }

    private func drawLabel(text: String, angle: CGFloat, delta: CGFloat) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.saveGState()
        context.translateBy(x: radius, y: radius)

        context.rotate(by: makeRadians(from: angle))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attributes = [
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30),
            NSAttributedStringKey.foregroundColor: UIColor.black,
        ]

        let attrString = NSAttributedString(string: text, attributes: attributes)
        var linesCount = 0
        attrString.string.enumerateLines { (_, _) in
            linesCount += 1
        }
        let y = linesCount == 1 ? -16 : -32
        let origin = CGPoint(x: delta, y: CGFloat(y))
        let rect = CGRect(origin: origin, size: CGSize(width: columnWidth, height: 100))
        attrString.draw(in: rect)
        drawOrigin()
        context.restoreGState()
    }

    private func makePoint(for angle: CGFloat) -> CGPoint {
        let radians = makeRadians(from: angle + 90)
        let x = sin(radians) * radius + radius
        let y = cos(radians) * radius + radius
        return CGPoint(x: x, y: y)
    }

    private func drawOrigin() {
        let plusPath = UIBezierPath()
        plusPath.lineWidth = 2
        plusPath.move(to: CGPoint(x: -25, y: 0))
        plusPath.addLine(to: CGPoint(x: 25, y: 0))
        UIColor.red.setStroke()
        plusPath.stroke()

        let plusPath2 = UIBezierPath()
        plusPath2.lineWidth = 2
        plusPath2.move(to: CGPoint(x: 0, y: -25))
        plusPath2.addLine(to: CGPoint(x: 0, y: 25))
        UIColor.blue.setStroke()
        plusPath2.stroke()
    }

    private func makeRadians(from degree: CGFloat) -> CGFloat {
        return degree * CGFloat(Double.pi / 180.0)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
