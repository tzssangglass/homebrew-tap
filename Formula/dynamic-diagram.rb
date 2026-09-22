class DynamicDiagram < Formula
  desc "Portable diagram/simulation engine: JSON spec -> SVG/PNG/kitty/animated frames"
  homepage "https://github.com/tzssangglass/dynamic-diagram"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tzssangglass/dynamic-diagram/releases/download/v0.2.0/dynamic-diagram-aarch64-apple-darwin.tar.gz"
      sha256 "4c8c7c183d9c254698d5b36d4bdfc8439988cd139f9a9cf0d546d3efc59507fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tzssangglass/dynamic-diagram/releases/download/v0.2.0/dynamic-diagram-x86_64-apple-darwin.tar.gz"
      sha256 "2c891edfd34424914d916fb6062c5ef7fdddbb0b5d5def2c7f1c6cf3f87e22ce"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tzssangglass/dynamic-diagram/releases/download/v0.2.0/dynamic-diagram-aarch64-unknown-linux-musl.tar.gz"
      sha256 "327c00bd904261d6eb6c1c558d520d6f30969857824ea5b4b1d21eb30915b6cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tzssangglass/dynamic-diagram/releases/download/v0.2.0/dynamic-diagram-x86_64-unknown-linux-musl.tar.gz"
      sha256 "05f2e2bd4d1d6f6517e949924790be97058db72985b8b9bab32dee6990888e5d"
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
