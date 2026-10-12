class ForgeplanMcp < Formula
  desc "MCP server for Forgeplan — expose artifact tools via Model Context Protocol"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.38.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.38.0/forgeplan-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "444897ee505b952fae0c1069367efb0bbcf6250c0e0b1516d822636e40d19c67"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.38.0/forgeplan-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "53da6dace24955ae035f8ee45aed767296aace06c848cbafdf1818e36d316f19"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.38.0/forgeplan-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1785b151718a4fec23906edd647cc84ae2cc8d9347a4e62759870ee03d46de1e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.38.0/forgeplan-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "012a0220565eda8697a9090e070cdcbdaa8172fe9786d3498fbced63ec6448d0"
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
