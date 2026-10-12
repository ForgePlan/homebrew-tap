class Forgeplan < Formula
  desc "CLI for Forgeplan — forge your plan from idea to implementation"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.38.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.38.0/forgeplan-aarch64-apple-darwin.tar.xz"
      sha256 "e5af4032f04155f073432aecd7aeb0a483041db0a58a49b9e027f762af259210"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.38.0/forgeplan-x86_64-apple-darwin.tar.xz"
      sha256 "590b36c092df4df647a131ff3a22d5ae92f58637acc9d5d3803dc59493b7af7d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.38.0/forgeplan-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "949cf7ecb36de7329f0d84b3de2b49f6ec23063b47f40abc945c3e9f28de0daa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.38.0/forgeplan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1568bc2d6fdafcb1ca985b00dfebe79caf87066a0bbc0ab850fbeae33f5cbee3"
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
