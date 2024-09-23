import ApolloCodegenLib
import ArgumentParser
import Foundation

@main struct AsyncMain: AsyncMainProtocol {
    typealias Command = SwiftScript
}

// An outer structure to hold all commands and sub-commands handled by this script.

@available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13, watchOS 6, *)
struct SwiftScript: ParsableCommand {

    static let projectRoot = "/Users/almaz5200/apollo_seg_rep"

    static let configuration = CommandConfiguration(
        abstract: """
            A swift-based utility for performing Apollo-related tasks.

            NOTE: If running from a compiled binary, prefix subcommands with `swift-script`. Otherwise use `swift run ApolloCodegen [subcommand]`.
            """,
        subcommands: [GenerateCode.self])

    /// The URL to the source root for your main project.
    /// Defaults to the folder containing the `ApolloCodgen` Package folder.
    ///
    /// NOTE: - You may need to change this if your project has a different structure
    /// than the suggested structure.
    static let SourceRootURL: URL = {
        let parentFolderOfScriptFile = URL(string: "\(Self.projectRoot)/")!
        let sourceRootURL =
            parentFolderOfScriptFile
        CodegenLogger.log("Source Root URL: \(sourceRootURL)")
        return sourceRootURL
    }()

    /// The sub-command to actually generate code.
    struct GenerateCode: AsyncParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "generate",
            abstract:
                "Generates swift code from your schema + your operations based on information set up in the `GenerateCode` command."
        )

        mutating func run() async throws {
            // TODO: Replace the placeholder here with the name of the folder containing your project's code files.
            /// The root of the target for which you want to generate code.
            let targetSchemaTypesURL =
                SourceRootURL
                .childFolderURL(folderName: "APITypes/Generated")
            let targetRootURL =
                SourceRootURL
                .childFolderURL(folderName: "NetworkService/Generated")

            // TODO: Replace the placeholder here with the name you would like to give your schema.
            /// The name of the module that will contain your generated schema objects.
            let generatedSchemaModuleName: String = "APITypes"

            // Make sure the folders exists before trying to generate code.

            // Create the Codegen configuration object. For all configuration parameters see: https://www.apollographql.com/docs/ios/api/ApolloCodegenLib/structs/ApolloCodegenConfiguration/
            let codegenConfiguration = ApolloCodegenConfiguration(
                schemaNamespace: generatedSchemaModuleName,
                input: ApolloCodegenConfiguration.FileInput(
                    schemaPath: "\(projectRoot)/schema.graphqls",
                    operationSearchPaths: [
                        "\(SourceRootURL.path)/Menu.graphql"
                    ]),
                output: ApolloCodegenConfiguration.FileOutput(
                    schemaTypes: ApolloCodegenConfiguration.SchemaTypesFileOutput(
                        path: targetSchemaTypesURL.path,
                        moduleType: .other
                    ),
                    operations: .relative(subpath: "../Generated/Operations/")
                ),
                options: .init(deprecatedEnumCases: .exclude)
            )

            // Actually attempt to generate code.
            try await ApolloCodegen.build(with: codegenConfiguration)
        }
    }

}
