--[[

TODO:
  - Add statements for mofdifying game state (kick ball, run, tackle, etc.)
  - Add expressions for querying game state (position of X, veloctiy of Y, pitch properties, etc.)

  - Separate the language specifications from "physical" components?
    The former shouldn't care about its size or location. The latter defo should.
    The latter could just be graphical data, and a reference to the language object.

--]]

local fizzle = {
    _VERSION     = 'v0.0.0',
    _DESCRIPTION = 'A Visual Programming Language, with GUI components for LÖVE.',
    _URL         = '',
    _LICENSE     = [[
        MIT License

        Copyright (c) 2018 Huw Taylor

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
    ]]
}

local lang = require 'lang'
local gui  = require 'gui'

-- @TODO: when gui is implemeted, have this be some useful library for managing fizzle.
--        and remove this for loop
for k, v in pairs(lang) do
    fizzle[k] = v
end

return fizzle