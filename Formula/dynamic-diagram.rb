class DynamicDiagram < Formula
  desc "Portable diagram/simulation engine: JSON spec -> SVG/PNG/kitty/animated frames"
  homepage "https://github.com/tzssangglass/dynamic-diagram"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tzssangglass/dynamic-diagram/releases/download/v0.2.1/dynamic-diagram-aarch64-apple-darwin.tar.gz"
      sha256 "eb3a9529ce89a3742a4b0494b9bce46eebd4e2493822eeac43c4542c8d472053"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tzssangglass/dynamic-diagram/releases/download/v0.2.1/dynamic-diagram-x86_64-apple-darwin.tar.gz"
      sha256 "3dd4a820f667c1c579dda7e9742a3f5537c8bda9e099b6b122a531a35cccd84e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tzssangglass/dynamic-diagram/releases/download/v0.2.1/dynamic-diagram-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1ebba8954789941f0d71bb50bf9beedc08e19c209da4ec145989248260fadd61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tzssangglass/dynamic-diagram/releases/download/v0.2.1/dynamic-diagram-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f1097a2423eb8ac3999b0dac4312295d9ee4f41c11ff8b81a51610ecf8f2243a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "dynamic-diagram"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "dynamic-diagram"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "dynamic-diagram"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "dynamic-diagram"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
