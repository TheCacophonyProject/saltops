import requests
import os
import yaml

def get_latest_release(repo_url, headers):
    response = requests.get(f"{repo_url}/releases/latest", headers=headers)
    #print(f"Response status code for latest release: {response.status_code}")
    #print(f"Response text for latest release: {response.text}")
    response.raise_for_status()

    if response.text:
        try:
            return response.json().get("tag_name")
        except ValueError:
            print("Error parsing JSON response for latest release.")
            return None
    else:
        print("Empty response received for latest release.")
        return None

def get_main_commit(repo_url, headers, branch):
    response = requests.get(f"{repo_url}/branches/{branch}", headers=headers)
    response.raise_for_status()
    return response.json()["commit"]["sha"]
    
def check_release_up_to_date(repo_url, headers, branch="main"):
    latest_release = get_latest_release(repo_url, headers)
    if not latest_release:
        return False
    main_commit = get_main_commit(repo_url, headers, branch)
    latest_release_commit = get_commit_sha(repo_url, latest_release, headers)
    return main_commit == latest_release_commit

def get_commit_sha(repo_url, tag, headers):
    response = requests.get(f"{repo_url}/git/refs/tags/{tag}", headers=headers)
    response.raise_for_status()
    return response.json()["object"]["sha"]

def read_salt_file(file_path):
    with open(file_path, "r") as file:
        return yaml.safe_load(file)

def update_salt_file(salt_path, repo_name, latest_release):
    salt_content = read_salt_file(salt_path)
    updated = False
    
    for key, value in salt_content.items():
        if isinstance(value, dict) and 'cacophony.pkg_installed_from_github' in value:
            for item in value['cacophony.pkg_installed_from_github']:
                if isinstance(item, dict) and item.get('name') == repo_name and item.get('version') != latest_release:
                    item['version'] = latest_release
                    updated = True
    
    if updated:
        with open(salt_path, "w") as file:
            yaml.dump(salt_content, file)
        print(f"Updated Salt file at {salt_path} with release {latest_release}")
    else:
        print(f"Salt file at {salt_path} is already up to date with release {latest_release}")

def find_sls_files(directory):
    sls_files = []
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".sls"):
                sls_files.append(os.path.join(root, file))
    return sls_files

def extract_repos_from_sls(sls_files):
    repo_info = []
    
    for sls_file in sls_files:
        with open(sls_file, "r") as file:
            content = yaml.safe_load(file)
        for _, value in content.items():
            if isinstance(value, dict) and 'cacophony.pkg_installed_from_github' in value:
                data = value['cacophony.pkg_installed_from_github']
                combine_data = {}
                for i in data:
                    combine_data = combine_data | i
                data = combine_data
                #print(data)
                repo_info.append({
                    "repo_name": data['name'],
                    "version": "v"+data['version'],
                    "salt_path": sls_file,
                    "url": f"https://api.github.com/repos/TheCacophonyProject/{data['name']}",
                    "branch": data.get('branch', None)
                })
    return repo_info

def main():
    # Check if there is a token file
    if not os.path.exists("github_token.txt"):
        print("No github_token.txt file found. Please create one with your Github token. No permissions are needed for the github token it is just used to stop from getting rate limited.")
        return
    # Read user token file
    with open("github_token.txt", "r") as file:
        token = file.read().strip()
    headers = {"Authorization": f"token {token}"}
    #headers = {}
    sls_files = find_sls_files("./tc2")
    print(f"Found {len(sls_files)} sls files in ./tc2")
    repo_info = extract_repos_from_sls(sls_files)
    print(f"Found {len(repo_info)} repos in {len(sls_files)} sls files")
    

    for repo in repo_info:
        repo_url = repo["url"]
        salt_path = repo["salt_path"]
        repo_name = repo["repo_name"]
        repo_version = repo["version"]
        branch = "main"
        if repo["branch"] is not None:
            branch = repo["branch"]
        
        try:
            print(f"Checking {repo_name}...")

            # Check that the latest release is up to date
            is_up_to_date = check_release_up_to_date(repo_url, headers, branch)
            if not is_up_to_date:
                print(f"\tlatest release is not up to date with branch '{branch}'. Make a new release.")
                continue
            
            # Check that the latest release is what is in the .sls file.
            latest_release = get_latest_release(repo_url, headers)
            if not latest_release:
                print(f"\tFailed to get the latest release for {repo_url}")
                continue            
            
            if latest_release != repo_version:
                print(f"\tlatest release is {latest_release} but {repo_version} is in the .sls file. Update the .sls file.")
            else:
                print(f"\tUp to date.")

            #update_salt_file(salt_path, repo["repo_name"], latest_release)

        except requests.exceptions.RequestException as e:
            print(f"Error fetching data from {repo_url}: {e}")

if __name__ == "__main__":
    main()
