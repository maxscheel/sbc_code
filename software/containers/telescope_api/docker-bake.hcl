variable "DEFAULT_TAG" {
  default = "telescope-api:local"
}

# https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" {}

# Default target
group "default" {
  targets = ["image-local"]
}

# All targets
group "all" {
  targets = ["image-all"]
}

target "image" {
  context = "."
  dockerfile = "Dockerfile"
  output = ["type=image,compression=zstd,compression-level=3,force-compression=true"]
  args = {
    BUILDKIT_INLINE_CACHE = 1
    MAKEFLAGS = "-j$(nproc)"
    CARGO_BUILD_JOBS = "$(nproc)"
    NODE_OPTIONS = "--max-old-space-size=4096"
  }
}

target "image-local" {
  inherits = ["image"]
  tags = ["${DEFAULT_TAG}"]
  platforms = ["linux/amd64"]
  output = ["type=image,compression=zstd,compression-level=3,force-compression=true"]
}

target "image-all" {
  inherits = ["image"]
  tags = ["${DEFAULT_TAG}"]
  platforms = [
    "linux/amd64",
    "linux/arm/v7",
    "linux/arm64"
  ]
  output = ["type=image,compression=zstd,compression-level=3,force-compression=true"]
}

target "image-cross" {
  inherits = ["image", "docker-metadata-action"]
  platforms = [
    "linux/amd64",
    "linux/arm/v7",
    "linux/arm64"
  ]
  cache-from = ["type=gha,compression=zstd"]
  cache-to = ["type=gha,mode=max,compression=zstd"]
  output = ["type=image,compression=zstd,compression-level=3,force-compression=true"]
}

target "image-main" {
  inherits = ["image", "docker-metadata-action"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
  cache-from = ["type=gha,compression=zstd"]
  cache-to = ["type=gha,mode=max,compression=zstd"]
  output = ["type=image,compression=zstd,compression-level=3,force-compression=true"]
}

target "image-armv7" {
  inherits = ["image", "docker-metadata-action"]
  platforms = [
    "linux/arm/v7"
  ]
  cache-from = ["type=gha,compression=zstd"]
  cache-to = ["type=gha,mode=max,compression=zstd"]
  output = ["type=image,compression=zstd,compression-level=3,force-compression=true"]
}

target "image-armv7-local" {
  inherits = ["image", "docker-metadata-action"]
  platforms = [
    "linux/arm/v7"
  ]
  cache-from = [
    "type=local,src=/var/cache/buildx,compression=zstd",
    "type=gha,compression=zstd"
  ]
  cache-to = [
    "type=local,dest=/var/cache/buildx,mode=max,compression=zstd",
    "type=gha,mode=max,compression=zstd"
  ]
  output = ["type=image,compression=zstd,compression-level=3,force-compression=true"]
  args = {
    BUILDKIT_INLINE_CACHE = 1
    MAKEFLAGS = "-j$(nproc)"
    CARGO_BUILD_JOBS = "$(nproc)"
    NODE_OPTIONS = "--max-old-space-size=2048"
    CPUS = "$(nproc)"
  }
}


target "test" {
  inherits = ["image"]
  target = "test-builder"
  platforms = ["linux/amd64"]
  output = ["type=cacheonly"]
}
