class ForgeplanMcp < Formula
  desc "MCP server for Forgeplan — expose artifact tools via Model Context Protocol"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.28.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.28.0/forgeplan-mcp-aarch64-apple-darwin.tar.xz"
      sha256 "0e88a097e2489dd56921cc2ee7dc408da4a2225bbed556474253a55a2f621086"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.28.0/forgeplan-mcp-x86_64-apple-darwin.tar.xz"
      sha256 "b24c55c70a72b1cb8e8750436a2e29c1e572243db8631dc019700994aa09cffd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.28.0/forgeplan-mcp-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3f23eb806dcf953bd6f0a6232cf5a3d55763adfea76dc0ab0a34f4160c220a51"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.28.0/forgeplan-mcp-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fa0ae372cc36284997015ff757b9c20c6e42f03689ef2167ac1b4412a1a18ef7"
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
