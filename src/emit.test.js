const { GoEmitter } = require("./emit");

describe("GoEmitter", () => {
  const emitter = new GoEmitter();

  describe("emit_preface", () => {
    it("should emit a preface", () => {
      emitter.emit_preface({ infile: "./my_test_file.avdl" });
      const code = emitter._code.join("\n");
      expect(code)
        .toBe(`// Auto-generated by avdl-compiler v1.4.0 (https://github.com/keybase/node-avdl-compiler)
//   Input file: my_test_file.avdl
`);
    });
  });
});
