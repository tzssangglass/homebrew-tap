class DynamicDiagram < Formula
  desc "Portable diagram/simulation engine: JSON spec -> SVG/PNG/kitty/animated frames"
  homepage "https://github.com/tzssangglass/dynamic-diagram"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tzssangglass/dynamic-diagram/releases/download/v0.2.2/dynamic-diagram-aarch64-apple-darwin.tar.gz"
      sha256 "6bb2150d5cb827e64ad8314097742a817f0449472653cc1b0cefd4aa082e1908"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tzssangglass/dynamic-diagram/releases/download/v0.2.2/dynamic-diagram-x86_64-apple-darwin.tar.gz"
      sha256 "03eb87ba154416af53c0c0b902a8002d9298b1b49bbd5e32b1f0b208c34e939e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tzssangglass/dynamic-diagram/releases/download/v0.2.2/dynamic-diagram-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7b24703f432e791dcb5d39a7e0c5e494df7b0aafe71706492b2e8e2b60edcf00"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tzssangglass/dynamic-diagram/releases/download/v0.2.2/dynamic-diagram-x86_64-unknown-linux-musl.tar.gz"
      sha256 "807d10e9939ef6d27c5de9e787dbf062e17054d9a6342b6d7e30f77f83211b41"
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
