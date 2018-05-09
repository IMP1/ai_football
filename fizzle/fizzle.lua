--[[

TODO:
  - Add statements for mofdifying game state (kick ball, run, tackle, etc.)
  - Add expressions for querying game state (position of X, veloctiy of Y, pitch properties, etc.)

  - Separate the language specifications from "physical" components?
    The former shouldn't care about its size or location. The latter defo should.
    The latter could just be graphical data, and a reference to the language object.

--]]

local lang = require 'lang'
local gui  = require 'gui'

local fizzle = {}

fizzle = lang -- @TODO: when gui is implemeted, have this be some useful library for managing fizzle.

return fizzle