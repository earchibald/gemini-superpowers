# Gemini Superpowers Documentation

## Overview

Gemini Superpowers adapts the powerful [Superpowers framework](https://github.com/obra/superpowers) for use with Google Gemini CLI. This project provides a set of tools and configurations to enable an autonomous agent workflow within your Gemini CLI environment, fostering a Test-Driven Development (TDD) approach, systematic debugging, and comprehensive planning.

## How it Works

The `install-superpowers.sh` script sets up your Gemini CLI environment by:
1. Cloning the core Superpowers skills to a local cache.
2. Generating native Gemini CLI slash commands (`.toml` files) that point to these skills.
3. Injecting a "Loop of Autonomy" protocol into your `~/.gemini/GEMINI.md` to guide Gemini CLI's behavior.

## Key Features

- **Autonomous Agent Workflow:** Leverage the Superpowers protocol for structured, iterative development.
- **Enhanced Productivity:** Access specialized commands for planning, TDD, debugging, and more.
- **Seamless Integration:** Designed to work natively with Gemini CLI's command system.

## Getting Started

Refer to the main `README.md` for installation instructions. Once installed, explore the available commands using `/superpowers` or consult the [Cheatsheet](CHEATSHEET.md).

## Cost Model (Gemini Specific)

(This section will be expanded upon in a later task after investigation)