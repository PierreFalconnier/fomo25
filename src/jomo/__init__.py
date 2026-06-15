import logging
import sys
from pathlib import Path

logging.getLogger().setLevel(logging.INFO)


# Automatically find where src/jomo/ is installed in site-packages
_jomo_root = str(Path(__file__).resolve().parent)

# Append src/jomo directly to sys.path at runtime
# This makes internal absolute imports like `from models...` findable!
if _jomo_root not in sys.path:
    sys.path.insert(0, _jomo_root)
