class Panlabel < Formula
  desc "The universal annotation converter"
  homepage "https://github.com/strickvl/panlabel"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/strickvl/panlabel/releases/download/v0.6.0/panlabel-aarch64-apple-darwin.tar.xz"
      sha256 "b6a22ee1b2fbec0f510a89b7a41bfc538a5b134cc6edb5f90e57324653857de6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/strickvl/panlabel/releases/download/v0.6.0/panlabel-x86_64-apple-darwin.tar.xz"
      sha256 "b5e689788d5eac73c78328651a8d1eaff88dc461d43af3e571333d40971080c5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/strickvl/panlabel/releases/download/v0.6.0/panlabel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9edbf20a24316d16d5ba1998fa95b08555711c836da77f426f615bffad117d4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/strickvl/panlabel/releases/download/v0.6.0/panlabel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ee60ff2292eaac84c91ba6d2ff22620c6163a93123c236aa5420389a0333180d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "panlabel" if OS.mac? && Hardware::CPU.arm?
    bin.install "panlabel" if OS.mac? && Hardware::CPU.intel?
    bin.install "panlabel" if OS.linux? && Hardware::CPU.arm?
    bin.install "panlabel" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
