class Panlabel < Formula
  desc "The universal annotation converter"
  homepage "https://github.com/strickvl/panlabel"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/strickvl/panlabel/releases/download/v0.4.0/panlabel-aarch64-apple-darwin.tar.xz"
      sha256 "93dc494f728f504b14e9e5e3a800a9d0e94dc815307a621e3fa7aef5f32eaae9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/strickvl/panlabel/releases/download/v0.4.0/panlabel-x86_64-apple-darwin.tar.xz"
      sha256 "0f7a9214a0899963d4dcd3f6d57ba7ac28f5575edddc058f8576f13edf176a96"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/strickvl/panlabel/releases/download/v0.4.0/panlabel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c5edecc68f6d39e59290ffb9ecf6375bbd11541d9a99333b9b994263e7323dd8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/strickvl/panlabel/releases/download/v0.4.0/panlabel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7d056bb210866195908614b4f4db8e2d4f1d9bcb6f61703219351b6254bcf6ca"
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
