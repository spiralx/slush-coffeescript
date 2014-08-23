
fs = require "fs"
path = require "path"


# ----------------------------------------------------------------------------

__workingDirName = path.basename process.cwd()

if process.platform is "win32"
  __homeDir = process.env.USERPROFILE
  __userName = process.env.USERNAME
else
  __homeDir = process.env.HOME or process.env.HOMEPATH
  __userName = __homeDir and path.basename(__homeDir).toLowerCase()

__configFile = path.join __homeDir, ".gitconfig"

if fs.existsSync __configFile
  user = require "iniparser"
    .parseSync __configFile
    .user

user ?= {}
user.name = user.name or __userName


# ----------------------------------------------------------------------------

module.exports = [
  {
    name: "app_name"
    message: "What is the app name?"
    default: __workingDirName
  }
  {
    name: "app_description"
    message: "What is the description?"
  }
  {
    name: "app_version"
    message: "What is the module version?"
    default: "0.0.1"
  }
  {
    name: "author_name"
    message: "What is the author name?"
    default: user.name
  }
  {
    name: "author_email"
    message: "What is the author email?"
    default: user.email
  }
  {
    name: "user_name"
    message: "What is the github username?"
    default: __userName.toLowerCase()
  }
  {
    name: "license"
    type: "list"
    message: "Choose your license type"
    choices: [
      "MIT"
      "BSD"
    ]
    default: "MIT"
  }
  {
    type: 'confirm'
    name: 'cli'
    message: 'Add bin script for CLI?'
    default: false
  }
  {
    name: 'bin_dir'
    message: 'Specify CLI directory?'
    default: 'bin'
    when: (ans) -> ans.cli
  }
  {
    type: 'confirm'
    name: 'compiled'
    message: 'Compile Coffeescript to JS?'
    default: false
  }
  {
    name: "source_dir"
    message: "Specify source directory?"
    default: "lib"
    when: (ans) -> !ans.compiled
  }
  {
    name: "source_dir"
    message: "Specify Coffeescript source directory?"
    default: "src"
    when: (ans) -> ans.compiled
  }
  {
    name: "build_dir"
    message: "Specify directory for compiled Javascipt library code?"
    default: "lib"
    when: (ans) -> ans.compiled
  }
  {
    name: "test_dir"
    message: "Specify test directory?"
    default: "test"
  }
  {
    type: 'confirm'
    name: '__continue'
    message: 'Continue?'
  }
]
