class Forgeplan < Formula
  desc "CLI for Forgeplan — forge your plan from idea to implementation"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.27.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.27.0/forgeplan-aarch64-apple-darwin.tar.xz"
      sha256 "6c980553a9d78bee91cb1a0c57fb27e4369d0efe80e24f13508ff5bb0d7cdaff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.27.0/forgeplan-x86_64-apple-darwin.tar.xz"
      sha256 "732c3f879a1724fd2d50ba61f32eaf2a93869efe86574f019c76d96700e960f1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.27.0/forgeplan-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "81367f2dbe5cdf80003d77004cdc58b2072b23537eddb588ece207e98718c044"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.27.0/forgeplan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bae5e8f695cc94dfc308292b79e5127f521f2eb84f573a33298fbc797f5a10f2"
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
    bin.install "forgeplan" if OS.mac? && Hardware::CPU.arm?
    bin.install "forgeplan" if OS.mac? && Hardware::CPU.intel?
    bin.install "forgeplan" if OS.linux? && Hardware::CPU.arm?
    bin.install "forgeplan" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
