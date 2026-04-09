class Forgeplan < Formula
  desc "CLI for Forgeplan — forge your plan from idea to implementation"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.17.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.17.1/forgeplan-aarch64-apple-darwin.tar.xz"
      sha256 "3008051cb65b43a24aadf02852287863c3c73e66e6aced52b402b15f17772b2e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.17.1/forgeplan-x86_64-apple-darwin.tar.xz"
      sha256 "e0979de8971d3b0fc72e69184be93452ce04de55ba881aee9c9c7d904ad49d73"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.17.1/forgeplan-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b60199581adbb0b3c6870422152c517e93f8fdcf627d6fb3d604fac45ed75433"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.17.1/forgeplan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "496c3653b0202914a25d17e56069b751330c8e9b3e959aa8c8e40900c90c9e71"
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
