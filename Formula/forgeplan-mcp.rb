class ForgeplanMcp < Formula
  desc "MCP server for Forgeplan — expose artifact tools via Model Context Protocol"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.23.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.23.0/forgeplan-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "c20fa8be7b15ae2bc226b951c4cfdeace96dc2bd33e2ddd94d15737febe361ab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.23.0/forgeplan-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "405828adc63588d9cf32f8a37621b48cd487d133b0daa611453e8613b06a3bab"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.23.0/forgeplan-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6211b0c4423d072f9b4db4dc87aef3101ab1956a630204ad5b0c1d39fb0b69ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.23.0/forgeplan-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c87d45e3f2a0c0f7472a9266cc2ba447d33b1ab6e3400e92a78cf7e3e0d85bb4"
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
