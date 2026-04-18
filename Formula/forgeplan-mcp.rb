class ForgeplanMcp < Formula
  desc "MCP server for Forgeplan — expose artifact tools via Model Context Protocol"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.22.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.22.1/forgeplan-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "508f81c7322ad91444012a5abe1ae1172d62f91eb58920911e1c4c3162b42e3c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.22.1/forgeplan-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "f22de297203714e57ad0b30f4417c780f8d45ab53b61dd2ccc94319a99974038"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.22.1/forgeplan-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9951e6530d0b6cc36d06880593ac3895dda3a45953dd9337a5f1fe0d23e8b91b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.22.1/forgeplan-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1e08ea40a334b0ecef25d17272cb25a0502476497c7303117267e608b233399b"
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
