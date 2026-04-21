# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.


# install nodejs (for :copilot enable)
sudo apt update
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
node --version

# Install Neovim (latest, not the ancient repo version)

```
# Grab the latest stable release
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

# Extract and move to a proper location
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# Symlink to make it available in PATH
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

# Verify
nvim --version
```

# update fzf (search)

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install

remove old version

sudo apt remove fzf
hash -r          # clear bash's cached command lookup
fzf --version    # should now show 0.71.0


# Python
Before starting nvim, do
```

```
source .venv/bin/activate
```


```
