# Lumynity Studios - Maven
Maven for all projects made by or contributed to by [Lumynity Studios](https://modrinth.com/organization/lumynity-studios) and all its (team) members.

<hr>

# Where to Find The Projects?
All maven directories and artifacts can be found at https://maven.lumynitystudios.net/ <br>
The maven artifacts can be accessed and used by your own projects via, for example:
```kotlinscript
repositories {
    maven("https://maven.lumynitystudios.net/")
}

dependencies {
    // Minecraft before 26.1
    modImplementation("net.lumynitystudios:artifact_id:artifact_version")

    // Minecraft 26.1+
    implementation("net.lumynitystudios:artifact_id:artifact_version")
}
```

<hr>

# Tools in This Repository

### [GenMavenArtifacts.jar](https://github.com/Lumynity-Studios-Web/maven/blob/main/GenMavenArtifacts.jar)
Java application made by [JustMili](https://github.com/JustMili0) to manage and upload new content to the maven.

### [/gendata/](https://github.com/Lumynity-Studios-Web/maven/tree/main/gendata)
Directory holding all the information used by GenMavenArtifacts.<br>
Contains `settings.json` and `submavens.json`.

### [/gendata/settings.json](https://github.com/Lumynity-Studios-Web/maven/tree/main/gendata/settings.json)
Stores selected or default language settings for GenMavenArtifacts.

### [/gendata/submavens.json](https://github.com/Lumynity-Studios-Web/maven/tree/main/gendata/settings.json)
Holds all available submavens and assigned to them projects (artifacts); readable to GenMavenArtifacts to create submaven selection and project selection menus.

### [/gendata/autogenrate-simple.json](https://github.com/Lumynity-Studios-Web/maven/tree/main/gendata/)
A simple json file allowing to quickly autogenerate a new maven artifact without needing to go through all the menus and inputs of GenMavenArtifacts.

Example of use:
```json
{
  "submaven": "net.justmili",
  "artifact_id": "corelibs"
  "artifact_file": "MilliesCoreLibraries"
  "artifact_version": "0.0.2a+mc1.21.1-Fabric"
}
```
<small><em>*All project .JAR files to be added to the maven by GenMavenArtifacts must be located in `jars/artifact_id/`.</em></small>

### [/gendata/autogenrate-complex.json](https://github.com/Lumynity-Studios-Web/maven/tree/main/gendata/)
A json file allowing to quickly autogenerate multiple maven artifacts, for multiple submavens and projects at a time without needing to go through all the menus and inputs of GenMavenArtifacts for each file.

Example of use:
```json
{
  "net.justmili": {
    "left-forgotten": {
      "0": {
        "artifact_file": "LeftForgotten-1.1.3+mc1.20.1-Fabric",
        "artifact_version": "1.1.3+mc1.20.1-Fabric"
      },
      "1": {
        "artifact_file": "LeftForgotten-1.1.3+mc1.20.1-Forge",
        "artifact_version": "1.1.3+mc1.20.1-Forge"
      },
      "2": {
        "artifact_file": "LeftForgotten-1.1.3+mc1.21.1-Fabric",
        "artifact_version": "1.1.3+mc1.21.1-Fabric"
      },
      "3": {
        "artifact_file": "LeftForgotten-1.1.3+mc1.21.1-NeoForge",
        "artifact_version": "1.1.3+mc1.21.1-NeoForge"
      }
    }
  }

  "net.lumynitystudios": {
    "true-end": {
      "0": {
        "artifact_file": "TrueEnd-1.4.3+mc1.20.1-Forge"
        "artifact_version": "1.4.3+mc1.20.1-Forge"
    }
  }
}
```
<small><em>*All project .JAR files to be added to the maven by GenMavenArtifacts must be located in `jars/artifact_id/`.</em></small>

<hr>

# Other Files

### [generate.js](https://github.com/Lumynity-Studios-Web/maven/tree/main/generate.js)
JavaScript file executed by Github Actions bot to regenerate maven's html page files to display all new content.

<hr>

Everything else is just repository and github stuff not worth really mentioning

<hr>
