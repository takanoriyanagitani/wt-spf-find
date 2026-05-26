//@ts-expect-error
import { readFile } from "node:fs/promises";

(async () => {

  /** @type {string} */
  const wasm = "./find.wasm";

  const pbytes = readFile(wasm);
  const pwasm = pbytes.then(WebAssembly.instantiate);

  const { instance } = await pwasm;
  const { exports } = instance;
  const { find_spf, memory } = exports;

  const buf = await readFile("/dev/stdin");
  const bsz = buf.length;
  const view = new Uint8Array(memory.buffer, 0, bsz);
  view.set(buf);

  const rslt = find_spf(
    0,
    bsz-1,
  );

  if(rslt < 0) return;

  const oview = new Uint8Array(
    memory.buffer,
    rslt,
    13,
  );

  const dec = new TextDecoder();

  const decoded = dec.decode(oview);

  console.info(decoded);

})();
