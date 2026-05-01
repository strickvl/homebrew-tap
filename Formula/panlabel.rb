class Panlabel < Formula
  desc "The universal annotation converter"
  homepage "https://github.com/strickvl/panlabel"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/strickvl/panlabel/releases/download/v0.7.0/panlabel-aarch64-apple-darwin.tar.xz"
      sha256 "a2cfd68e77f2f1627f0d66206bdb68ac953190b52dfe3ebd739667d2e145adac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/strickvl/panlabel/releases/download/v0.7.0/panlabel-x86_64-apple-darwin.tar.xz"
      sha256 "f6af6ce2fbc4ec729955f1c9d2e00dc450b43006e59f1e543c6398d4f4c1224a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/strickvl/panlabel/releases/download/v0.7.0/panlabel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "54b7c0c0cfb93cd71292a2d81a7e3259c226a5ba38f89b8bb164ad51019c3ea4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/strickvl/panlabel/releases/download/v0.7.0/panlabel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "26b3741ca7a7732f466fdef5ec3c6efe1150cfb5a943488ebef0b5b8b36fcea1"
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
