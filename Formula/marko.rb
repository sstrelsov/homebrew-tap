class Marko < Formula
  desc "A terminal markdown editor"
  homepage "https://github.com/sstrelsov/marko"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sstrelsov/marko/releases/download/v0.1.3/marko-aarch64-apple-darwin.tar.gz"
      sha256 "13e2236629047eed85acf2f7b828f4d09b5006d9de663781dcdcdf453b476655"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sstrelsov/marko/releases/download/v0.1.3/marko-x86_64-apple-darwin.tar.gz"
      sha256 "c72801f2629b58a3637b3913808bc437b286e57f471b61a100b7721bd5b758e9"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/sstrelsov/marko/releases/download/v0.1.3/marko-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "726ed757b310f99a9f71571b35175321a949871125e3364d42a79215fb4233bf"
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
