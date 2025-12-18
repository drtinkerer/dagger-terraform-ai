import dagger
from dagger import dag, function, object_type


@object_type
class TerraformAi:
    @function
    async def plan(self, src: dagger.Directory) -> str:
        """Run terraform plan on the given directory and return the output."""
        return await (
            dag.container()
            .from_("hashicorp/terraform:latest")
            .with_directory("/src", src)
            .with_workdir("/src")
            .with_exec(["terraform", "init"])
            .with_exec(["terraform", "plan"])
            .stdout()
        )

    @function
    async def ai_diagnose(self, src: dagger.Directory) -> str:
        """Run terraform plan, convert to JSON, and diagnose issues with LLM."""
        # 1. Generate plan JSON
        json_plan = await (
            dag.container()
            .from_("hashicorp/terraform:latest")
            .with_directory("/src", src)
            .with_workdir("/src")
            .with_exec(["terraform", "init"])
            .with_exec(["terraform", "plan", "-out=tfplan"])
            .with_exec(["terraform", "show", "-json", "tfplan"])
            .stdout()
        )

        # 2. Call LLM
        return await (
            dag.llm()
            .with_prompt(f"Diagnose this terraform plan and provide a comprehensive summary of changes, potential security risks, and best practices. Keep it very short and brief.:\n\n{json_plan}")
            .last_reply()
        )

