
HatenaBlogPost = require '../lib/hatena-blog'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "HatenaBlogPost", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('hatena-blog-entry-post')

  describe "when the hatena-blog:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.hatena-blog')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'hatena-blog:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.hatena-blog')).toExist()
        atom.workspaceView.trigger 'hatena-blog:toggle'
        expect(atom.workspaceView.find('.hatena-blog')).not.toExist()
