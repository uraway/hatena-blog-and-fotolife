
HatenaBlogPost = require '../lib/hatena-blog-and-fotolife'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "HatenaBlogPost", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('hatena-blog-and-fotolife')

  describe "when the hatena-blog-and-fotolife:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.hatena-blog-and-fotolife')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'hatena-blog-and-fotolife:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.hatena-blog-and-fotolife')).toExist()
        atom.workspaceView.trigger 'hatena-blog-and-fotolife:toggle'
        expect(atom.workspaceView.find('.hatena-blog-and-fotolife')).not.toExist()
