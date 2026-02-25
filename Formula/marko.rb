class Marko < Formula
  desc "A terminal markdown editor"
  homepage "https://github.com/sstrelsov/marko"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sstrelsov/marko/releases/download/v0.1.4/marko-aarch64-apple-darwin.tar.gz"
      sha256 "6121998ed840bb0b043f3b0644749f753cd2914a5eb03e67a1b364ff5652de8d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sstrelsov/marko/releases/download/v0.1.4/marko-x86_64-apple-darwin.tar.gz"
      sha256 "baee8351bcf88f07e58aa959c65ccc259a23d3617927ec3f668a498cb27f9675"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/sstrelsov/marko/releases/download/v0.1.4/marko-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "aa7586679d99f6da54df29fa06406e0b6e7b22f9227be3fd77d690c8ae4214ce"
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
