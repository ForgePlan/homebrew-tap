class Forgeplan < Formula
  desc "CLI for Forgeplan — forge your plan from idea to implementation"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.34.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.34.0/forgeplan-aarch64-apple-darwin.tar.xz"
      sha256 "9aec4843371fcf007281c212e845782819ff3a9995888b9f4442d6b3a7fd334d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.34.0/forgeplan-x86_64-apple-darwin.tar.xz"
      sha256 "9be4c04d46254e1f1ef2483de3c8be1d3449e284b26e880577baa3312c54eb13"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.34.0/forgeplan-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "69ad13b8709b61b57f9aaa490b6863fbea55d98d3006a65affb580283fb7ac68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.34.0/forgeplan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "497992c93e9aee277e4a99abb2faa3f7b55cefa500a3013b5ee4c8e99ed38aa1"
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
