class Forgeplan < Formula
  desc "CLI for Forgeplan — forge your plan from idea to implementation"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.35.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.35.0/forgeplan-aarch64-apple-darwin.tar.xz"
      sha256 "0032e4d959a458617eb82837b7fb1d75b2e1dd494759f5ddaf4d9b7755b8e424"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.35.0/forgeplan-x86_64-apple-darwin.tar.xz"
      sha256 "f6bf8041906e35c9ee3963e04b4bd9f3edf484d793872eb440fc42e1e52f007b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.35.0/forgeplan-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "854ba0b812376c49e53a3144bd58c30abe99ebfdd6a33b0c438cbfa3a5a3d142"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.35.0/forgeplan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "31b87a370c00acbb3f8a9ce758890577e3a5e3c4e0e13d3368b9fd4eef5cb9f9"
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
