from lightning.pytorch import cli_lightning_logo
from lightning.pytorch.cli import LightningCLI

from fine_tune.transferLearning import BEATsTransferLearningModel
from datamodules.ECS50DataModule import ECS50DataModule
from callbacks.callbacks import MilestonesFinetuning


class MyLightningCLI(LightningCLI):
    def add_arguments_to_parser(self, parser):
        parser.add_lightning_class_args(MilestonesFinetuning, "finetuning")
        parser.link_arguments("data.batch_size", "model.batch_size")
        parser.link_arguments("finetuning.milestones", "model.milestones")
        parser.set_defaults(
            {
                "trainer.max_epochs": 15,
                "trainer.enable_model_summary": False,
                "trainer.num_sanity_val_steps": 0,
            }
        )

        # RuntimeError: disabling the Config Saving
        self.save_config_callback = None

    def build_data_module(self, data_module_cls):
        return data_module_cls(
            root_dir="data/ESC-50-master/audio/",
            csv_file="data/ESC-50-master/meta/esc50.csv",
            batch_size=self.config["data.batch_size"],
            split_ratio=0.8,
            transform=None,
        )


def cli_main():
    MyLightningCLI(
        BEATsTransferLearningModel, ECS50DataModule, seed_everything_default=42
    )


if __name__ == "__main__":
    cli_lightning_logo()
    cli_main()
