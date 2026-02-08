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

Understanding the cost implications of using Gemini Superpowers is crucial. Gemini's pricing is primarily based on token usage for both input (prompts) and output (responses). The Superpowers framework, with its emphasis on structured prompts, iterative development, and subagent delegation, can influence your Gemini API costs in several ways:

- **Structured Prompting:** While Superpowers encourages more detailed and structured prompts (e.g., comprehensive plans, detailed TDD steps), this can lead to higher input token counts per interaction. However, these structured prompts aim to reduce the need for multiple clarifying interactions, potentially leading to a more efficient overall process.
- **Iterative Development:** The Red-Green-Refactor cycle and systematic debugging often involve several turns of small, focused interactions. Each turn consumes tokens. The efficiency gained from a structured approach can offset the token cost of multiple turns by reducing overall time to resolution and minimizing irrelevant responses.
- **Subagent Usage:** When subagents are dispatched, they operate within their own context, which can increase the total token usage across multiple concurrent or sequential tasks. Monitoring subagent interactions will be important for cost management.

**Recommendations for Cost Optimization:**
- **Be Concise:** While structuring prompts, aim for clarity and conciseness to avoid unnecessary token consumption.
- **Leverage Context:** The Superpowers protocol encourages maintaining context through `plan.md` and `scratchpad.md`, which can help reduce redundant information in prompts.
- **Monitor Usage:** Regularly review your Gemini API usage to understand cost patterns and identify areas for optimization.

By promoting efficient workflows and focused interactions, Gemini Superpowers aims to provide significant value, but users should be mindful of token usage, especially with complex tasks and extensive subagent use.