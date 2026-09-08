class Forgeplan < Formula
  desc "CLI for Forgeplan — forge your plan from idea to implementation"
  homepage "https://github.com/ForgePlan/forgeplan"
  version "0.37.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.37.0/forgeplan-aarch64-apple-darwin.tar.xz"
      sha256 "70a81930555a074f9181103e2a6cb60999cbb32db8f0e062e1bf700a2a078af7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.37.0/forgeplan-x86_64-apple-darwin.tar.xz"
      sha256 "cbf476cdd62a1883d34912af878963c9873c741a561e6277eba50f0fc45d9ddd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.37.0/forgeplan-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8a99ad0b00dec035c5e8b1ccc4b77fd4518893c8c7c2ad304302ed08d1276ddb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ForgePlan/forgeplan/releases/download/v0.37.0/forgeplan-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d59ce22028986d4f8eb72df68c8f139ce6e23ceda15bf62d2c8e76ad348c5b39"
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
