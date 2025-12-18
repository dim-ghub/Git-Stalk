# Git-Stalk

Bash script to list recent commits from any user across GitHub and GitLab platforms.

## Features

- **Multi-platform support**: Works with both GitHub and GitLab
- **Repository filtering**: Filter commits by specific repository
- **Pagination support**: Navigate through large commit histories with offset and count options
- **API token support**: Use personal access tokens to avoid rate limiting
- **Verbose output**: Get detailed debugging information
- **Formatted results**: Clean, numbered output with commit details
- **Error handling**: Comprehensive error handling with helpful messages

## Requirements

- **bash**: Compatible shell environment
- **curl**: For making HTTP API requests
- **jq**: For JSON parsing and formatting

### Installation of Dependencies

#### Ubuntu/Debian:
```bash
sudo apt-get update
sudo apt-get install curl jq
```

#### Fedora/CentOS/RHEL:
```bash
sudo dnf install curl jq
# or for older systems:
sudo yum install curl jq
```

#### macOS:
```bash
brew install curl jq
```

#### Arch Linux:
```bash
sudo pacman -S curl jq
```

#### Alpine Linux:
```bash
apk add curl jq
```

## Installation

### Quick Install (Recommended)

#### One-line installation:
```bash
curl -fsSL https://raw.githubusercontent.com/dim-ghub/Git-Stalk/main/install.sh | bash
```

#### System-wide installation:
```bash
curl -fsSL https://raw.githubusercontent.com/dim-ghub/Git-Stalk/main/install.sh | sudo bash -s -- --system
```

#### Custom directory:
```bash
curl -fsSL https://raw.githubusercontent.com/dim-ghub/Git-Stalk/main/install.sh | bash -s -- --dir ~/bin
```

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/dim-ghub/Git-Stalk.git
cd Git-Stalk
```

2. (Optional) Move to a directory in your PATH:
```bash
sudo mv git-stalk /usr/local/bin/
```

## Usage

### Basic Syntax
```bash
git-stalk [OPTIONS]
```

### Required Parameters
- `-u, --user <user>`: Username to stalk

### Optional Parameters
- `-r, --repo <repo>`: Repository filter (format: `owner/repo` for GitHub)
- `-g, --gitlab`: Use GitLab instead of GitHub (default: GitHub)
- `-o, --offset <offset>`: Starting offset for pagination (default: 0)
- `-c, --count <count>`: Number of commits to fetch (default: 10, max: 100)
- `-t, --token <token>`: API token for authentication
- `-v, --verbose`: Verbose output for debugging
- `-h, --help`: Show help message

## Examples

### Basic GitHub Usage
```bash
# Get recent commits from a GitHub user
git-stalk -u octocat

# Get commits from a specific repository
git-stalk -u octocat -r octocat/Hello-World

# Get more commits with pagination
git-stalk -u torvalds -c 25

# Start from offset 20 (skip first 20 commits)
git-stalk -u torvalds -o 20 -c 10
```

### GitLab Usage
```bash
# Get recent commits from a GitLab user
git-stalk -g -u username

# Get commits from a specific GitLab project
git-stalk -g -u username -r group/project

# Use with token for GitLab
git-stalk -g -u username -t your_gitlab_token
```

### Using API Tokens

#### GitHub Token:
1. Go to [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens)
2. Generate a new token with `public_repo` scope (or `repo` for private repositories)
3. Use the token:
```bash
git-stalk -u username -t ghp_your_token_here
```

#### GitLab Token:
1. Go to [GitLab User Settings > Access Tokens](https://gitlab.com/-/profile/personal_access_tokens)
2. Generate a new token with `read_api` scope
3. Use the token:
```bash
git-stalk -g -u username -t glpat-your_token_here
```

### Verbose Mode
```bash
# See API URLs and debug information
git-stalk -v -u octocat
```

## Output Format

The output displays commits in the following format:
```
<number> | <timestamp> | <repository> | <commit message>
```

Example:
```
1 | 2024-01-15T10:30:45Z | octocat/Hello-World | Add new feature
2 | 2024-01-14T15:22:10Z | octocat/Spoon-Knife | Fix bug in parser
3 | 2024-01-13T09:45:33Z | octocat/Hello-World | Update documentation
```

## Rate Limiting

- **GitHub**: 60 requests/hour without authentication, 5000 requests/hour with token
- **GitLab**: Rate limits apply, significantly higher with authentication

Using API tokens is recommended for frequent usage.

## Error Handling

The script provides helpful error messages for:
- Missing required parameters
- Invalid API tokens
- Rate limiting
- Non-existent users or repositories
- Network connectivity issues

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
