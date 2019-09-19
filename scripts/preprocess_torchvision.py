import torchvision

torchvision.datasets.ImageNet(".", split="train", download=True)
torchvision.datasets.ImageNet(".", split="val", download=True)
