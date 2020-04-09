# AvatarChooser
A macOS application (both GUI and CLI) for choosing an avatar from a list of games

AvatarChooser has 1 use case -- help the user pick an avatar.

The project has 3 top-level directories.

- ChooseAvatarUseCase: A static library that encapsulates all objects needed to fulfill the use case **except** for a concrete implementation of the view.
- AvatarChooser: Contains concrete implmentations of view protocols defined in `ChooseAvatarUseCase` (ie. the CLI and GUI code)
- AvatarChooserTests: Integration and unit tests

The project is "packaged" by use case, but the use case itself is divided into the following layers -- presentation, data, application logic, enterprise logic. ChooseAvatarUseCase is packaged using a static library since command-line tools can't bundle frameworks.

The presentation layer of AvatarChooser uses the model-view-presenter (passive view) pattern. Doing so allows tests to cover presentation logic that would otherwise be too difficult to test.

## Intructions to Run Application

AvatarChooser will run the user through a series of steps that ultimately lead to a chosen avatar. When an avatar is chosen it will be downloaded to either a directory specified by the user (CLI) or `~/Downloads/Avatars/` (GUI). The directory will be created if it doesn't already exist.

### Command-Line Interface

If you are running the project from Xcode, make sure to edit your scheme so that the first argument is the download directory. The CLI expects the following format:

```
./avatar-chooser <path to downloads directory>
```

### AppKit GUI

- Just build and run!

## Alternatives Considered

### Presenter per concrete view instead of per abstract view

AvatarChooser's presenter have a 1-1 relationship with abstract views, so CLI and GUI will use the same presenter. This works for the most part, but this means that the CLI has some logic to validate the user input.

Ultimately, I think this is okay since pushing that logic into the presenter would make the presenter dependent on the view layer.

### Downloading Images in GUI

Since CLI has no UI for displaying images, it is imperative that images are downloaded to the user specified directory. However, when uses a GUI it can be argued those writes to disk are wasted.

In the end, I decided it was cleaner to have the business logic dictate when to download the images and do it all the time rather than the view be in charge and do it only some of the time -- since the end goal is to download the image anyways.

### Change downloaded image name

When inspecting the downloaded image names, some are very vague (ex. 1.jpg). One option would be to change the name of the download image to match the avatar name.

Instead I chose to list the image name along with the avatar name in the UI and keep the downloaded image name consistent with the backend.

## Known Issues

Since the timeline for this project was limited, I made tradeoffs that allocated more time to completing the requirements of the project at the sacrifice of security and error handling. These are not issues that I would ever ship code with, but given the circumstances for this project they were of lower priority.

### Error Handling

There is basically 0 error handling logic in AvatarChooser. This is a known issue and if any issues arise in the following places, the behavior is unknown.

- Response of network when fetching Avatars.json
- The communication between application and disk is fragile and assumes everything goes smoothly.

### Unit Tests

- Ideally the entire use case and it's error cases would be tested with integration tests
- The above error cases could be easily unit tested with more time

### Image Loading

- The logic around loading images in the GUI expects all images to be downloaded before the user changes avatar suggestions. This is actually what happens a majority of the time but ideally there would be some synconization to check if the `AvatarCollectionViewItem` has changed before setting the image on it.