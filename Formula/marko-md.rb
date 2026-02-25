class MarkoMd < Formula
  desc "A terminal markdown editor"
  homepage "https://github.com/sstrelsov/marko"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sstrelsov/marko/releases/download/v0.1.6/marko-md-aarch64-apple-darwin.tar.gz"
      sha256 "7d4f7337dab1b03848f41a1b1e92022572612fe656acbed4305cd10aecf3148b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sstrelsov/marko/releases/download/v0.1.6/marko-md-x86_64-apple-darwin.tar.gz"
      sha256 "e1a749a8e44b913ab93ffdb767351ea362ee8894825a48e9491cadba0a06e25b"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/sstrelsov/marko/releases/download/v0.1.6/marko-md-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cbdb125996e61870fae29600240eccdc0f1a7d23866844fc494b98f257ceaca0"
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
