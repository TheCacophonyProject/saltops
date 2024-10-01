import yaml from "yaml";
import fs from "fs";
import util from "util";
import {exec as execAsync} from "child_process";
const exec = util.promisify(execAsync);

const args = process.argv;
const repo = args[2];

const getFilesWithExtension = (path, ext) => {
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
const latestCommitDate = async (branch) => {
  try {
    console.log("Getting latest commit date for ", branch);
    const response = await fetch(`https://api.github.com/repos/TheCacophonyProject/saltops/commits?sha=${branch}&per_page=1`);
    if (!response.ok) {
      throw new Error(`Response status: ${response.status}`);
    }

    const commitJson = await response.json();
    const commitDate = commitJson[0]["commit"]["author"]["date"]
    return commitDate
  } catch (error) {
    console.error("Error getting latest commit date ",error.message);
  }
  return "";
}
(async function () {
  const versionData = {};
  console.log(process.cwd());
  process.chdir("../../../");
  console.log(process.cwd());

  for (const branch of branches) {
    // For each branch:
    versionData[branch] = {};
    process.chdir(`./${branch}`);
    const commitDate = await latestCommitDate(branch)
    console.log("Got commit date",commitDate);
    for (const model of models) {
      // For each camera model:
      process.chdir(`./${model}`);
      const slsFiles = getFilesWithExtension(".", "sls");
      versionData[branch][model] = {"commitDate":commitDate};
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
    if (repo === "TheCacophonyProject/saltops") {
      fs.writeFileSync("./salt-version-info.json", JSON.stringify(versionData, null, '\t'));
    }
  } else {
    console.log("version information unchanged");
  }
  process.chdir("../");
}());
