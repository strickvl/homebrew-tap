class Panlabel < Formula
  desc "The universal annotation converter"
  homepage "https://github.com/strickvl/panlabel"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/strickvl/panlabel/releases/download/v0.3.0/panlabel-aarch64-apple-darwin.tar.xz"
      sha256 "ef73c76c7fa834c09b3d8c5890164b3f798418abe97a7e39ce2e09639a2ef784"
    end
    if Hardware::CPU.intel?
      url "https://github.com/strickvl/panlabel/releases/download/v0.3.0/panlabel-x86_64-apple-darwin.tar.xz"
      sha256 "e56c4254f3cb4a26948e1e9288e46690a8957c910f74895b5ae6c4fac8714e0b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/strickvl/panlabel/releases/download/v0.3.0/panlabel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ec66b8d1c7d0a2213f7f69e3a999dcde1a4a632c9d59f8920ed5d11a44859559"
    end
    if Hardware::CPU.intel?
      url "https://github.com/strickvl/panlabel/releases/download/v0.3.0/panlabel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6bda4cbf6dc1e3bf36f410cd2f9bce32c6ffac5efb04f81ed61024ca3347688b"
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
