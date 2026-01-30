# Pretrained Model Weights

This directory contains pretrained model weights for the FOMO25 challenge.

## Available Checkpoints

| Filename | Description | Size |
|----------|-------------|------|
| `fomo25_mmunetvae_pretrained.ckpt` | MultiModalUNetVAE pretrained on FOMO-60K | ~227 MB |

## Usage

### Load using utility function

```python
from utils.load_weights import load_pretrained_checkpoint

# Load the pretrained checkpoint
checkpoint = load_pretrained_checkpoint()

# Access state dict
state_dict = checkpoint['state_dict']

# Access hyperparameters
config = checkpoint['hyper_parameters']
```

### Manual loading

```python
import torch

checkpoint = torch.load('weights/fomo25_mmunetvae_pretrained.ckpt', map_location='cpu')
model.load_state_dict(checkpoint['state_dict'], strict=False)
```

## Model Details

- **Architecture**: MultiModalUNetVAE (mmunetvae)
- **Input channels**: 1 (single modality pretraining)
- **Patch size**: 64x64x64
- **Training**: Self-supervised (MAE-style) on FOMO-60K dataset
- **Epochs**: 100
- **Dataset size**: 10,068 training / 1,119 validation samples

## Notes

- For finetuning with multiple modalities, the input layer weights will be re-initialized
- All encoder weights (74 layers) transfer successfully for downstream tasks
