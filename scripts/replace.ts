import {
  OptionType,
  parseFlags,
} from "https://deno.land/x/cliffy@v0.17.2/flags/mod.ts";

const { flags, unknown: args } = parseFlags(Deno.args, {
  allowEmpty: true,
  flags: [
    {
      name: "help",
      aliases: ["h"],
      standalone: true,
    },
    {
      name: "previous",
      aliases: ["p"],
      type: OptionType.STRING,
    },
    {
      name: "new",
      aliases: ["n"],
      type: OptionType.STRING,
      optionalValue: true,
    },
  ],
});

if (flags.help) {
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

if (typeof flags.previous !== "string") {
  console.error("Missing `previous` option");
  Deno.exit(1);
}

if (typeof flags.new !== "string") {
  flags.new = "";
}

if (args.length === 0) {
  console.error("Missing files");
  Deno.exit(1);
}

for (const file of args) {
  if (typeof file !== "string") {
    console.error("Mismatching file name");
    Deno.exit(1);
  }

  let path = file.split("/");

  let filename = path[path.length - 1];
  filename = filename.replace(flags.previous, flags.new);

  if (filename !== path[path.length - 1]) {
    path[path.length - 1] = filename;
    Deno.renameSync(file, path.join("/"));
  }
}
