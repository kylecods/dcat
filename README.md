## dcat 

A program similar to **cat** in linux that reads files on the console. It is written in dart. It is based on the tutorial found [here](https://dart.dev/tutorials/server/cmdline#overview-of-the-dcat-app-code) on the dart.dev website.

#### Planned extra features:

- [ ] Allow file creation
- [X] Add syntax highlight support.

#### Running the application

To run the program to show line numbers:

```bash
dcat --showLine hello.dart
```
or
```bash
dcat -s hello.dart
```
To run the program with syntax highlighting support:

```bash
dcat --showHighlight hello.dart
```
or
```bash
dcat -l hello.dart
```

Without line numbers
```bash
dcat hello.dart
```

