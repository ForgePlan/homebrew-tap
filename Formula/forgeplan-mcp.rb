class ForgeplanMcp < Formula
  desc "MCP server for Forgeplan — expose artifact tools via Model Context Protocol"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.36.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.36.0/forgeplan-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "d6a62906d4142a3073b4ba8fe8190bde2c5ea55e90f5f6047d461ce28448d571"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.36.0/forgeplan-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "d4c2c98a61992acb8b54f36fd8744fe1f43f872d7bc0535404ef30bb2a6b22ca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.36.0/forgeplan-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "066b488498debd570e51a0621813a55e7fbf5fcb7fe073d3061e9c866058e82b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.36.0/forgeplan-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "44feaf2baeefc995f8254a9ff9eda04462abea811e73410f464382e4af4d9195"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "forgeplan-mcp"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "forgeplan-mcp"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "forgeplan-mcp"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "forgeplan-mcp"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
