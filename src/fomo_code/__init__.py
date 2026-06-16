# src/fomo_code/__init__.py
# adds src/ to the path so internal relative imports still work:
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))
