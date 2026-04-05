class ForgeplanCli < Formula
  desc "CLI for Forgeplan — forge your plan from idea to implementation"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.13.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.13.0/forgeplan-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d1b1f2963e6eb285fa151863389fcab957d20d715df61c1030fcae1968043f1f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.13.0/forgeplan-cli-x86_64-apple-darwin.tar.xz"
      sha256 "13b21e09e1c24252755a52a67b7f557e0c4de8f3b6262c8d1eac9f892581a7f1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.13.0/forgeplan-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6bc88fce62e06b8c0e57618d6004ea5ec74124875e774cce4c615fb785884d8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.13.0/forgeplan-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8ad12e14383cdc2d547c369e85faeeb6560989ac9e5a378ba983713496c02afd"
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
