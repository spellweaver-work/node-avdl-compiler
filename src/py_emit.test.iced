{PythonEmitter} = require("./py_emit")
pkg             = require '../package.json'

describe "PythonEmitter", () ->
  emitter = null
  beforeEach () ->
    emitter = new PythonEmitter

  describe "emit_preface", () ->
    it "Should emit a preface", () ->
      emitter.emit_preface ["./my_test_file.avdl"], {namespace: "chat1"}
      code = emitter._code.join "\n"

      expect(code).toBe("""
      \"\"\"chat1

      Auto-generated to Python types by #{pkg.name} v#{pkg.version} (#{pkg.homepage})
      Input files:
       - my_test_file.avdl
      \"\"\"\n
      """)
      return
    return

  describe "emit_imports", () ->
    it "should output all imports used by the file", () ->
      imports = [
        {
          path: "../gregor1"
          type: "idl"
          import_as: "gregor1"
        },
        {
          path: "../keybase1"
          type: "idl",
          import_as: "keybase1"
        },
        {
          path: "common.avdl"
          type: "idl"
        },
        {
          path: "chat_ui.avdl"
          type: "idl"
        },
        {
          path: "unfurl.avdl"
          type: "idl"
        },
        {
          path: "commands.avdl"
          type: "idl"
        }
      ]
      emitter.emit_imports {imports}, "test/output/dir"
      code = emitter._code.join "\n"

      expect(code).toBe("""
        from dataclasses import dataclass
        from enum import Enum
        from typing import Dict, List, Optional, Union

        from mashumaro import DataClassJSONMixin

        from ..gregor1 import * as gregor1
        from ..keybase1 import * as keybase1\n
      """)
      return
    return

  describe "emit_typedef", () ->
    it "Should emit a string typedef", () ->
      type = {
        type: "record"
        name: "BuildPaymentID"
        fields: []
        typedef: "string"
      }
      emitter.emit_typedef type
      code = emitter._code.join "\n"

      expect(code).toBe("""
        BuildPaymentID = str
      """)
      return
    return

  describe "emit_fixed", () ->
    it "should emit a string", () ->
      emitter.emit_fixed { name: "FunHash", size: 32 }
      code = emitter._code.join "\n"

      expect(code).toBe("""
        FunHash = Optional[str]
      """)
      return
    return

  describe "emit_enum", () ->
    it "should emit an enum", () ->
      test_enum = {
        type: "enum",
        name: "AuditVersion",
        symbols: [
          "V0_0",
          "V1_1",
          "V2_2",
          "V3_3"
        ]
        "doc": "This is a docstring\nhi"
      }
      emitter.emit_enum test_enum
      code = emitter._code.join "\n"

      expect(code).toBe("""
        class AuditVersion(Enum):
            \"\"\"
            This is a docstring
            hi
            \"\"\"
            V0 = 'v0'
            V1 = 'v1'
            V2 = 'v2'
            V3 = 'v3'\n\n
      """)
      return
    return

  return
