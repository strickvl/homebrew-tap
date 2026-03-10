class Panlabel < Formula
  desc "The universal annotation converter"
  homepage "https://github.com/strickvl/panlabel"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/strickvl/panlabel/releases/download/v0.5.0/panlabel-aarch64-apple-darwin.tar.xz"
      sha256 "8a01bae515ba276e85847779cd0cd0860dd99778d73f7a3375afe9f00214cc07"
    end
    if Hardware::CPU.intel?
      url "https://github.com/strickvl/panlabel/releases/download/v0.5.0/panlabel-x86_64-apple-darwin.tar.xz"
      sha256 "b39c8cb85bdcbf245a7675edb358c3ebe6f7dbac850b500ad8df05a984dc2897"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/strickvl/panlabel/releases/download/v0.5.0/panlabel-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "aaf084b843bccfb9180cde3e444c37da4142145fd73859c39f271dcb29c3a479"
    end
    if Hardware::CPU.intel?
      url "https://github.com/strickvl/panlabel/releases/download/v0.5.0/panlabel-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4e6a051ad8a41b7359a7d5d5d4206ad1bf1295391514a4b0dc38316d53adbf81"
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
