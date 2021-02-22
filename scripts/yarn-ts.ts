import { exec } from "https://deno.land/x/exec/mod.ts";
import { parse } from "https://deno.land/std/flags/mod.ts";

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

const args = parse(Deno.args);

if (args.help || args.h) {
  console.log(
    [
      "Yarn TS",
      "",
      "$ yarn-ts [packages] [options]",
      "",
      "Options",
      "  -p  Remove dependencies",
    ].join("\n")
  );
  Deno.exit();
}

if (args.r) {
  const packageJson = JSON.parse(Deno.readTextFileSync("package.json"));
  if (!packageJson.devDependencies) Deno.exit(1);

  let packages = Object.assign([], args._)

  if(typeof args.r === 'string') packages.push(args.r)

  if (packages.length > 0) {
    // Remove packages
    if (!packageJson.dependencies) Deno.exit(1);

    const packagesToRemove = Object.keys(packageJson.devDependencies).filter(
      (pkg) => {
        if (!pkg.startsWith("@types")) return false;
        return packages.includes(pkg.substr(7));
      }
    );

    await exec(
      "yarn remove " +
        [
          ...packagesToRemove,
          ...(typeof args.r === "string" ? [args.r] : []),
          ...packages,
        ].join(" ")
    );
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
  let packages = Object.assign([], args._)

  if (packages.length > 0) {
    // Add packages
    const packagesWithTypes = await Promise.all(
      packages.map((dep) => typeof dep === "string" && packageHasTypes(dep))
    );

    const types = packages.filter((_, i) => packagesWithTypes[i]).map(
      (dep) => `@types/${dep}`
    );

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
