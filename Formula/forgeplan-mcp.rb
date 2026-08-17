class ForgeplanMcp < Formula
  desc "MCP server for Forgeplan — expose artifact tools via Model Context Protocol"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.34.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.34.0/forgeplan-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "4eb6d1fb6b4e9f367bb0a642a269d1a1ebad9dd79d3dce097b66d38c14cbc998"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.34.0/forgeplan-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "778146b4e033560792faf1217eb0425051cf437d506831acb2aced82b4bd7c1d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.34.0/forgeplan-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9272c4310e00c800ae41155cadbe88c00ca1bc7042011acf8ef2b7fa5e5080df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.34.0/forgeplan-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b705a92169dffce199fa78bde0a8b5ca2c3c3ebe4b56fe60095bf9c971f1700d"
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
