class Forgeplan < Formula
  desc "CLI for Forgeplan — forge your plan from idea to implementation"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.36.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.36.0/forgeplan-aarch64-apple-darwin.tar.xz"
      sha256 "00de2a5e423735b651e82072b0bc3b9677f6c4d75a5943ef886d06252dc4896e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.36.0/forgeplan-x86_64-apple-darwin.tar.xz"
      sha256 "a595c24435748685ac91a656943b92c514659d3a6d301c9d56852de20b1979db"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.36.0/forgeplan-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f1058c48045ebeaf31caa86296d05217997f76a27dc7b3295170c8b52450e23d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.36.0/forgeplan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "963e3dc918675e7a0d8caea0d601990e84725326a5de7e58ec16f19173d4bbe8"
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
      bin.install "forgeplan"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "forgeplan"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "forgeplan"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "forgeplan"
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
