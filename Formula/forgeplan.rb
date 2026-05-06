class Forgeplan < Formula
  desc "CLI for Forgeplan — forge your plan from idea to implementation"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.30.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.30.0/forgeplan-aarch64-apple-darwin.tar.xz"
      sha256 "374fd187df3253ae507af3646b63ed585be31db63b36a30ea42ff6a1ed618dac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.30.0/forgeplan-x86_64-apple-darwin.tar.xz"
      sha256 "8a95f3f09b5cf60275eb4f2c3e1c49c7808ae29c8ed54a25abd8f91f922147c1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.30.0/forgeplan-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "24088c96a6504f2785705fda4bcd10d8c4a03ffb5d8be63a042f03ad7170b055"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.30.0/forgeplan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0618cb45f273384669f1603d8ac00b64aea77c3114a0233162e552fd56db9414"
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
