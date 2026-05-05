class ForgeplanMcp < Formula
  desc "MCP server for Forgeplan — expose artifact tools via Model Context Protocol"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.29.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.29.0/forgeplan-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "7af556c2a10a92cf1d33d7b8a533ab1e7991084ec7b1a4dc9e4d4250011769c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.29.0/forgeplan-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "031577a15e1b35a4212085a0681fdfa397e837c16f9d15454eaf02bbada084f3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.29.0/forgeplan-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "72e5c67506255271096794d2f7fe47f8afee287030578c8780982fc8f5ca12e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.29.0/forgeplan-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f4ceb7bf34b6b3823f8e06f24b565fe4076fcab45ae63e006c82ed666c9f54c7"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {
      forgeplan: [
        "fpl",
      ],
    },
    "aarch64-unknown-linux-gnu": {
      forgeplan: [
        "fpl",
      ],
    },
    "x86_64-apple-darwin":       {
      forgeplan: [
        "fpl",
      ],
    },
    "x86_64-pc-windows-gnu":     {
      "forgeplan.exe": [
        "fpl.exe",
      ],
    },
    "x86_64-unknown-linux-gnu":  {
      forgeplan: [
        "fpl",
      ],
    },
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "forgeplan-mcp" if OS.mac? && Hardware::CPU.arm?
    bin.install "forgeplan-mcp" if OS.mac? && Hardware::CPU.intel?
    bin.install "forgeplan-mcp" if OS.linux? && Hardware::CPU.arm?
    bin.install "forgeplan-mcp" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
