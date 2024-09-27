import FigmaExportCore
import Foundation
import Stencil
import PathKit
import StencilSwiftKit

public class XcodeExporterBase {
    
    private let declarationKeywords = ["associatedtype", "class", "deinit", "enum", "extension", "fileprivate", "func", "import", "init", "inout", "internal", "let", "open", "operator", "private", "precedencegroup", "protocol", "public", "rethrows", "static", "struct", "subscript", "typealias", "var"]
    
    private let statementKeywords = ["break", "case", "catch", "continue", "default", "defer", "do", "else", "fallthrough", "for", "guard", "if", "in", "repeat", "return", "throw", "switch", "where", "while"]
    
    private let expressionsKeywords = ["Any", "as", "catch", "false", "is", "nil", "rethrows", "self", "Self", "super", "throw", "throws", "true", "try"]
    
    private let otherKeywords = ["associativity", "convenience", "didSet", "dynamic", "final", "get", "indirect", "infix", "lazy", "left", "mutating", "none", "nonmutating", "optional", "override", "postfix", "precedence", "prefix", "Protocol", "required", "right", "set", "some", "Type", "unowned", "weak", "willSet"]
    
    func normalizeName(_ name: String) -> String {
        let keyword = (declarationKeywords + statementKeywords + expressionsKeywords + otherKeywords).first { keyword in
            name == keyword
        }
        if let keyword {
            return "`\(keyword)`"
        } else {
            return name
        }
    }
    
    func makeEnvironment(templatesPath: URL?) -> Environment {
        let loader: Loader
        if let templateURL = templatesPath {
            loader = FileSystemLoader(paths: [Path(templateURL.path)])
        } else {
            loader = DictionaryLoader(
                templates: [
                    "Bundle+extension.swift.stencil.include": PackageResources.Bundle_extension_swift_stencil_include,
                    "Color+extension.swift.stencil": PackageResources.Color_extension_swift_stencil,
                    "Font+extension.swift.stencil": PackageResources.Font_extension_swift_stencil,
                    "header.stencil": PackageResources.header_stencil,
                    "Image+extension.swift.stencil": PackageResources.Image_extension_swift_stencil,
                    "Image+extension.swift.stencil.include": PackageResources.Image_extension_swift_stencil_include,
                    "Label.swift.stencil": PackageResources.Label_swift_stencil,
                    "LabelStyle.swift.stencil": PackageResources.LabelStyle_swift_stencil,
                    "LabelStyle+extension.swift.stencil": PackageResources.LabelStyle_extension_swift_stencil,
                    "UIColor+extension.swift.stencil": PackageResources.UIColor_extension_swift_stencil,
                    "UIFont+extension.swift.stencil": PackageResources.UIFont_extension_swift_stencil,
                    "UIImage+extension.swift.stencil": PackageResources.UIImage_extension_swift_stencil,
                    "UIImage+extension.swift.stencil.include": PackageResources.UIImage_extension_swift_stencil_include
                ].mapValues { value in
                    String(bytes: value, encoding: .utf8)!
                }
            )
        }
        let ext = Extension()
        ext.registerStencilSwiftExtensions()
        return Environment(loader: loader, extensions: [ext])
    }
    
    func makeFileContents(for string: String, url: URL) throws -> FileContents {
        let fileURL = URL(string: url.lastPathComponent)!
        let directoryURL = url.deletingLastPathComponent()

        return FileContents(
            destination: Destination(directory: directoryURL, file: fileURL),
            data: string.data(using: .utf8)!
        )
    }
    
    func makeFileContents(for string: String, directory: URL, file: URL) throws -> FileContents {
        FileContents(
            destination: Destination(directory: directory, file: file),
            data: string.data(using: .utf8)!
        )
    }
}
