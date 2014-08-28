'use strict'

path = require 'path'
fs = require 'fs'

us = require 'underscore.string'

prompts = require './prompts'


# ----------------------------------------------------------------------------

###
Functional version of Array.reduce

@param {Array} array
@param {Object?} base
@param {Function} combine
@return {Object}
###
reduce = exports.reduce = (array, base, combine) ->
  [base, combine] = [array.shift(), base] unless combine?
  array.reduce combine, base


# ----------------------------------------------------------------------------

# Similar to reduce(), but each element is used to update the target
# object in turn, which is then returned.
build = exports.build = (array, target, update) ->
  [target, update] = [array.shift(), target] unless update?
  update target, cur for cur in array
  target


# ----------------------------------------------------------------------------

splitext = exports.splitext = (fn) ->
  ext = path.extname fn
  [
    path.basename fn, ext
    ext
  ]


# ----------------------------------------------------------------------------

applyRenames = exports.applyRenames = (fn, answers) ->
  [name, ext] = splitext fn
  name = answers?[name] ? name
  name + ext


# ----------------------------------------------------------------------------

camelCase = exports.camelCase = (s) ->
  s = us.camelize s
  s[0].toLowerCase() + s.substr(1)


# ----------------------------------------------------------------------------

dict = exports.dict = (items...) ->
  reduce items, {}, (d, c) ->
    [k, v] = c
    d[k] = v
    d

