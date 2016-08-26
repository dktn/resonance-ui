# {CompositeDisposable} = require 'event-kit'
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
                gutterCursor:
                    title: 'Gutter text color for cursor'
                    type: 'string'
                    default: '#625c51'

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

    activate: (state) ->
        markOpen = (textEditor) =>
            filePath = textEditor.getPath()
            entry = @treeView.entryForPath filePath
            if entry
                entry.classList.add 'open'
            else
                console.log "Add: Not found entry for ", filePath

        removeOpen = (textEditor) =>
            filePath = textEditor.getPath()
            entry = @treeView.entryForPath(filePath)
            if entry
                entry.classList.remove 'open'
            else
                console.log "Remove: Not found entry for ", filePath

        treeListAddOpen = (event) =>
            console.log "treeListAddOpen", @treeView
            if @treeView
                markOpen event.textEditor

        treeListAddOpenForCurrent = (event) =>
            textEditor = atom.workspace.getActiveTextEditor()
            console.log "treeListAddOpenForCurrent", @treeView
            if textEditor and @treeView
                markOpen textEditor

        treeListRemoveOpen = (event) =>
            console.log "treeListRemoveOpen", @treeView
            if @treeView and event.item instanceof TextEditor
                removeOpen event.item

        treeListUpdateOpen = () =>
            editors = atom.workspace.getTextEditors()
            for i in [0...editors.length]
                editor = editors[i]
                if @treeView
                    filePath = editor.getPath()
                    entry = @treeView.entryForPath filePath
                    if entry
                        entry.classList.add 'open'

        @subscriptions = new CompositeDisposable
        @subscriptions.add atom.workspace.onDidAddTextEditor treeListAddOpen
        @subscriptions.add atom.workspace.onDidDestroyPaneItem treeListRemoveOpen
        @subscriptions.add atom.workspace.onDidChangeActivePane treeListAddOpenForCurrent

        atom.packages.activatePackage('tree-view').then (treeViewPkg) =>
            @treeView = treeViewPkg.mainModule.createView()
            treeListUpdateOpen()
            @treeView.on 'click', '.directory', () ->
                treeListUpdateOpen()
        Options.apply()

    deactivate: () ->
        @subscriptions.dispose()
