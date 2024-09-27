import Stencil
import PathKit
import Foundation
import FigmaExportCore
import StencilSwiftKit

public class AndroidExporter {
    
    private let templatesPath: URL?
    
    init(templatesPath: URL?) {
        self.templatesPath = templatesPath
    }
    
    func makeEnvironment() -> Environment {
        let loader: Loader
        if let templateURL = templatesPath {
            loader = FileSystemLoader(paths: [Path(templateURL.path)])
        } else {
            loader = DictionaryLoader(
                templates: [
                    "Colors.kt.stencil": PackageResources.Colors_kt_stencil,
                    "colors.xml.stencil": PackageResources.colors_xml_stencil,
                    "header.stencil": PackageResources.header_stencil,
                    "Icons.kt.stencil": PackageResources.Icons_kt_stencil,
                    "Typography.kt.stencil": PackageResources.Typography_kt_stencil,
                    "typography.xml.stencil": PackageResources.typography_xml_stencil,
                ].mapValues({ value in
                    String(bytes: value, encoding: .utf8)!
                })
            )
        }
        let ext = Extension()
        ext.registerStencilSwiftExtensions()
        return Environment(loader: loader, extensions: [ext])
    }
    
    func makeFileContents(for string: String, directory: URL, file: URL) throws -> FileContents {
        FileContents(
            destination: Destination(directory: directory, file: file),
            data: string.data(using: .utf8)!
        )
    }
}
