default:
  @just --list

build:
  nixos-rebuild build --flake .#
