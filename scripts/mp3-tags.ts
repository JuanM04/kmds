import {
  Input,
  prompt,
} from "https://deno.land/x/cliffy@v0.17.2/prompt/mod.ts";
import { exec, OutputMode } from "https://deno.land/x/exec@0.0.5/mod.ts";

if (Deno.args.length !== 1) {
  console.error("You have to select exactly one file");
  Deno.exit(1);
}

const file = Deno.args[0];

const whichEye = await exec("which eyeD3", { output: OutputMode.Capture });

if (whichEye.output.length === 0) {
  await exec("pip install eyeD3");
}

const result = await prompt([
  {
    name: "title",
    message: "Title",
    type: Input,
    default: file.split(" - ")?.[1].replace(".mp3", ""),
  },
  {
    name: "artist",
    message: "Artist(s)",
    type: Input,
    default: file.split(" - ")[0],
  },
  {
    name: "date",
    message: "Release date",
    type: Input,
  },
  {
    name: "albumName",
    message: "Album name",
    type: Input,
  },
  {
    name: "albumCover",
    message: "Album cover file",
    type: Input,
  },
]);

const checkFlag = (literal: TemplateStringsArray, str: string | undefined) => {
  if (typeof str !== "string") return false;
  str = str.trim();
  if (str.length === 0) return false;
  return literal.join(str).trim();
};

await exec(
  [
    "eyeD3",
    checkFlag`--title "${result.title}"`,
    checkFlag`--artist "${result.artist}"`,
    checkFlag`--release-year "${result.date}"`,
    checkFlag`--album "${result.albumName}"`,
    checkFlag`--add-image "${result.albumCover}:FRONT_COVER"`,
    `"${Deno.args[0]}"`,
  ]
    .filter(Boolean)
    .join(" ")
);
