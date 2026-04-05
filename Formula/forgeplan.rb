class Forgeplan < Formula
  desc "CLI for Forgeplan — forge your plan from idea to implementation"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.14.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.14.0/forgeplan-aarch64-apple-darwin.tar.xz"
      sha256 "46298da756edec77ac87a25e3988e4e13f2cbb4f69d7c5bf3382d954b70d2b62"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.14.0/forgeplan-x86_64-apple-darwin.tar.xz"
      sha256 "cdb417a0c1ab8b024292a68d3e9e37e0f28f0464bd2bc8d33b4c04de4e2bf929"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.14.0/forgeplan-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ee42fc49a5cfb2bf3cff2b2283bd54aa225fef44a48c533355a08998818dbafe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.14.0/forgeplan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b0fdc83844eaf01379841cf6a3066cb3437ab4684f186c3f174f3a548f9faf9a"
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
