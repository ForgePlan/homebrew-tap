class ForgeplanMcp < Formula
  desc "MCP server for Forgeplan — expose artifact tools via Model Context Protocol"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.23.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.23.1/forgeplan-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "82fda4fcb23a36eda2a826ef319894def6489aba1220db6ced756bc80df50e7f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.23.1/forgeplan-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "93f2159211dfb20c4848a171bb38c62dd68575e7d2556403edfce606c21c5d1c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.23.1/forgeplan-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "80baa0ed6b8968559c914e26ef07bd43f5aed3fc20df34c450711393700f4587"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.23.1/forgeplan-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "63730ba5592120b3f8de29db75e538f05f49e0725bbcd863526f470c057bf16f"
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
