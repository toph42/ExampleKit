# In-App Libraries for Swift Playgrounds

Since the addition of App projects in **Swift Playgrounds 4** it’s been easy to use libraries in Swift packages hosted online in your Apps, but it hasn’t been easy or clear how to *create* libraries for reuse using **Swift Playgrounds**.

## Template

I have created this project as a template for how to have a project in **Swift Playgrounds** which allows you to develop and test out your library. In order for you to publish the library you’ll need to have somewhere online you can post the completed Swift Package. [GitHub](https://github.com) is the most obvious option, and the option I will be assuming for the purposes of these instructions.

## Source Control

Utilizing Source Control for your Swift Playgrounds project is simple with [Working Copy](https://workingcopy.app) by Anders  Borum. (You will need to upgrade to Pro to be able to use it for your Playgrounds, but it is absolutely worth it.) Just tap the ➕ above the **Repository** list and select **Link external directory 🔗** then browse to your Playground in the **Files** browser (usually in the Playgrounds folder on **iCloud Drive**, but if you are using my template it will be wherever you saved it). 
> **Note**: It will look like you cannot select the Playground file. What you have to do is **Get Info** on the Playground by doing a tap-and-hold to get the context menu and then selecting **Get Info** from it. Once you have the info open, just tap the large file icon at the top of the info screen in order to select the project and create the Repository.

Once you have a Repository in Working Copy it makes things quite a bit easier, as there are some things you cannot edit in **Swift Playgrounds** that must be edited to publish your library.

## Converting an Existing App Playground

While you could just copy my template and make a few changes to make it your own, you can also follow some simple*ish* instructions to convert your own current **Swift Playgrounds** App into one with an internal library module.

### Editing the Structure

While the basic structure of a **Swift Playgrounds** app is close to what’s needed, it’s not quite right. At the top level of the `.swiftpm` folder (that’s what a Playground is, actually a folder that the system pretends is a file) is the `Package.swift` file that defines what your package produces.

#### The Package Manifest (Package.swift) File

The default version creates a single `product` (a `PackageDescription.Product` created from the `iOSApplication(name:targets:bundleIdentifier:teamIdentifier:displayVersion:bundleVersion:iconAssetName:accentColorAssetName:supportedDeviceFamilies:supportedInterfaceOrientation:capabilities:additionalInfoPlistContentFilePath:)` static function.

It also has a single `target` (an `.executableTarget` representing the product mentioned above). In order to publish your library, we will need to add both a `product` for it and a `target` for it. The `product` should be created from the `.library(name:type:targets:)` static function and the `target` from the `target(name:dependencies:path:exclude:sources:publicHeadersPath:)` static function (usually just the `name` should be required).

> **Note**: If you change the name of the `AppModule` to target something else (so there won’t be a duplicate target) then you may use the package with the combined `Package.swift` file to link to the library from a Swift Playground App project. I prefer to publish it without the `iOSApplication` product or `AppModule` target, because otherwise the (usually pointless) application code is downloaded into any projects that depend on your package. See the **Publishing the Library** section below for more info on how to do configure your package for publishing.

#### Sources Folder

The convention of Swift Packages is for each target to have its own folder inside the top-level **Sources** folder. The default **Swift Playground** structure does not create the **Sources** folder. You will need to create the **Sources** folder and two folders inside, one named to match the name of the executable target (the default `AppModule`, or whatever new name you used if you changed it to avoid conflicts) and the other with a name that matches what you used for your library’s target.

### Using the Combined App

You can begin using the restructured app to develop your library. You will find that your App code is in a folder with a name that matches the name of your `executableTarget` and your Library code is in a folder matching the name of your `library` target’s name.

#### Protection Levels

You are used to everything being in the same module in **Swift Playgrounds** so the default protection level of `internal` does not hamper your use of types and methods defined in other parts of your module. Now that your library and your app code are separate targets, `internal` will be a hinderance to your code (acting like `private` to any code outside your library). You *must* add `public` to any types and methods you define in the library code that is meant to be accessible by “client code” such as your `iOSApplication` product’s code.

## Publishing the Library

In order for your library to be able to be added to other **Swift Playgrounds** App projects there are a few requirements:
1. Your project must be tagged as a release. You can do that on GitHub or you can [add a tag](https://workingcopy.app/manual/tagging) when you commit in Working Copy before you push to GitHub.
2. Your project must be available without logging in. This means that it either needs to be a Public repository on GitHub or you need to [use a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) (PAT) to access it.
> **Note**: Your PAT will be recorded into the `Package.swift` file if you have to go that route, so do *not* distribute any project that depends on your library while it is private (or create a fine-grained PAT that is very specific to only reading that one repository).
3. The `Package.swift` file must be configured to have the `.library` product and `.target` target for it. In order to create a `Package.swift` file that has both products and still works to import into a **Swift Playgrounds** app project, you *must* change the name for the `.executableTarget` to something that’s not `AppModule` (making sure to change the name where it is referenced in the `.iOSApplication` product and to change the name of the directory in `Sources` to match the new name).

### Tagging

If you are using GitHub you can tag your release by using the **Releases** section and create a new release. You need to tag using semantic versioning. Your tag should look like `x.y.z` where `x`, `y`, and `z` are integers and are incremented when you have a new major version (*i.e.* existing functionality changed from the prior version), a new minor version (*i.e.* you are only adding new functionality and existing code that uses your library should not need to be changed), or a new bug fix release (*i.e.* you’re just fixing bugs or tweaking things that are not breaking or adding any significant new functionality), respectively.

### Visibility

If your GitHub repository is Private, you can create a personal access token that you can put into the URL you use inside **Swift Playgrounds** to import your library into an App Playground. It is definitely much easier to simply use a Public repository. If that’s not an option for you, follow [the instructions on GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) on how to setup a PAT.
> **Note**: I have only gotten this to work with fine-grained PATs rather than classic ones.

### Required Changes to Package Manifest

The `Package.swift` file needs to have the product and target for your library that was added, but needs to NOT have a  `AppModule` target. You can either remove the `AppModule` target (and the `iOSApplication` product that references it) or you can change the name of the `AppModule` target (and all references to it, including the directory in `Sources` with all your application’s code). **Important**: If your Package.swift includes the `AppModule` then **Swift Playgrounds** will not let you add that package as a dependency because it conflicts with the `AppModule` target of the app in which you’re trying to add it.

```swift
// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "Example",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .library(
            name: "ExampleKit",
            targets: ["ExampleKit"]
        )  
    ],
    targets: [ 
        .target(
            name: "ExampleKit",
            dependencies: []
        )
    ]
)
```

### Updating Your Library

What I am doing with my libraries I’ve configured like this is having a `main` branch in my repository where I can open up in **Swift Playgrounds** to develop and test the library code and then when ready to deploy I take it to another branch (`releases`) where I delete the non-library code, create a new semantic versioning tag and commit and push the commit to GitHub, and then finally merge the branch back into `main`. 

## Using Your Published Library

You can add your published library as a dependency to a **Swift Playgrounds** App Playground by tapping the ➕ and selecting **Swift Package** from the menu. Put in the URL to your library (you may use my example as a test: https://github.com/toph42/ExampleKit). If you created a PAT to use for a Private repository on GitHub it goes after the two slashes and you put your GitHub userid and a colon before it and an @ sign after, so for example if I had a PAT that was `github_pat_1234ABCD` I would use https://toph42:github_pat_1234ABCD@github.com/toph42/ExampleKit to reach my `ExampleKit` repository if it were Private.

Whenever you update your published library, you can go into your App Playground that depends on it and long-press on the **Packages** section of the list on the side and select **Update All Package Dependencies** to get the updated version into your app.
> **Note**: If your new release is a new major version (*e.g.* from 1.0.0 to 2.0.0) this will *not* get your new version. In order to get the newer version you need to either remove the dependency (long-press the library name) and add it back, or you need to edit the `Package.swift` of your App’s package to modify the dependency.

*[PAT]:personal access token
