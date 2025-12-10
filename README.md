# Terraform AI Dagger Module

A Dagger module that runs Terraform plans and uses AI to diagnose and analyze the plan for potential issues, security risks, and best practices.

## Features

- **Plan**: Run `terraform plan` on any directory.
- **Diagnose**: Run `terraform plan`, convert it to JSON, and send it to an LLM (using Dagger's AI integration) for a comprehensive analysis.

## Prerequisites

- [Dagger CLI](https://docs.dagger.io/install/) installed.
- Docker running.
- An LLM API key configured in your environment (e.g., `OPENAI_API_KEY` for OpenAI).

## Quickstart

Clone the repository and try the example:

```bash
# 1. Run a standard Terraform plan
dagger call plan --src ./example

# 2. Run an AI Diagnosis of the plan
dagger call ai-diagnose --src ./example
```

## Remote Usage

You can use this module directly from GitHub without cloning:

```bash
# Run AI Diagnosis
dagger -m github.com/drtinkerer/dagger-terraform-ai call ai-diagnose --src .
```

(Ensure you are running this from a directory containing your Terraform files).
