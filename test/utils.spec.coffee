
expect = require('chai').expect
utils = require '../lib/utils'


# -----------------------------------------------------------------------------

describe 'lib/utils.coffee', ->

  describe 'splitext()', ->

    it 'should get the right extension', (done) ->
      expect utils.splitext 'foo.html'
        .to.eql ['foo', '.html']
      expect utils.splitext 'foo.html.bak'
        .to.eql ['foo.html', '.bak']
      expect utils.splitext 'foo.html.'
        .to.eql ['foo.html', '.']
      expect utils.splitext 'foo'
        .to.eql ['foo', '']
      expect utils.splitext ''
        .to.eql ['', '']
      expect utils.splitext '.'
        .to.eql ['.', '']
      expect utils.splitext '..'
        .to.eql ['..', '']
      done()


  # ---------------------------------------------------------------------------

  describe 'applyRenames()', ->

    answers =
      app_name: 'my-lib'
      src_dir: 'src'
      id: 32

    it 'should work if no rename', (done) ->
      expect utils.applyRenames 'foo.html', answers
        .to.equal 'foo.html'
      expect utils.applyRenames 'foo.html'
        .to.equal 'foo.html'
      expect utils.applyRenames 'foo.id', answers
        .to.equal 'foo.id'
      expect utils.applyRenames '.src_dir.old', answers
        .to.equal '.src_dir.old'
      done()

    it 'should work when renaming', (done) ->
      expect utils.applyRenames 'app_name.html', answers
        .to.equal 'my-lib.html'
      expect utils.applyRenames 'id.txt', answers
        .to.equal '32.txt'
      done()


  # ---------------------------------------------------------------------------

  describe 'camelCase()', ->

    it 'should work', (done) ->
      expect utils.camelCase 'foo bar'
        .to.equal 'fooBar'
      expect utils.camelCase 'Foo Bar'
        .to.equal 'fooBar'
      expect utils.camelCase 'FnNumber12 bar'
        .to.equal 'fnNumber12Bar'
      expect utils.camelCase 'foo-bar'
        .to.equal 'fooBar'
      expect utils.camelCase 'foo_bar'
        .to.equal 'fooBar'
      expect utils.camelCase ' foo bar'
        .to.equal 'fooBar'
      expect utils.camelCase 'foobar'
        .to.equal 'foobar'

      done()


  # ---------------------------------------------------------------------------

  describe 'reduce()', ->
    sum = (a, b) -> a + b

    it 'should work with an initial value', (done) ->
      (expect utils.reduce [1..5], 0, sum).to.equal 15
      (expect utils.reduce [1..5], 5, sum).to.equal 20
      done()

    it 'should work without an initial value', (done) ->
      (expect utils.reduce [1..5], sum).to.equal 15
      done()


  # ---------------------------------------------------------------------------

  describe 'applyEach()', ->
    concat = (a, b) ->
      a.splice a.length, 0, b...
      return

    items1 = [
      [5, 9]
      [1]
    ]

    items2 = [
      [5, 9]
      [1]
      [10..13]
      ['a', 'v']
    ]

    target = [
      'moo'
    ]

    beforeEach (done) ->
      target = []
      done()

    it 'should return the target object', (done) ->
      expect utils.applyEach target, [1..5], concat
        .to.equal target
      done()

    it 'should do nothing to target with no parameters or an empty array', (done) ->
      expect utils.applyEach target, [], concat
        .to.equal target
        .and.to.eql target
      expect utils.applyEach target, concat
        .to.equal target
        .and.to.eql target
      done()

    it 'should apply the update function to the target and each item in turn', (done) ->
      expect utils.applyEach [], items1, concat
        .and.to.eql [ 5, 9, 1 ]
      expect utils.applyEach [], items2, concat
        .and.to.eql [ 5, 9, 1, 10, 11, 12, 13, 'a', 'v' ]
      done()



  # ---------------------------------------------------------------------------

  describe 'dict()', ->

    itemArray = [
      ['x', 6]
      ['y', 2]
      ['name', 'Ray-Ray']
    ]

    itemArray2 = [
      ['x', 6]
      ['y', 2]
      ['name', 'Ray-Ray']
      ['y', 2]
    ]

    itemObj =
      x: 6
      y: 2
      name: 'Ray-Ray'

    it 'should return a new object with no parameters or an empty array', (done) ->
      expect utils.dict()
        .to.be.an 'object'
        .and.to.eql {}
      expect utils.dict []
        .to.be.an 'object'
        .and.to.eql {}
      done()

    it 'should return the correct object', (done) ->
      expect utils.dict itemArray
        .to.be.an 'object'
        .to.eql itemObj
      expect utils.dict itemArray2
        .to.be.an 'object'
        .to.eql itemObj

      done()
