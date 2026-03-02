from datetime import datetime, timedelta, timezone
import requests

DAYS_BACK = 2
IMAGE_EXTS = (".png", ".jpg", ".jpeg")
REPOS = [
    "Azure/Enterprise-Scale",
    "MicrosoftDocs/architecture-center"
]

API = "https://api.github.com"
GITHUB_TOKEN = None  # optional

def gh_get(url):
    headers = {"Accept": "application/vnd.github+json"}
    if GITHUB_TOKEN:
        headers["Authorization"] = f"Bearer {GITHUB_TOKEN}"
    r = requests.get(url, headers=headers, timeout=30)
    r.raise_for_status()
    return r.json()

def within_last_n_days(iso_ts, days):
    commit_time = datetime.fromisoformat(iso_ts.replace("Z", "+00:00"))
    return commit_time >= datetime.now(timezone.utc) - timedelta(days=days)

def main():
    print(f"\nGitHub Image Watch (last {DAYS_BACK} days)\n")

    found_any = False

    for repo in REPOS:
        print(f"\nRepo: {repo}")
        commits = gh_get(f"{API}/repos/{repo}/commits?per_page=50")

        for c in commits:
            commit_ts = c["commit"]["author"]["date"]
            if not within_last_n_days(commit_ts, DAYS_BACK):
                continue

            sha = c["sha"]
            commit = gh_get(f"{API}/repos/{repo}/commits/{sha}")

            for f in commit.get("files", []):
                fname = f["filename"].lower()
                if fname.endswith(IMAGE_EXTS):
                    found_any = True
                    print(f"  - [{f['status']}] {fname}")
                    print(f"    File:   https://github.com/{repo}/blob/{sha}/{f['filename']}")
                    print(f"    Commit: https://github.com/{repo}/commit/{sha}")

    if not found_any:
        print("\nRESULT: No image changes in last 2 days ✅")
    else:
        print("\nRESULT: Image changes found ❗")

if __name__ == "__main__":
    main()