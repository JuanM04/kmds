import { exec } from "https://deno.land/x/exec@0.0.5/mod.ts";
import { parseFlags } from "https://deno.land/x/cliffy@v0.17.2/flags/mod.ts";

async function packageHasTypes(pkg: string): Promise<boolean> {
  if (pkg.includes("/")) return false;
  if (pkg === "typescript") return false;

  const res = await fetch("https://registry.npmjs.org/@types/" + pkg);
  const body = await res.json();

  if (body.error) return false;

  const versions: any[] = Object.values(body.versions);
  if (versions[versions.length - 1].deprecated) return false;

  return true;
}

const { flags, unknown: packages } = parseFlags(Deno.args, {
  allowEmpty: true,
  flags: [
    {
      name: "help",
      aliases: ["h"],
      standalone: true,
    },
    {
      name: "remove",
      aliases: ["r"],
      standalone: true,
    },
  ],
});

if (flags.help) {
  console.log(
    [
      "Yarn TS",
      "",
      "$ yarn-ts [packages] [options]",
      "",
      "Options",
      "  -r  Remove dependencies",
    ].join("\n")
  );
  Deno.exit();
}

if (flags.remove) {
  const packageJson = JSON.parse(Deno.readTextFileSync("package.json"));
  if (!packageJson.devDependencies) Deno.exit(1);

  if (packages.length > 0) {
    // Remove packages
    if (!packageJson.dependencies) Deno.exit(1);

    const packagesToRemove = Object.keys(packageJson.devDependencies).filter(
      (pkg) => {
        if (!pkg.startsWith("@types")) return false;
        return packages.includes(pkg.substr(7));
      }
    );

    await exec("yarn remove " + [...packagesToRemove, ...packages].join(" "));
    Deno.exit();
  } else {
    // Remove all types
    const packagesToRemove = Object.keys(packageJson.devDependencies).filter(
      (pkg) => pkg.startsWith("@types") || pkg === "typescript"
    );

    if (packagesToRemove.length > 0) {
      await exec("yarn remove " + packagesToRemove.join(" "));
    }
    Deno.exit();
  }
} else {
  if (packages.length > 0) {
    // Add packages
    const packagesWithTypes = await Promise.all(
      packages.map((dep) => typeof dep === "string" && packageHasTypes(dep))
    );

    const types = packages
      .filter((_, i) => packagesWithTypes[i])
      .map((dep) => `@types/${dep}`);

    await exec("yarn add " + packages.join(" "));
    if (types.length > 0) exec("yarn add -D " + types.join(" "));
    Deno.exit();
  } else {
    // Add base typescript
    const packageJson = JSON.parse(Deno.readTextFileSync("package.json"));

    const dependencies: string[] = [
      ...Object.keys(packageJson.dependencies || {}),
      ...Object.keys(packageJson.devDependencies || {}),
    ];
    let types = ["typescript", "@types/node"];

    if (dependencies.length > 0) {
      const dependenciesWithTypes = await Promise.all(
        dependencies.map((dep) => packageHasTypes(dep))
      );

      types = [
        ...types,
        ...dependencies
          .filter((_, i) => dependenciesWithTypes[i])
          .map((dep) => `@types/${dep}`),
      ];
    }

    await exec("yarn add -D " + types.join(" "));
    Deno.exit();
  }
}
