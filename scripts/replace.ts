import { parse } from "https://deno.land/std/flags/mod.ts";

const args = parse(Deno.args);

if (args.help || args.h) {
  console.log(
    [
      "Replace",
      "",
      "$ replace [options] [files]",
      "",
      "Options",
      "  -p, --previous  Text to match",
      "  -n, --new  Text to replace the matches",
    ].join("\n")
  );
  Deno.exit();
}

if (typeof args.p !== "string" && typeof args.previous !== "string") {
  console.error("Missing `previous` option");
  Deno.exit(1);
}

if (typeof args.n !== "string" && typeof args.new !== "string") {
  console.error("Missing `new` option");
  Deno.exit(1);
}

if (typeof args._ !== "object" || args._.length === 0) {
  console.error("Missing files");
  Deno.exit(1);
}

for (const file of args._) {
  if (typeof file !== "string") {
    console.error("Mismatching file name");
    Deno.exit(1);
  }

  let path = file.split("/");

  let filename = path[path.length - 1];
  filename = filename.replace(args.p || args.previous, args.n || args.new);

  if (filename !== path[path.length - 1]) {
    path[path.length - 1] = filename;
    Deno.renameSync(file, path.join("/"));
  }
}
