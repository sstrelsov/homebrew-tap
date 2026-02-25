class Marko < Formula
  desc "A terminal markdown editor"
  homepage "https://github.com/sstrelsov/marko"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sstrelsov/marko/releases/download/v0.1.8/marko-md-aarch64-apple-darwin.tar.gz"
      sha256 "0e0d9f2075a9de0f0558b3948496c0d8c328dd25be77be13d1277688a898df5b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sstrelsov/marko/releases/download/v0.1.8/marko-md-x86_64-apple-darwin.tar.gz"
      sha256 "ca3a4e3638c7d3b8329acb77104bd79e1cf51436d9d4badd68006df522049771"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/sstrelsov/marko/releases/download/v0.1.8/marko-md-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0af965c9aa566e3a9e03d751690646149f1062742ddc180f2385c0ab82ed4b0e"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "marko" if OS.mac? && Hardware::CPU.arm?
    bin.install "marko" if OS.mac? && Hardware::CPU.intel?
    bin.install "marko" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
