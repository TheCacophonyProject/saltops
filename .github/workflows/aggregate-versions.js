import yaml from "yaml";
import fs from "fs";
import util from "util";
import {exec as execAsync} from "child_process";
const exec = util.promisify(execAsync);

const args = process.argv;
const repo = args[2];

const getFilesWithExtension = (path, ext) => {
  console.log(process.cwd());
  console.log(fs.readdirSync(path));
  const items = fs.readdirSync(path)
    .filter(item => (
      !item.startsWith(".") &&
      !item.startsWith("_") &&
      (item.endsWith(`.${ext}`) || fs.lstatSync(`${path}/${item}`).isDirectory())
    ))
    .map(item => ({ name: item, isDir: fs.lstatSync(`${path}/${item}`).isDirectory() }));

  let files = [];
  for (const item of items) {
    if (item.isDir) {
      files = [...files, ...getFilesWithExtension(`${path}/${item.name}`, ext)];
    } else {
      files.push(`${path}/${item.name}`);
    }
  }
  console.log(files);
  return files;
}
const findKeyInObject = (obj, key) => {
  for (const [k, v] of Object.entries(obj)) {
    if (k === key) {
      return v;
    } else if (typeof v === 'object') {
      const deeper = findKeyInObject(v, key);
      if (deeper !== false) {
        return deeper;
      }
    }
  }
  return false;
}
const branches = ["prod", "test", "dev"];
const models = ["pi", "tc2"];
const versionsAreEqual = (prev, next) => {
  for (const branch of branches) {
    if (!prev[branch] || !next[branch]) {
      return false;
    }
    for (const model of models) {
      for (const softwarePackage of Object.keys(prev[branch][model])) {
        if (!next[branch][model][softwarePackage]) {
          return false;
        }
        if (next[branch][model][softwarePackage] !== prev[branch][model][softwarePackage]) {
          return false;
        }
      }
      for (const softwarePackage of Object.keys(next[branch][model])) {
        if (!prev[branch][model][softwarePackage]) {
          return false;
        }
        if (next[branch][model][softwarePackage] !== prev[branch][model][softwarePackage]) {
          return false;
        }
      }
    }
  }
  return true;
};
(async function () {
  const versionData = {};
  console.log(process.cwd());
  process.chdir("../../../");
  console.log(process.cwd());

  for (const branch of branches) {
    // For each branch:
    versionData[branch] = {};
    process.chdir(`./${branch}`);
    for (const model of models) {
      // For each camera model:
      process.chdir(`./${model}`);
      const slsFiles = getFilesWithExtension(".", "sls");
      versionData[branch][model] = {};
      for (const path of slsFiles) {
        const data = fs.readFileSync(path, "utf8");
        try {
          const yamlData = yaml.parse(data);
          const versionInfo = findKeyInObject(yamlData, "cacophony.pkg_installed_from_github");
          const name = versionInfo.find(item => item.hasOwnProperty("name")).name;
          const version = versionInfo.find(item => item.hasOwnProperty("version")).version;
          versionData[branch][model][name] = version;
        } catch (e) {
        }
      }
      process.chdir("../");
    }
    process.chdir("../");
  }
  process.chdir("./salt-version-info");
  let prevVersionData;
  try {
    const prevVersionInfo = fs.readFileSync("./salt-version-info.json", "utf8");
    prevVersionData = JSON.parse(prevVersionInfo);
  } catch (e) {
    console.log(e);
  }
  if ((prevVersionData && !versionsAreEqual(prevVersionData, versionData)) || !prevVersionData) {
    versionData.updated = new Date().toISOString();
    console.log("version info updated", JSON.stringify(versionData, null, '\t'));
    fs.writeFileSync("./salt-version-info.json", JSON.stringify(versionData, null, '\t'));

    if (repo === "TheCacophonyProject/saltops") {
      {
        const {stderr, stdout} = await exec("git config user.name cacophony-bot");
        console.log("1:", stderr, stdout);
      }
      {
        const {stderr, stdout} = await exec("git config user.email bot@cacophony.org.nz");
        console.log("2:", stderr, stdout);
      }
      {
        const {stderr, stdout} = await exec("git add .");
        console.log("3:", stderr, stdout);
      }
      {
        const {stderr, stdout} = await exec("git commit -m \"updated version information\"");
        console.log("4:", stderr, stdout);
      }
      {
        console.log("Pushing");
        const {stderr, stdout} = await exec("git push --force");
        console.log("5:", stderr, stdout);
      }
    }
  } else {
    console.log("version information unchanged");
  }
  process.chdir("../");
}());
