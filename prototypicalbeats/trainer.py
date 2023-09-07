from pytorch_lightning import cli_lightning_logo
from pytorch_lightning.cli import LightningCLI

from prototypicalbeats.prototraining import ProtoBEATsModel
from datamodules.miniECS50DataModule import miniECS50DataModule
from callbacks.callbacks import MilestonesFinetuning


class MyLightningCLI(LightningCLI):
    def add_arguments_to_parser(self, parser):
        parser.add_lightning_class_args(MilestonesFinetuning, "finetuning")
        parser.link_arguments("finetuning.milestones", "model.milestones")
        parser.set_defaults(
            {
                "trainer.enable_model_summary": False,
                "trainer.num_sanity_val_steps": 0,
            }
        )

        # RuntimeError: disabling the Config Saving
        self.save_config_callback = None


def cli_main():
    MyLightningCLI(
        ProtoBEATsModel,
        datamodule_class=miniECS50DataModule,
        seed_everything_default=42,
    )


if __name__ == "__main__":
    cli_lightning_logo()
    cli_main()
