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
