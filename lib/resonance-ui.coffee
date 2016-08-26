{CompositeDisposable} = require 'atom'
{TextEditor} = require 'atom'
Options = require './options'

module.exports =

  treeView: null

  config:
    colors:
      title: 'Colors'
      type: 'object'
      properties:
        theme:
          title: 'Theme color'
          type: 'string'
          default: '#a0b4cc'
        text:
          title: 'Text base color'
          type: 'string'
          default: '#bdae93'
        inactiveTabColor:
          title: 'Inactive tab color'
          description: 'light: #343b43 dark: #202429 very dark: #181b1f'
          type: 'string'
          default: '#343b43'
        indentGuide:
          title: 'Indent guide color'
          type: 'string'
          default: '#2d3239'
        invisibles:
          title: 'Invisibles color'
          type: 'string'
          default: '#2d3239'
        gutter:
          title: 'Gutter text color'
          type: 'string'
          default: '#4d4b46'
        gutterCursorEmph:
          title: 'Gutter cursor highlight in %'
          type: 'integer'
          minimum: 0
          maximum: 100
          default: 12

    treeView:
      title: 'Tree View'
      type: 'object'
      properties:
        hideInactiveFiles:
          title: 'Hide inactive files'
          description: 'Turns on/off diminishing the opacity of inactive files'
          type: 'boolean'
          default: true
        fontSize:
          title: 'Font size'
          type: 'integer'
          default: 12
        lineHeight:
          title: 'Line height'
          type: 'integer'
          default: 16
        ratioNoHover:
          title: 'Inactive opacity'
          description: 'Opacity of inactive files'
          type: 'number'
          minimum: 0.0
          maximum: 1.0
          default: 0.3
        ratioHover:
          title: 'Inactive opacity on mouse hover'
          description: 'Opacity of inactive files while browsing tree view'
          type: 'number'
          minimum: 0.0
          maximum: 1.0
          default: 0.6

    tabs:
      title: 'Tabs'
      type: 'object'
      properties:
        tabHeight:
          title: 'Tab height'
          type: 'integer'
          default: 28

    others:
      title: 'Others'
      type: 'object'
      properties:
        patchFileIcons:
          title: 'Patch file-icons package'
          description: 'Be careful: it will break the theme if file-icons package is not previously installed.\n' +
                       'In such a case you have to remove \'@import "file-icons";\' line from styles/custom-settings.less'
          type: 'boolean'
          default: false

  activate: (state) ->
    markOpen = (textEditor) =>
      filePath = textEditor.getPath()
      entry = @treeView.entryForPath filePath
      if entry
        entry.classList.add 'open'
      else
        console.log "Resonance-UI: Add: Not found entry for ", filePath

    removeOpen = (textEditor) =>
      filePath = textEditor.getPath()
      entry = @treeView.entryForPath filePath
      if entry
        entry.classList.remove 'open'
      else
        console.log "Resonance-UI: Remove: Not found entry for ", filePath

    treeListAddOpen = (event) =>
      console.log "Resonance-UI: treeListAddOpen", @treeView
      if @treeView
        markOpen event.textEditor

    treeListAddOpenForCurrent = (event) =>
      textEditor = atom.workspace.getActiveTextEditor()
      console.log "Resonance-UI: treeListAddOpenForCurrent", @treeView
      if textEditor and @treeView
        markOpen textEditor

    treeListRemoveOpen = (event) =>
      console.log "Resonance-UI: treeListRemoveOpen", @treeView
      if @treeView and event.item instanceof TextEditor
        closingEditor = event.item
        closingFilePath = closingEditor.getPath()
        editors = atom.workspace.getTextEditors()
        for i in [0...editors.length]
          if editors[i].getPath() == closingFilePath
            return
        removeOpen closingEditor

    treeListUpdateOpen = () =>
      if @treeView
        editors = atom.workspace.getTextEditors()
        for i in [0...editors.length]
          filePath = editors[i].getPath()
          entry = @treeView.entryForPath filePath
          if entry
            entry.classList.add 'open'

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.workspace.onDidAddTextEditor treeListAddOpen
    @subscriptions.add atom.workspace.onDidDestroyPaneItem treeListRemoveOpen
    @subscriptions.add atom.workspace.onDidChangeActivePane treeListAddOpenForCurrent
    @subscriptions.add atom.project.onDidChangePaths treeListUpdateOpen

    atom.packages.activatePackage('tree-view').then (treeViewPkg) =>
      console.log "Resonance-UI: activatePackage tree-view"
      @treeView = treeViewPkg.mainModule.createView()
      treeListUpdateOpen()
      @treeView.on 'click', '.directory', () ->
        treeListUpdateOpen()
    Options.apply()

  deactivate: () ->
    @subscriptions.dispose()
