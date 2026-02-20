class Marko < Formula
  desc "A terminal markdown editor"
  homepage "https://github.com/sstrelsov/marko"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sstrelsov/marko/releases/download/v0.1.3/marko-aarch64-apple-darwin.tar.gz"
      sha256 "9515d454ef28535d23cebe7ac43c6fdd18c1e242ac0beba541b16769e08f1e38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sstrelsov/marko/releases/download/v0.1.3/marko-x86_64-apple-darwin.tar.gz"
      sha256 "ecb442f11045573c6f532dc96ecf8442463133b7cc569b10a77761b80bdba12c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/sstrelsov/marko/releases/download/v0.1.3/marko-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5a528dc1d205f08e93f0f6cc1a0310137f73bdb17203b2b2245d8575b86d91ee"
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
